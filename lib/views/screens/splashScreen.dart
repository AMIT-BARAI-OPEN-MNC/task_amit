import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_amit/core/services/navigationServices.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';
import 'package:task_amit/logic/SplashAnimationCubit.dart';
import 'package:task_amit/router/pageName.dart';
import 'package:task_amit/views/widgets/reusableGradientBackground.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _positionAnimation =
        Tween<double>(begin: SizeConfig.width * -0.8, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _controller.forward(); // Forward animation (0.5 sec)
    await Future.delayed(Duration(seconds: 1)); // Hold for 1 sec
    await _controller.reverse(); // Reverse animation (0.5 sec)
    print("Animation complete"); // Print after completing
    NavigationService.pushReplacement(Pagename.navBar);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.width * 0.35),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_positionAnimation.value,
                              0), // Move left to right
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Icon(
                              Icons.public,
                              size: SizeConfig.height * 0.08,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  FadeTransition(
                    opacity: _opacityAnimation, // Gradual opacity increase
                    child: Text(
                      "Travel",
                      style: GoogleFonts.pacifico(
                        fontSize: SizeConfig.textSize * 5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: SizeConfig.textSize * 0.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height * 0.035),
              Text(
                "Find Your Dream\nDestination With Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeConfig.textSize * 2.5,
                    color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//  