import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 100;
  }
}

class AppColors {
  const AppColors();
  static const Color white = Colors.white;
  static const Color mainColor = Color.fromARGB(255, 59, 153, 240);
  static const Color background = Color(0xFFf2f6ff);

  static const Color successGreen = Color(0xFF32CD32);
  static const Color secondaryColor = Color(0xffa690c4);

  static const Color elementBack = Color(0xfff1efef);
  static const Color titleColor = Color(0xFF061857);
  static const Color subTitle = Color(0xFFa4adbe);
  static const Color textMain = Color(0xFF848484);
  static const Color greyBack = Color(0xFFced4db);
  static const Color grey = Color(0xFfc2c8c6);
  static const Color greyForm = Color(0xFFcaced4);
  static const Color red = Color(0xFFE74C3C);

  static const Color strongGrey = Color(0xFFced4db);
  static const Color secondBlack = Color(0xFF515C6F);
  static const Color facebookBlue = Color.fromARGB(255, 51, 163, 232);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF5BC0FF), Color(0xFF0063FF)],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class BoxShadows {
  static const BoxShadow shadow = BoxShadow(
    color: Color.fromARGB(136, 184, 183, 183),
    blurRadius: 8.0,
    spreadRadius: 1,
    offset: Offset(
      1.0, // Move to right 7.0 horizontally
      1.0, // Move to bottom 8.0 Vertically
    ),
  );
  static const BoxShadow shadow2 = BoxShadow(
    color: Color.fromARGB(186, 184, 183, 183),
    blurRadius: 6.0,
    spreadRadius: 1,
    offset: Offset(
      0.0, // Move to right 7.0 horizontally
      0.0, // Move to bottom 8.0 Vertically
    ),
  );
  static const BoxShadow shadow3 = BoxShadow(
    color: Color.fromARGB(255, 198, 205, 214),
    blurRadius: 4.0,
    spreadRadius: 2,
    offset: Offset(
      0.0, // Move to right 7.0 horizontally
      3.0, // Move to bottom 8.0 Vertically
    ),
  );
  static const BoxShadow shadow4 = BoxShadow(
    color: Color.fromARGB(164, 223, 231, 242),
    blurRadius: 5.0,
    spreadRadius: 1,
    offset: Offset(
      0.0, // Move to right 7.0 horizontally
      4.0, // Move to bottom 8.0 Vertically
    ),
  );
}

class TextStyles {
  static const TextStyle white23 = TextStyle(
    color: Colors.white,
    fontSize: 23,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle white22 = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle white17semibold = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle white16semibold = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle white16 = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  static const TextStyle white15semibold = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle white11semibold = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle white12semibold = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle white22semibold = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle black22semibold = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle black20 = TextStyle(
    color: Colors.black,
    fontSize: 20,
    // fontWeight: FontWeight.w600,
  );
  static const TextStyle black25 = TextStyle(
    color: Colors.black,
    fontSize: 25,
    // fontWeight: FontWeight.w600,
  );
  static const TextStyle white17 = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
  static const TextStyle white14semibold = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle white14 = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
  static const TextStyle black17semibold = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis);
  static const TextStyle black17 = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  static const TextStyle black18 = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
  static const TextStyle black19 = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
  static const TextStyle black14semibold = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle grey14semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey15semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey15 = TextStyle(
    color: Color.fromARGB(255, 77, 76, 76),
    fontSize: 15,
    // fontWeight: FontWeight.w500,
  );
  static const TextStyle grey16semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey17semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey18semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey17 = TextStyle(
    color: Color.fromARGB(255, 57, 57, 57),
    fontSize: 17,
    // fontWeight: FontWeight.w00,
  );
  static const TextStyle grey20semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle greysemibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey12semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle grey13semibold = TextStyle(
    color: Color.fromARGB(255, 114, 114, 114),
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle black14 = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );
  static const TextStyle red14 = TextStyle(
    color: Color.fromARGB(255, 238, 120, 111),
    fontSize: 14,
  );
  static const TextStyle red17 = TextStyle(
    color: Color.fromARGB(255, 238, 120, 111),
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle red14semibold = TextStyle(
      color: Color.fromARGB(255, 238, 120, 111),
      fontSize: 14,
      fontWeight: FontWeight.w500);
  static const TextStyle main14 = TextStyle(
    color: AppColors.mainColor,
    fontSize: 14,
  );
  static const TextStyle black13 = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );
  static const TextStyle black12 = TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
  static const TextStyle black16semibold = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle black16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle black15semibold = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle black11semibold = TextStyle(
    color: Colors.black,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle main17semibold = TextStyle(
    color: AppColors.mainColor,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle main16semibold = TextStyle(
    color: AppColors.mainColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle main16 = TextStyle(
    color: AppColors.mainColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle main20 = TextStyle(
    color: AppColors.mainColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle main15semibold = TextStyle(
    color: AppColors.mainColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle main11semibold = TextStyle(
    color: AppColors.mainColor,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle main22semibold = TextStyle(
    color: AppColors.mainColor,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
}
