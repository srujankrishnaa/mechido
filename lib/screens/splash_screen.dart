import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showLogo = false;
  bool _showText = false;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Fade animation for background
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Scale animation for logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Rotation animation for gears
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Slide animation for text
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  void _startAnimationSequence() async {
    // Start background fade
    _fadeController.forward();

    // Start rotating gears immediately
    _rotateController.repeat();

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showParticles = true);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _showLogo = true);
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showText = true);
    _slideController.forward();

    // Navigate after animations complete
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeController,
          _scaleController,
          _rotateController,
          _slideController,
        ]),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated gradient background
              _buildAnimatedBackground(),

              // Floating particles
              if (_showParticles) _buildFloatingParticles(),

              // Rotating gears background
              _buildRotatingGears(),

              // Main content
              _buildMainContent(),

              // Remove this line that creates the bottom wave
              // _buildBottomWave(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e).withOpacity(_fadeAnimation.value),
            const Color(0xFF16213e).withOpacity(_fadeAnimation.value),
            const Color(0xFF0f3460).withOpacity(_fadeAnimation.value),
            const Color(0xFF635BFF).withOpacity(_fadeAnimation.value * 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(15, (index) {
        return Positioned(
          left: (index * 50.0) % MediaQuery.of(context).size.width,
          top: (index * 80.0) % MediaQuery.of(context).size.height,
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 2000 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -value * 100),
                child: Opacity(
                  opacity: (1 - value) * 0.6,
                  child: Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF).withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635BFF).withOpacity(0.3),
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

  Widget _buildRotatingGears() {
    return Stack(
      children: [
        // Large gear - top right
        Positioned(
          top: -50,
          right: -50,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 3.14159,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.settings,
                size: 200,
                color: const Color(0xFF635BFF),
              ),
            ),
          ),
        ),
        // Medium gear - bottom left
        Positioned(
          bottom: -30,
          left: -30,
          child: Transform.rotate(
            angle: -_rotateAnimation.value * 3.14159 * 1.5,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.settings,
                size: 120,
                color: const Color(0xFF635BFF),
              ),
            ),
          ),
        ),
        // Small gear - middle right
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -20,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 3.14159 * 2,
            child: Opacity(
              opacity: 0.06,
              child: Icon(
                Icons.settings,
                size: 80,
                color: const Color(0xFF635BFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated logo with glow effect
          if (_showLogo)
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF635BFF).withOpacity(0.3),
                      const Color(0xFF635BFF).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF635BFF).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 40),

          // Animated app name and tagline
          if (_showText)
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // App name with gradient text
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF635BFF), Color(0xFF8B7EFF)],
                    ).createShader(bounds),
                    child: const Text(
                      'MECHIDO',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline with typewriter effect
                  TweenAnimationBuilder<int>(
                    duration: const Duration(milliseconds: 1500),
                    tween: IntTween(begin: 0, end: 25),
                    builder: (context, value, child) {
                      String text = "Your Trusted Car Mechanic";
                      String displayText =
                          text.substring(0, value.clamp(0, text.length));
                      return Text(
                        displayText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Animated car service icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildServiceIcon(Icons.build, 0),
                      const SizedBox(width: 20),
                      _buildServiceIcon(Icons.car_repair, 200),
                      const SizedBox(width: 20),
                      _buildServiceIcon(Icons.settings, 400),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF635BFF).withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF635BFF).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF635BFF),
              size: 24,
            ),
          ),
        );
      },
    );
  }

  // Remove this entire method
  // Widget _buildBottomWave() {
  //   return Positioned(
  //     bottom: 0,
  //     left: 0,
  //     right: 0,
  //     child: TweenAnimationBuilder<double>(
  //       duration: const Duration(milliseconds: 2000),
  //       tween: Tween(begin: 0.0, end: 1.0),
  //       builder: (context, value, child) {
  //         return Transform.translate(
  //           offset: Offset(0, 100 * (1 - value)),
  //           child: Opacity(
  //             opacity: value * 0.3,
  //             child: Container(
  //               height: 100,
  //               decoration: const BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                   colors: [
  //                     Color(0xFF1a1a2e),
  //                     Color(0xFF16213e),
  //                     Color(0xFF0f3460),
  //                     Color(0xFF635BFF),
  //                   ],
  //                   stops: [0.0, 0.4, 0.7, 1.0],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
