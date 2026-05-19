import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';
import '../widgets/buttons.dart';
import '../widgets/navigation.dart';

class SkillListingScreen extends StatefulWidget {
  const SkillListingScreen({super.key});

  @override
  State<SkillListingScreen> createState() => SkillListingScreenState();
}

class SkillListingScreenState extends State<SkillListingScreen> {
  String? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map && args['userId'] != null) {
      userId = args['userId'];
    }
  }

  void editAbout(String currentAbout) {
    final controller = TextEditingController(text: currentAbout);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit About"),
          content: TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Write something about yourself...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({'about': controller.text});

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget buildSkillChips(List skills) {
    final theme = Theme.of(context);

    if (skills.isEmpty) {
      return Text("No skills added", style: theme.textTheme.bodySmall);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            skill.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final headingColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    if (userId == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: Text('No skill data found')),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppCustomAppBar(title: 'Skill Detail'),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};

          final String userName = data['name'] ?? 'Unknown User';
          final String about = data['about'] ?? 'No description available';
          final String category = data['category'] ?? 'General';

          final double rating = (data['rating'] ?? 4.5).toDouble();
          final int reviewCount = data['reviewCount'] ?? 0;

          final List skillsOffered =
              (data['skillsOffered'] is List) ? data['skillsOffered'] : [];

          final List skillsWanted =
              (data['skillsWanted'] is List) ? data['skillsWanted'] : [];

          // ✅ FIX: match Explore screen field names
          final String imageUrl = (
            data['profileImage'] ??
            data['profilePic'] ??
            data['photoURL'] ??
            data['image'] ??
            ''
          ).toString().trim();

          final bool hasImage =
              imageUrl.isNotEmpty && imageUrl.startsWith('http');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= PROFILE CARD =================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 32,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.15),

                        backgroundImage:
                            hasImage ? NetworkImage(imageUrl) : null,

                        child: !hasImage
                            ? Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : '?',
                                style: AppTextStyles.h2.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: AppTextStyles.h4.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),

                            RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star,
                                      color: Colors.amber),
                              itemCount: 5,
                              itemSize: 16,
                            ),

                            Text(
                              '$rating · $reviewCount reviews',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Skill Exchange',
                  style: AppTextStyles.h4.copyWith(color: headingColor),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.arrow_upward_rounded,
                        label: 'Offering',
                        valueWidget: buildSkillChips(skillsOffered),
                        color: theme.colorScheme.secondary,
                        bg: theme.colorScheme.secondary.withValues(alpha: 0.12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.arrow_downward_rounded,
                        label: 'Wants',
                        valueWidget: buildSkillChips(skillsWanted),
                        color: theme.colorScheme.primary,
                        bg: theme.colorScheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About',
                      style: AppTextStyles.h4.copyWith(color: headingColor),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editAbout(about),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  about,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),

                const SizedBox(height: 24),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  label: 'Request Swap',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppStrings.request,
                      arguments: {
                        'userId': userId,
                        'userName': userName,
                        'skill': skillsOffered.isNotEmpty
                            ? skillsOffered.first
                            : '',
                      },
                    );
                  },
                  icon: Icons.handshake_outlined,
                ),

                const SizedBox(height: 12),

                SecondaryButton(
                  label: 'Send Message',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppStrings.chat,
                      arguments: {
                        'userId': userId,
                        'name': userName,
                      },
                    );
                  },
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= DETAIL CARD =================
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget valueWidget;
  final Color color;
  final Color bg;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.valueWidget,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          valueWidget,
        ],
      ),
    );
  }
}