import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double width;
  static late double height;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double textSize;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;

    textSize = blockSizeVertical; // Adjusts text sizes
    imageSizeMultiplier = blockSizeHorizontal; // Adjusts image sizes
    heightMultiplier = blockSizeVertical; // Adjusts heights
    widthMultiplier = blockSizeHorizontal; // Adjusts widths
  }
}
