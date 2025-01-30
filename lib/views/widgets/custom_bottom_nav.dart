import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/uttils/responsiveSizeHelper.dart';
import 'package:task_amit/logic/bottom_nav_cubit.dart';

class CustomBottomNav extends StatelessWidget {
  final List<IconData> icons;
  final double height;
  final Color activeColor;
  final Color activeColorDot;
  final Color inactiveColor;

  const CustomBottomNav({
    Key? key,
    required this.icons,
    this.height = 70.0,
    this.activeColor = Colors.black,
    this.activeColorDot = Colors.deepOrange,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Container(
          height: height,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.02,
              vertical: SizeConfig.height * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.transparent,
            // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isActive = index == currentIndex;
              return GestureDetector(
                onTap: () {
                  context.read<BottomNavCubit>().changeTab(index);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: isActive
                      ? Matrix4.translationValues(0, -8, 0)
                      : Matrix4.identity(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        size: SizeConfig.height * 0.032,
                        color: isActive ? activeColor : inactiveColor,
                      ),
                      SizedBox(height: 4),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isActive ? 6 : 0,
                        height: isActive ? 6 : 0,
                        decoration: BoxDecoration(
                          color: isActive ? activeColorDot : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
