import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';
import '../widgets/buttons.dart';
import '../widgets/navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isUploading = false;

  Future<void> _uploadProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
      );

      if (pickedFile == null) return;

      setState(() {
        isUploading = true;
      });

      File imageFile = File(pickedFile.path);

      final bytes = await imageFile.readAsBytes();

      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'profileImage': base64Image},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  void _showEditProfileDialog(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final nameController = TextEditingController(text: data['name'] ?? '');

    final offeredController = TextEditingController(
      text: (data['skillsOffered'] ?? []).join(', '),
    );

    final wantedController = TextEditingController(
      text: (data['skillsWanted'] ?? []).join(', '),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: offeredController,
                decoration: const InputDecoration(
                  labelText: 'Skills Offered',
                  hintText: 'Flutter, UI Design',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: wantedController,
                decoration: const InputDecoration(
                  labelText: 'Skills Wanted',
                  hintText: 'Python, AI',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
          ),

          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;

              if (user == null) return;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                    'name': nameController.text.trim(),

                    'skillsOffered': offeredController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),

                    'skillsWanted': wantedController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                  });

              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Updated Successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppCustomAppBar(
        title: 'My Profile',
        showBack: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () {
              Navigator.pushNamed(context, AppStrings.settings);
            },
          ),
        ],
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User profile not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final String name = data['name'] ?? 'User';

          final String email = data['email'] ?? '';

          final String profileImage = data['profileImage'] ?? '';

          final List<String> skillsOffered = List<String>.from(
            data['skillsOffered'] ?? [],
          );

          final List<String> skillsWanted = List<String>.from(
            data['skillsWanted'] ?? [],
          );

          final dynamic rating = data['rating'] ?? 0;

          final dynamic totalSwaps = data['totalSwaps'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: isUploading ? null : _uploadProfileImage,
                            child: CircleAvatar(
                              radius: 50,

                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),

                              backgroundImage: profileImage.isNotEmpty
                                  ? MemoryImage(base64Decode(profileImage))
                                  : null,

                              child: profileImage.isEmpty
                                  ? Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : 'U',

                                      style: AppTextStyles.h1.copyWith(
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,

                            child: GestureDetector(
                              onTap: isUploading ? null : _uploadProfileImage,
                              child: Container(
                                width: 32,
                                height: 32,

                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),

                                child: isUploading
                                    ? Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.camera_alt,
                                        size: 18,
                                        color: colorScheme.primary,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        name,
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),

                      Text(
                        email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatBadge(label: 'Rating', value: '$rating'),

                          const SizedBox(width: 24),

                          _StatBadge(label: 'Swaps', value: '$totalSwaps'),

                          const SizedBox(width: 24),

                          _StatBadge(
                            label: 'Skills',
                            value: '${skillsOffered.length}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _SectionCard(
                  title: 'Skills I Offer',
                  icon: Icons.arrow_upward_rounded,
                  color: colorScheme.secondary,
                  chips: skillsOffered,
                  chipColor: colorScheme.secondary,
                  chipBg: colorScheme.secondaryContainer,
                ),

                const SizedBox(height: 16),

                _SectionCard(
                  title: 'Skills I Want',
                  icon: Icons.arrow_downward_rounded,
                  color: colorScheme.primary,
                  chips: skillsWanted,
                  chipColor: colorScheme.primary,
                  chipBg: colorScheme.primaryContainer,
                ),

                const SizedBox(height: 24),

                SecondaryButton(
                  label: 'Edit Profile',
                  onPressed: () {
                    _showEditProfileDialog(context, data);
                  },
                  icon: Icons.edit_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: Colors.white)),

        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  final List<String> chips;

  final Color chipColor;
  final Color chipBg;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.chips,
    required this.chipColor,
    required this.chipBg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),

              const SizedBox(width: 8),

              Text(
                title,
                style: AppTextStyles.h5.copyWith(color: colorScheme.onSurface),
              ),
            ],
          ),

          const SizedBox(height: 12),

          chips.isEmpty
              ? Text(
                  'No skills added yet',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: chips
                      .map(
                        (chip) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: chipBg,

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(
                              color: chipColor.withValues(alpha: 0.2),
                            ),
                          ),

                          child: Text(
                            chip,

                            style: AppTextStyles.bodySmall.copyWith(
                              color: chipColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
