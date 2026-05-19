import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_fonts.dart';
import '../models/models.dart';
import 'chat_screen.dart';

class RequestsTabScreen extends StatefulWidget {
  const RequestsTabScreen({super.key});

  @override
  State<RequestsTabScreen> createState() => _RequestsTabScreenState();
}

class _RequestsTabScreenState extends State<RequestsTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Pending | Accepted | Rejected
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ================= CHAT ID =================
  String _getChatId(String a, String b) {
    return a.hashCode <= b.hashCode ? '${a}_$b' : '${b}_$a';
  }

  // ================= CREATE CHAT =================
  Future<void> _createChat(String u1, String u2) async {
    final chatId = _getChatId(u1, u2);

    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'users': [u1, u2],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
    }, SetOptions(merge: true));
  }

  // ================= UPDATE STATUS =================
  Future<void> _updateStatus(
    String requestId,
    String status,
    String fromUserId,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('swap_requests')
          .doc(requestId)
          .update({'status': status});

      if (status == 'accepted') {
        await _createChat(currentUser.uid, fromUserId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (status == 'rejected') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request rejected'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ================= CANCEL / DELETE REQUEST =================
  Future<void> _deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('swap_requests')
          .doc(requestId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request cancelled successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ================= OPEN CHAT =================
  void _openChat(String userId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final chatId = _getChatId(currentUser.uid, userId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(chatId: chatId),
      ),
    );
  }

  // ================= GET USER NAME =================
  Future<String> _getUserName(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return 'Unknown User';

      final data = doc.data();

      return data?['name'] ??
          data?['fullName'] ??
          data?['username'] ??
          data?['displayName'] ??
          data?['email'] ??
          'Unknown User';
    } catch (_) {
      return 'Unknown User';
    }
  }

  // ================= STREAM =================
  Stream<List<RequestModel>> _getRequests() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('swap_requests')
        .where(
          Filter.or(
            Filter('toUserId', isEqualTo: user.uid),
            Filter('fromUserId', isEqualTo: user.uid),
          ),
        )
        .snapshots()
        .asyncMap((snapshot) async {
      List<RequestModel> list = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final fromUserId = data['fromUserId'] ?? '';
        final toUserId = data['toUserId'] ?? '';

        String displayUserName = '';
        if (fromUserId == user.uid) {
          displayUserName = data['toUserName'] ?? data['receiverName'] ?? '';
          if (displayUserName.isEmpty) {
            displayUserName = await _getUserName(toUserId);
          }
        } else {
          displayUserName = data['fromUserName'] ?? data['senderName'] ?? data['name'] ?? '';
          if (displayUserName.isEmpty) {
            displayUserName = await _getUserName(fromUserId);
          }
        }

        list.add(
          RequestModel(
            id: doc.id,
            fromUserId: fromUserId,
            fromUserName: displayUserName, 
            toUserId: toUserId,
            toUserName: '',
            skillRequested: data['requestedSkill'] ?? data['skillRequested'] ?? '',
            skillOffered: data['offeredSkill'] ?? data['skillOffered'] ?? '',
            message: data['message'] ?? '',
            status: _parseStatus(data['status'] ?? 'pending'),
            createdAt: data['timestamp'] != null
                ? (data['timestamp'] as Timestamp).toDate()
                : DateTime.now(),
          ),
        );
      }

      return list;
    });
  }

  // ================= STATUS PARSER =================
  RequestStatus _parseStatus(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return RequestStatus.pending;
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Accepted"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: _getRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final requests = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(requests, RequestStatus.pending),
              _buildList(requests, RequestStatus.accepted),
              _buildList(requests, RequestStatus.rejected),
            ],
          );
        },
      ),
    );
  }

  // ================= LIST UI =================
  Widget _buildList(
    List<RequestModel> all,
    RequestStatus status,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final filtered = all.where((e) => e.status == status).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("No requests"));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final r = filtered[i];
        final isOutgoing = r.fromUserId == currentUser?.uid;

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      r.fromUserName,
                      style: AppTextStyles.h3,
                    ),
                  ),
                  if (isOutgoing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Sent",
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text("Wants: ${r.skillRequested}"),
              Text("Offers: ${r.skillOffered}"),
              const SizedBox(height: 10),
              Text(r.message),
              const SizedBox(height: 12),

              // ================= FORCE ALL PENDING ACTION BUTTONS =================
              if (r.status == RequestStatus.pending)
                Column(
                  children: [
                    Row(
                      children: [
                        // 1. ACCEPT BUTTON
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _updateStatus(
                              r.id,
                              'accepted',
                              r.fromUserId,
                            ),
                            child: const Text("Accept"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 2. REJECT BUTTON
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _updateStatus(
                              r.id,
                              'rejected',
                              r.fromUserId,
                            ),
                            child: const Text("Reject"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 3. CANCEL BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            onPressed: () => _deleteRequest(r.id),
                            child: const Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              // ================= ACCEPTED ACTIONS =================
              if (r.status == RequestStatus.accepted)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openChat(isOutgoing ? r.toUserId : r.fromUserId),
                        child: const Text("Open Chat"),
                      ),
                    ),
                  ],
                ),

              // ================= STATUS BADGE =================
              if (r.status != RequestStatus.pending)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    r.status.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: r.status == RequestStatus.accepted ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}