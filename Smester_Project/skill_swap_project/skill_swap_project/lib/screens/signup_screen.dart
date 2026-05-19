import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';
import '../widgets/buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> _selectedOffered = [];
  final List<String> _selectedWanted = [];

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      // CHECK OFFERED SKILLS
      if (_selectedOffered.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least 1 offered skill')),
        );

        return;
      }

      // CHECK WANTED SKILLS
      if (_selectedWanted.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least 1 skill to learn')),
        );

        return;
      }

      try {
        setState(() => _isLoading = true);

        // CREATE USER
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // SAVE USER DATA TO FIRESTORE
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,

              'name': _nameController.text.trim(),

              'email': _emailController.text.trim(),

              'skillsOffered': _selectedOffered,

              'skillsWanted': _selectedWanted,

              'createdAt': FieldValue.serverTimestamp(),
            });

        if (!mounted) return;

        setState(() => _isLoading = false);

        Navigator.pushReplacementNamed(context, AppStrings.home);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        setState(() => _isLoading = false);

        String message = "Signup Failed";

        if (e.code == 'email-already-in-use') {
          message = "Email already exists";
        } else if (e.code == 'weak-password') {
          message = "Weak password";
        } else if (e.code == 'invalid-email') {
          message = "Invalid email";
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        if (!mounted) return;

        setState(() => _isLoading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,

      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),

      prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),

      filled: true,
      fillColor: AppColors.surface,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _buildSkillSection(
    String title,
    String subtitle,
    List<String> selected,
    Color activeColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(title, style: AppTextStyles.h5),

        const SizedBox(height: 4),

        Text(subtitle, style: AppTextStyles.bodySmall),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,

          children: AppStrings.skillSuggestions.map((skill) {
            final isSelected = selected.contains(skill);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(skill);
                  } else {
                    selected.add(skill);
                  }
                });
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: isSelected ? activeColor : AppColors.surfaceVariant,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: isSelected ? activeColor : AppColors.border,
                  ),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),

                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),

                    Text(
                      skill,

                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,

                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary,
          ),

          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text('Create Account', style: AppTextStyles.h2),

              const SizedBox(height: 6),

              Text(
                'Join the community of skill exchangers',
                style: AppTextStyles.bodySmall,
              ),

              const SizedBox(height: 32),

              // Name
              _buildFieldLabel('Full Name'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,

                style: AppTextStyles.bodyMedium,

                decoration: _inputDecoration(
                  'Ali Hassan',
                  Icons.person_outline_rounded,
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Name is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Email
              _buildFieldLabel('Email'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,

                keyboardType: TextInputType.emailAddress,

                style: AppTextStyles.bodyMedium,

                decoration: _inputDecoration(
                  'your@email.com',
                  Icons.email_outlined,
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Email required';
                  }

                  if (!v.contains('@')) {
                    return 'Invalid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Password
              _buildFieldLabel('Password'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _passwordController,

                obscureText: _obscurePassword,

                style: AppTextStyles.bodyMedium,

                decoration:
                    _inputDecoration(
                      '••••••••',
                      Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,

                          color: AppColors.textHint,

                          size: 20,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Password required';
                  }

                  if (v.length < 6) {
                    return 'Minimum 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Skills Offered
              _buildSkillSection(
                'Skills You Can Offer',
                'Select skills you can teach others',
                _selectedOffered,
                AppColors.secondary,
              ),

              const SizedBox(height: 28),

              // Skills Wanted
              _buildSkillSection(
                'Skills You Want to Learn',
                'Select skills you want to learn',
                _selectedWanted,
                AppColors.primary,
              ),

              const SizedBox(height: 36),

              PrimaryButton(
                label: 'Create Account',
                onPressed: _signup,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),

                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',

                      style: AppTextStyles.bodySmall,

                      children: [
                        TextSpan(
                          text: 'Login',

                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,

      style: AppTextStyles.labelMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}