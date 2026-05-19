import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F7FC),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.onSurface,
        title: Text(
          "Explore Skills",
          style: AppTextStyles.h3.copyWith(
            color: c.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Discover Skills",
                        style: AppTextStyles.h2.copyWith(
                          color: c.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Find talented people to learn and grow together",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: c.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [c.primary, c.secondary]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: c.onSurface),
              decoration: InputDecoration(
                hintText: "Search skills, users...",
                prefixIcon: Icon(Icons.search, color: c.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),

          // USERS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final skills =
                      List<String>.from(data['skillsOffered'] ?? []);

                  final name =
                      (data['name'] ?? '').toString().toLowerCase();

                  final email =
                      (data['email'] ?? '').toString().toLowerCase();

                  final matches =
                      _searchQuery.isEmpty ||
                      name.contains(_searchQuery) ||
                      email.contains(_searchQuery) ||
                      skills.any((s) =>
                          s.toLowerCase().contains(_searchQuery));

                  return skills.isNotEmpty && matches;
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No users found"),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    return _ExploreUserCard(
                      userId: docs[index].id,
                      name: data['name'] ?? 'User',
                      email: data['email'] ?? '',
                      category: data['category'] ?? 'General',
                      rating:
                          (data['rating'] ?? 4.5).toDouble(),
                      skillsOffered: List<String>.from(
                          data['skillsOffered'] ?? []),
                      skillsWanted: List<String>.from(
                          data['skillsWanted'] ?? []),
                      profileImage: data['profileImage'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= USER CARD =================

class _ExploreUserCard extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String category;
  final double rating;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final String? profileImage;

  const _ExploreUserCard({
    required this.userId,
    required this.name,
    required this.email,
    required this.category,
    required this.rating,
    required this.skillsOffered,
    required this.skillsWanted,
    this.profileImage,
  });

  Uint8List? _decode(String? img) {
    try {
      if (img == null || img.isEmpty) return null;
      return base64Decode(img);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageBytes = _decode(profileImage);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: c.primaryContainer,
                backgroundImage:
                    imageBytes != null ? MemoryImage(imageBytes) : null,
                child: imageBytes == null
                    ? Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTextStyles.h4.copyWith(
                            color: c.onSurface)),
                    Text(email,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Text("⭐ ${rating.toStringAsFixed(1)}"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            children: skillsOffered
                .take(3)
                .map((e) => Chip(label: Text(e)))
                .toList(),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppStrings.skillListing,
                  arguments: {'userId': userId},
                );
              },
              child: const Text("View Profile"),
            ),
          )
        ],
      ),
    );
  }
}