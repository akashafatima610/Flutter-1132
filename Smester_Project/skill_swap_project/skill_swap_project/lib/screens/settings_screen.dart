import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_strings.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // ================= FUNCTIONS =================

  void _editProfile() {
    Navigator.pushNamed(context, AppStrings.profile);
  }

  // ================= CHANGE PASSWORD =================

  Future<void> _changePassword() async {
    try {
      if (user?.email == null) return;

      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);

      if (!context.mounted) return;

      _showSnack('Password reset email sent!');
    } catch (e) {
      if (!context.mounted) return;

      _showSnack('Error: $e');
    }
  }

  // ================= DELETE ACCOUNT =================

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),

          content: const Text(
            'Are you sure you want to permanently delete your account? '
            'This action cannot be undone.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final uid = currentUser.uid;

      // ================= DELETE USER DOCUMENT =================

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // ================= DELETE USER SKILLS =================

      final skillsSnapshot = await FirebaseFirestore.instance
          .collection('skills')
          .where('userId', isEqualTo: uid)
          .get();

      for (final doc in skillsSnapshot.docs) {
        await doc.reference.delete();
      }

      // ================= DELETE SWAP REQUESTS =================

      final swapRequestsSnapshot = await FirebaseFirestore.instance
          .collection('swap_requests')
          .where('senderId', isEqualTo: uid)
          .get();

      for (final doc in swapRequestsSnapshot.docs) {
        await doc.reference.delete();
      }

      // ================= DELETE CHATS =================

      final chatsSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .get();

      for (final chatDoc in chatsSnapshot.docs) {
        final data = chatDoc.data();

        // Delete chats involving this user
        if (data.toString().contains(uid)) {
          // Delete messages subcollection
          final messages = await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatDoc.id)
              .collection('messages')
              .get();

          for (final msg in messages.docs) {
            await msg.reference.delete();
          }

          // Delete chat document
          await chatDoc.reference.delete();
        }
      }

      // ================= DELETE AUTH ACCOUNT =================

      await currentUser.delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully'),

          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,

        AppStrings.login,

        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;

      switch (e.code) {
        case 'requires-recent-login':
          message = 'Please log in again before deleting your account.';
          break;

        case 'network-request-failed':
          message = 'No internet connection.';
          break;

        default:
          message = e.message ?? 'Failed to delete account.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Database error occurred.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting account: $e')));
    }
  }

  // ================= OTHER FUNCTIONS =================

  void _openNotifications() {
    _showSnack('Notifications screen coming soon');
  }

  void _changeLanguage() {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: const Text('Select Language'),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            ListTile(
              title: const Text('English'),

              onTap: () {
                Navigator.pop(context);

                _showSnack('English selected');
              },
            ),

            ListTile(
              title: const Text('Urdu'),

              onTap: () {
                Navigator.pop(context);

                _showSnack('Urdu selected');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDarkMode(bool value) {
    ThemeController.toggle(value);

    _showSnack(value ? 'Dark Mode Enabled' : 'Light Mode Enabled');
  }

  void _openPrivacy() {
    _showSnack('Privacy Policy coming soon');
  }

  void _openAbout() {
    _showSnack('App Version 3.0.0');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(title: const Text('Settings')),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ================= ACCOUNT =================
            _SettingsSection(
              title: 'Account',

              colorScheme: colorScheme,

              items: [
                _SettingsItem(
                  icon: Icons.person_outline_rounded,

                  label: 'Edit Profile',

                  onTap: _editProfile,
                ),

                _SettingsItem(
                  icon: Icons.lock_outline_rounded,

                  label: 'Change Password',

                  onTap: _changePassword,
                ),

                _SettingsItem(
                  icon: Icons.notifications_outlined,

                  label: 'Notifications',

                  onTap: _openNotifications,
                ),
              ],
            ),

            // ================= PREFERENCES =================
            _SettingsSection(
              title: 'Preferences',

              colorScheme: colorScheme,

              items: [
                _SettingsItem(
                  icon: Icons.language_outlined,

                  label: 'Language',

                  trailing: const Text('English'),

                  onTap: _changeLanguage,
                ),

                _SettingsItem(
                  icon: Icons.dark_mode_outlined,

                  label: 'Dark Mode',

                  trailing: Switch(
                    value: isDark,

                    activeThumbColor: colorScheme.primary,

                    onChanged: _toggleDarkMode,
                  ),

                  onTap: () {},
                ),
              ],
            ),

            // ================= SUPPORT =================
            _SettingsSection(
              title: 'Support',

              colorScheme: colorScheme,

              items: [
                _SettingsItem(
                  icon: Icons.help_outline_rounded,

                  label: 'Help & FAQ',

                  onTap: () {
                    _showSnack('Help coming soon');
                  },
                ),

                _SettingsItem(
                  icon: Icons.privacy_tip_outlined,

                  label: 'Privacy Policy',

                  onTap: _openPrivacy,
                ),

                _SettingsItem(
                  icon: Icons.info_outline_rounded,

                  label: 'About App',

                  trailing: const Text('v1.0.0'),

                  onTap: _openAbout,
                ),
              ],
            ),

            // ================= LOGOUT + DELETE =================
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  // LOGOUT BUTTON
                  OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;

                      Navigator.pushReplacementNamed(context, AppStrings.login);
                    },

                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),

                    icon: const Icon(Icons.logout_rounded),

                    label: const Text('Logout'),
                  ),

                  const SizedBox(height: 14),

                  // DELETE ACCOUNT BUTTON
                  FilledButton.icon(
                    onPressed: _deleteAccount,

                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),

                      backgroundColor: Colors.red,
                    ),

                    icon: const Icon(Icons.delete_forever_rounded),

                    label: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SECTION WIDGET =================

class _SettingsSection extends StatelessWidget {
  final String title;

  final List<_SettingsItem> items;

  final ColorScheme colorScheme;

  const _SettingsSection({
    required this.title,

    required this.items,

    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),

          child: Text(
            title,

            style: TextStyle(
              fontSize: 14,

              fontWeight: FontWeight.w700,

              color: colorScheme.onSurface,
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),

          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,

            borderRadius: BorderRadius.circular(14),
          ),

          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],

                  if (i != items.length - 1)
                    Divider(
                      height: 1,

                      color: colorScheme.outlineVariant,

                      indent: 52,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ================= ITEM WIDGET =================

class _SettingsItem extends StatelessWidget {
  final IconData icon;

  final String label;

  final Widget? trailing;

  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,

    required this.label,

    this.trailing,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        width: 38,
        height: 38,

        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.15),

          borderRadius: BorderRadius.circular(10),
        ),

        child: Icon(icon, color: colorScheme.primary, size: 18),
      ),

      title: Text(
        label,

        style: TextStyle(
          color: colorScheme.onSurface,

          fontSize: 15,

          fontWeight: FontWeight.w500,
        ),
      ),

      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,

            color: colorScheme.onSurfaceVariant,
          ),

      onTap: onTap,
    );
  }
}
