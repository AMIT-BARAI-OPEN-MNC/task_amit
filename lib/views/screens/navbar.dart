import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';
import 'package:task_amit/logic/bottom_nav_cubit.dart';
import 'package:task_amit/router/pageName.dart';
import 'package:task_amit/views/screens/navbar/about.dart';
import 'package:task_amit/views/screens/navbar/detailsScreen.dart';
import 'package:task_amit/views/screens/navbar/favoriteScreen.dart';
import 'package:task_amit/views/screens/navbar/homeScreem.dart';
import 'package:task_amit/views/screens/navbar/timeScreen.dart';
import 'package:task_amit/views/widgets/custom_bottom_nav.dart';

class navBar extends StatelessWidget {
  navBar({super.key});
  final List<Widget> pages = [
    HomeScreen(),
    timeScreen(),
    favoriteScreen(),
    aboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: pages[currentIndex], // Display page based on index
          bottomNavigationBar: CustomBottomNav(
            height: SizeConfig.height * 0.07,
            icons: [
              Icons.home,
              Icons.access_time,
              Icons.favorite_border,
              Icons.person_outlined
            ],
          ),
        );
      },
    );
  }
}
