import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';
import '../widgets/navigation.dart';
import 'explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;

  final User? _user = FirebaseAuth.instance.currentUser;

  late AnimationController _controller;
  late Animation<double> _fade;

  ColorScheme get c => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= LOGOUT =================
  void _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppStrings.login,
      (route) => false,
    );
  }

  // ================= NAVIGATION =================
  void _handleNav(int i) {
    if (i == 0) {
      setState(() => _navIndex = 0);
    } else if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExploreScreen()),
      );
    } else if (i == 2) {
      Navigator.pushNamed(context, AppStrings.requestsTab);
    } else if (i == 3) {
      Navigator.pushNamed(context, AppStrings.chat);
    } else if (i == 4) {
      Navigator.pushNamed(context, AppStrings.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1120)
          : const Color(0xFFF4F8FF),

      body: SafeArea(child: _navIndex == 0 ? _home() : const ExploreScreen()),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: _handleNav,
      ),
    );
  }

  // ================= HOME =================
  Widget _home() {
    return FadeTransition(
      opacity: _fade,

      child: Column(
        children: [
          _header(),

          const SizedBox(height: 16),

          _quickActions(),

          const SizedBox(height: 20),

          _sectionTitle("Your Skills"),

          const SizedBox(height: 12),

          _skillsCarousel(),

          const SizedBox(height: 20),

          _sectionTitle("Recent Activity"),

          const SizedBox(height: 12),

          Expanded(child: _activityList()),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid)
          .snapshots(),

      builder: (context, snapshot) {
        String fullName = _user?.displayName ?? "User";
        String email = _user?.email ?? "Welcome back";

        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          fullName = data['name'] ?? fullName;
          email = data['email'] ?? email;
        }

        return Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary.withValues(alpha: 0.12), Colors.transparent],
            ),
          ),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Hello 👋 $fullName",

                      style: AppTextStyles.h3.copyWith(
                        color: c.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      email,

                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton(
                onSelected: (_) => _logout(),

                itemBuilder: (_) => const [
                  PopupMenuItem(value: 1, child: Text("Logout")),
                ],

                child: CircleAvatar(
                  radius: 24,

                  backgroundColor: c.primary,

                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _quickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Row(
        children: [
          Expanded(
            child: _card(
              icon: Icons.add,
              title: "Skill Details",
              subtitle: "Share knowledge",

              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppStrings.skillListing,

                  arguments: {'userId': _user?.uid},
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: _card(
              icon: Icons.swap_horiz,
              title: "Find Swap",
              subtitle: "Connect & exchange",

              onTap: () {
                Navigator.pushNamed(context, AppStrings.request);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _card({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF182235) : Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : c.outline.withValues(alpha: 0.10),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),

              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.12),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon, color: c.primary, size: 22),
            ),

            const SizedBox(height: 14),

            Text(
              title,

              style: AppTextStyles.bodyMedium.copyWith(
                color: c.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style: AppTextStyles.caption.copyWith(color: c.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SKILLS =================
  Widget _skillsCarousel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 190,

      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No skills available",
                style: TextStyle(color: c.onSurfaceVariant),
              ),
            );
          }

          return PageView.builder(
            controller: PageController(viewportFraction: 0.87),

            itemCount: docs.length,

            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;

              final skills = List<String>.from(data['skillsOffered'] ?? []);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF111827)]
                        : [const Color(0xFFEAF4FF), const Color(0xFFDCEBFF)],
                  ),

                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : c.primary.withValues(alpha: 0.08),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),

                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,

                          backgroundColor: c.primary.withValues(alpha: 0.15),

                          child: Icon(Icons.person, color: c.primary),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            data['name'] ?? "User",

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: AppTextStyles.h4.copyWith(
                              color: c.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Skills Offered",

                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: skills.isEmpty
                          ? Text(
                              "No skills added",

                              style: AppTextStyles.bodySmall.copyWith(
                                color: c.onSurfaceVariant,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,

                                children: skills
                                    .take(6)
                                    .map(
                                      (e) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 7,
                                        ),

                                        decoration: BoxDecoration(
                                          color: c.primary.withValues(
                                            alpha: 0.12,
                                          ),

                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(
                                          e,

                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: c.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
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

  // ================= ACTIVITY =================
  Widget _activityList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      children: [
        _activity(Icons.swap_horiz, "Swap request received", "2h ago"),

        _activity(Icons.chat, "New message", "5h ago"),

        _activity(Icons.star, "Someone rated you", "1d ago"),
      ],
    );
  }

  Widget _activity(IconData icon, String title, String sub) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF182235) : Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : c.outline.withValues(alpha: 0.08),
        ),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: c.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: c.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  sub,

                  style: AppTextStyles.caption.copyWith(
                    color: c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: AppTextStyles.h4.copyWith(
            color: c.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}