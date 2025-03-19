import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _textController;
  late Animation<Offset> _developedByAnimation;
  late Animation<Offset> _chinmayaDashAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3, milliseconds: 500), // 2.5 sec bounce
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Text animation duration
    );

    // Bounce Animation (Falls from top and bounces once)
    _bounceAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: -500, end: 0).chain(CurveTween(curve: Curves.easeIn)), weight: 2), // Falls
      TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: -200).chain(CurveTween(curve: Curves.easeOut)), weight: 1), // Bounce up
      TweenSequenceItem(
          tween: Tween<double>(begin: -200, end: 80).chain(CurveTween(curve: Curves.bounceOut)), weight: 1), // Settle
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    // Scale Animation (Logo scales up while bouncing)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 2).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.easeOut)));

    // "Developed By" moves from left
    _developedByAnimation = Tween<Offset>(
      begin: Offset(-8, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeInOut));

    // "Chinmaya Dash" moves from right
    _chinmayaDashAnimation = Tween<Offset>(
      begin: Offset(8, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeInOut));

    _controller.forward();

    // Start text animation after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _textController.forward();
    });

    // Wait for 5 seconds, then navigate to login page
    Future.delayed(const Duration(seconds: 5), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31372D), // Dark background
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Bouncing Logo
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height / 4, // Start in the top center
                child: Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SvgPicture.asset(
                      'lib/assets/images/chatshare_logo.svg',
                      height: 160,
                      width: 160,
                    ),
                  ),
                ),
              );
            },
          ),

          // "Developed By" text animation
          Positioned(
            bottom: 100,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return SlideTransition(
                  position: _developedByAnimation,
                  child: Text(
                    "Developed By",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                );
              },
            ),
          ),

          // "Chinmaya Dash" text animation
          Positioned(
            bottom: 70,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return SlideTransition(
                  position: _chinmayaDashAnimation,
                  child: Text(
                    "Chinmaya Dash",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
