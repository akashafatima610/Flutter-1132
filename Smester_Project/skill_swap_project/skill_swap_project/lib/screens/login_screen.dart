// ========================== LOGIN SCREEN ==========================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/app_strings.dart';
import '../constants/app_fonts.dart';
import '../widgets/buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool _isLoading = false;

  // ================= EMAIL LOGIN =================

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),

          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        setState(() => _isLoading = false);

        Navigator.pushReplacementNamed(context, AppStrings.home);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        setState(() => _isLoading = false);

        String message;

        switch (e.code) {
          case 'user-not-found':
            message = 'No account found with this email. Please sign up first.';
            break;

          case 'wrong-password':
            message = 'Incorrect password. Please try again.';
            break;

          case 'invalid-email':
            message = 'Please enter a valid email address.';
            break;

          case 'invalid-credential':
            message = 'Invalid email or password.';
            break;

          case 'user-disabled':
            message = 'This account has been disabled.';
            break;

          case 'network-request-failed':
            message = 'No internet connection. Please check your network.';
            break;

          case 'too-many-requests':
            message = 'Too many login attempts. Try again later.';
            break;

          default:
            message = e.message ?? 'Login failed. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),

            behavior: SnackBarBehavior.floating,

            margin: const EdgeInsets.all(16),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again.'),

            behavior: SnackBarBehavior.floating,

            margin: const EdgeInsets.all(16),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    }
  }

  // ================= GOOGLE LOGIN =================

  Future<void> _googleLogin() async {
    try {
      setState(() => _isLoading = true);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => _isLoading = false);

        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,

        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      setState(() => _isLoading = false);

      Navigator.pushReplacementNamed(context, AppStrings.home);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      String message;

      switch (e.code) {
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;

        case 'account-exists-with-different-credential':
          message = 'Account already exists with another login method.';
          break;

        default:
          message = e.message ?? 'Google sign in failed.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),

          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign in cancelled or failed.'),

          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 40),

                // ================= LOGO =================
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,

                              colorScheme.primary.withValues(alpha: 0.7),
                            ],
                          ),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.swap_horiz_rounded,

                          size: 36,

                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        AppStrings.appName,

                        style: AppTextStyles.h2.copyWith(
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Welcome back!',

                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                Text(
                  'Login',

                  style: AppTextStyles.h3.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your credentials to continue',

                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),

                const SizedBox(height: 28),

                // ================= EMAIL =================
                _buildLabel(context, 'Email'),

                const SizedBox(height: 8),

                _buildTextField(
                  context: context,

                  controller: _emailController,

                  hint: 'your@email.com',

                  icon: Icons.email_outlined,

                  keyboardType: TextInputType.emailAddress,

                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Email is required';
                    }

                    if (!v.contains('@')) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ================= PASSWORD =================
                _buildLabel(context, 'Password'),

                const SizedBox(height: 8),

                _buildTextField(
                  context: context,

                  controller: _passwordController,

                  hint: '••••••••',

                  icon: Icons.lock_outline_rounded,

                  obscureText: _obscurePassword,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,

                      color: theme.iconTheme.color,
                    ),

                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password is required';
                    }

                    if (v.length < 6) {
                      return 'Minimum 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ================= FORGOT PASSWORD =================
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () async {
                      if (_emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter email first")),
                        );

                        return;
                      }

                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text.trim(),
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password reset email sent"),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (!mounted) return;

                        String message;

                        switch (e.code) {
                          case 'user-not-found':
                            message = 'No account found with this email.';
                            break;

                          case 'invalid-email':
                            message = 'Please enter a valid email.';
                            break;

                          case 'network-request-failed':
                            message = 'No internet connection.';
                            break;

                          default:
                            message =
                                e.message ?? 'Failed to send reset email.';
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },

                    child: Text(
                      'Forgot Password?',

                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= LOGIN BUTTON =================
                PrimaryButton(
                  label: 'Login',

                  onPressed: _login,

                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                // ================= DIVIDER =================
                Row(
                  children: [
                    const Expanded(child: Divider()),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: Text(
                        'OR',

                        style: AppTextStyles.caption.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),

                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // ================= GOOGLE BUTTON =================
                OutlinedButton.icon(
                  onPressed: _googleLogin,

                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),

                    side: BorderSide(color: theme.dividerColor),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  icon: Icon(
                    Icons.g_mobiledata,

                    color: theme.iconTheme.color,

                    size: 24,
                  ),

                  label: Text(
                    'Continue with Google',

                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,

                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ================= SIGNUP =================
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppStrings.signup);
                    },

                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",

                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),

                        children: [
                          TextSpan(
                            text: 'Sign Up',

                            style: AppTextStyles.bodySmall.copyWith(
                              color: colorScheme.primary,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LABEL =================

  Widget _buildLabel(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Text(
      text,

      style: AppTextStyles.labelMedium.copyWith(
        fontWeight: FontWeight.w600,

        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField({
    required BuildContext context,

    required TextEditingController controller,

    required String hint,

    required IconData icon,

    bool obscureText = false,

    TextInputType? keyboardType,

    Widget? suffixIcon,

    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,

      obscureText: obscureText,

      keyboardType: keyboardType,

      validator: validator,

      style: AppTextStyles.bodyMedium.copyWith(
        color: theme.textTheme.bodyLarge?.color,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: AppTextStyles.bodyMedium.copyWith(color: theme.hintColor),

        prefixIcon: Icon(icon, color: theme.iconTheme.color, size: 20),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor: theme.cardColor,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: theme.dividerColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: theme.dividerColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
    );
  }
}