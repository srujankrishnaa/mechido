import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  // Animation Controllers
  late AnimationController _backgroundController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _staggerController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late List<Animation<Offset>> _fieldAnimations;

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Rotation animation for decorative elements
    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Pulse animation for interactive elements
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Stagger animation for form fields
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fieldAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.3;
      return Tween<Offset>(
        begin: const Offset(-1.0, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });
  }

  void _startAnimationSequence() async {
    _backgroundController.repeat(reverse: true);
    _rotateController.repeat();
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 400));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showContent = true);
    _slideController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _staggerController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'mobile': mobile,
        },
      );
      if (response.user != null) {
        _showSuccess('Account created successfully!');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _slideController,
          _fadeController,
          _rotateController,
          _pulseController,
          _staggerController,
        ]),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated gradient background
              _buildAnimatedBackground(),

              // Floating particles
              _buildFloatingParticles(),

              // Rotating decorative elements
              _buildRotatingDecorations(),

              // Main content
              if (_showContent) _buildMainContent(),

              // Top decorative wave
              _buildTopWave(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.lerp(
              const Color(0xFF2d1b69),
              const Color(0xFF1a1a2e),
              _backgroundAnimation.value,
            )!,
            Color.lerp(
              const Color(0xFF0f3460),
              const Color(0xFF16213e),
              _backgroundAnimation.value,
            )!,
            Color.lerp(
              const Color(0xFF635BFF),
              const Color(0xFF0f3460),
              _backgroundAnimation.value * 0.4,
            )!,
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(15, (index) {
        return Positioned(
          left: (index * 70.0) % MediaQuery.of(context).size.width,
          top: (index * 80.0) % MediaQuery.of(context).size.height,
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 2500 + (index * 400)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  cos(value * 2 * pi) * 25,
                  -value * 200,
                ),
                child: Opacity(
                  opacity: (1 - value) * 0.5,
                  child: Container(
                    width: 4 + (index % 5) * 2,
                    height: 4 + (index % 5) * 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B7EFF).withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B7EFF).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRotatingDecorations() {
    return Stack(
      children: [
        // Large decorative element - top left
        Positioned(
          top: -100,
          left: -100,
          child: Transform.rotate(
            angle: _rotateAnimation.value * pi,
            child: Opacity(
              opacity: 0.06,
              child: Icon(
                Icons.account_circle,
                size: 300,
                color: const Color(0xFF8B7EFF),
              ),
            ),
          ),
        ),
        // Medium decorative element - bottom right
        Positioned(
          bottom: -80,
          right: -80,
          child: Transform.rotate(
            angle: -_rotateAnimation.value * pi * 1.3,
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                Icons.person_add,
                size: 200,
                color: const Color(0xFF635BFF),
              ),
            ),
          ),
        ),
        // Small decorative element - middle right
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -40,
          child: Transform.rotate(
            angle: _rotateAnimation.value * pi * 2.5,
            child: Opacity(
              opacity: 0.04,
              child: Icon(
                Icons.group_add,
                size: 120,
                color: const Color(0xFFB8A9FF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopWave() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: TopWaveClipper(),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF8B7EFF).withOpacity(0.3),
                const Color(0xFF635BFF).withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Animated logo with glow effect
                  _buildAnimatedLogo(),

                  const SizedBox(height: 30),

                  // Welcome text with gradient
                  _buildWelcomeText(),

                  const SizedBox(height: 40),

                  // Sign up form with glass morphism
                  _buildSignUpForm(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B7EFF).withOpacity(0.5),
                  const Color(0xFF635BFF).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B7EFF).withOpacity(0.6),
                  blurRadius: 50,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B7EFF).withOpacity(0.4),
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/images/signup_illustration.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF8B7EFF), Color(0xFFB8A9FF), Color(0xFFD4C5FF)],
          ).createShader(bounds),
          child: const Text(
            'Join Us Today',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account and start your journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Email Field
          SlideTransition(
            position: _fieldAnimations[0],
            child: _buildStyledTextField(
              controller: emailController,
              hintText: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ),

          const SizedBox(height: 20),

          // Name Field
          SlideTransition(
            position: _fieldAnimations[1],
            child: _buildStyledTextField(
              controller: nameController,
              hintText: 'Full Name',
              icon: Icons.person_outline,
            ),
          ),

          const SizedBox(height: 20),

          // Mobile Field
          SlideTransition(
            position: _fieldAnimations[2],
            child: _buildStyledTextField(
              controller: mobileController,
              hintText: 'Mobile Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ),

          const SizedBox(height: 20),

          // Password Field
          SlideTransition(
            position: _fieldAnimations[3],
            child: _buildStyledTextField(
              controller: passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Confirm Password Field
          SlideTransition(
            position: _fieldAnimations[4],
            child: _buildStyledTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
            ),
          ),

          const SizedBox(height: 35),

          // Enhanced Sign Up Button
          _buildSignUpButton(),

          const SizedBox(height: 25),

          // Sign In Link
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B7EFF).withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? (obscureText ?? false) : false,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B7EFF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF635BFF),
              size: 22,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF8B7EFF),
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    (obscureText ?? false)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF635BFF),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B7EFF), Color(0xFFB8A9FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B7EFF).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF8B7EFF), Color(0xFFB8A9FF)],
            ).createShader(bounds),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
