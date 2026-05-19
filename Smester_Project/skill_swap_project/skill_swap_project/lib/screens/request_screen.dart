import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/navigation.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final Map<String, String?> _selectedSkillMap = {};
  final Map<String, TextEditingController> _messageControllers = {};
  final Map<String, bool> _loadingMap = {};

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final List<String> _fallbackSkills = [
    "Flutter",
    "UI/UX Design",
    "Photoshop",
    "Video Editing",
    "Python",
    "Public Speaking",
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> _marketStream() {
    return _firestore.collection('users').snapshots();
  }

  List<String> _extractSkills(Map<String, dynamic>? data) {
    if (data == null) return [];

    final raw = data['skills'];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<void> _sendRequest({
    required String targetUserId,
    required String requestedSkill,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final selectedSkill = _selectedSkillMap[targetUserId];

    if (selectedSkill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a skill to offer")),
      );
      return;
    }

    setState(() {
      _loadingMap[targetUserId] = true;
    });

    try {
      await _firestore.collection('swap_requests').add({
        'fromUserId': currentUser.uid,
        'toUserId': targetUserId,
        'requestedSkill': requestedSkill,
        'offeredSkill': selectedSkill,
        'message': _messageControllers[targetUserId]?.text.trim() ?? '',
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _loadingMap[targetUserId] = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent 🎉")),
      );
    } catch (e) {
      setState(() {
        _loadingMap[targetUserId] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget _skillChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar(title: "Find Swap"),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _marketStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index].data();
              final userId = users[index].id;

              if (userId == _auth.currentUser?.uid) {
                return const SizedBox.shrink();
              }

              final name = data['name'] ?? 'Unknown User';
              final skills = _extractSkills(data);
              final displaySkills =
                  skills.isEmpty ? _fallbackSkills : skills;

              _messageControllers.putIfAbsent(
                userId,
                () => TextEditingController(),
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Colors.blue.withValues(alpha: 0.2),
                          child: Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.verified, color: Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      children: displaySkills
                          .map((s) => _skillChip(s))
                          .toList(),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedSkillMap[userId],
                        isExpanded: true,
                        hint: const Text("Select skill to offer"),
                        underline: const SizedBox(),
                        items: _fallbackSkills.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedSkillMap[userId] = v;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _messageControllers[userId],
                      decoration: InputDecoration(
                        hintText: "Write a message...",
                        filled: true,
                        fillColor: Colors.grey.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: (_loadingMap[userId] == true)
                            ? const Text("Sending...")
                            : const Text("Send Request"),
                        onPressed: () {
                          _sendRequest(
                            targetUserId: userId,
                            requestedSkill: displaySkills.first,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}