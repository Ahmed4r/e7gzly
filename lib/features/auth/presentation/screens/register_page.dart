import 'package:e7gzly/features/auth/presentation/screens/login_page.dart';
import 'package:e7gzly/features/auth/presentation/widgets/custom_text_filed.dart';
import 'package:e7gzly/features/auth/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Image.asset("assets/icons/logo.png"),
              const SizedBox(height: 8),

              // App Name
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 24, color: Color(0xFF1E293B)),
                  children: [
                    TextSpan(
                      text: 'Health',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text: 'Pal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Title & Subtitle
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We are here to help you!',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),

              // Text Fields
              const CustomTextField(
                hintText: 'Your Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Your Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divider "or"
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                ],
              ),
              const SizedBox(height: 24),

              // Google Auth Button
              SocialButton(
                label: 'Continue with Google',
                iconWidget: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                  height: 20,
                  width: 20,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.g_mobiledata,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Facebook Auth Button
              SocialButton(
                label: 'Continue with Facebook',
                iconWidget: const Icon(
                  Icons.facebook,
                  color: Color(0xFF1877F2),
                  size: 22,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 32),

              // Sign In Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Do you have an account ? ',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
