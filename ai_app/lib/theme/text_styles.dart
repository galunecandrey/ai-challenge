import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/theme/colors.dart';

class TextStyles {
  static TextStyles? _styles;

  late TextStyle lightBlue16;
  late TextStyle regularBlue12;
  late TextStyle regularBlue16;
  late TextStyle regularWhite12;
  late TextStyle regularWhite14;
  late TextStyle regularWhite16;
  late TextStyle regularWhite18;
  late TextStyle regularDarkBlue8;
  late TextStyle regularDarkBlue10;
  late TextStyle regularDarkBlue12;
  late TextStyle regularDarkBlue14;
  late TextStyle regularDarkBlue16;
  late TextStyle regularDarkBlue16Underline;
  late TextStyle regularDarkBlue18;
  late TextStyle mediumDarkBlue12;
  late TextStyle semiBoldDarkBlue16;
  late TextStyle semiBoldDarkBlue20;
  late TextStyle boldDarkBlue14;
  late TextStyle boldDarkBlue16;
  late TextStyle boldDarkBlue18;
  late TextStyle boldDarkBlue20;
  late TextStyle boldDarkBlue24;
  late TextStyle boldDarkBlueLogo84;
  late TextStyle boldBlue24;
  late TextStyle boldBlue18;
  late TextStyle mediumWhite14;
  late TextStyle mediumWhite18;
  late TextStyle lightWhite16;
  late TextStyle boldWhite10;
  late TextStyle boldWhite12;
  late TextStyle boldWhite14;
  late TextStyle boldWhite16;
  late TextStyle boldWhite18;
  late TextStyle boldWhite20;
  late TextStyle boldWhite24;
  late TextStyle boldWhiteLogo84;
  late TextStyle boldCoolGray16;
  late TextStyle regularCoolGray10;
  late TextStyle regularCoolGray12;
  late TextStyle regularCoolGray16;
  late TextStyle regularCoolBlack16;
  late TextStyle regularDarkGray16;
  late TextStyle boldDarkGray14;
  late TextStyle boldDarkGray18;
  late TextStyle regularDarkGray14;
  late TextStyle regularLightGray8;
  late TextStyle regularLightGray10;
  late TextStyle regularLightGray12;
  late TextStyle regularLightGray14;
  late TextStyle regularLightGray16;
  late TextStyle regularLightGray18;
  late TextStyle boldLightGray16;
  late TextStyle mediumLightGray14;
  late TextStyle boldCoolGray18;
  late TextStyle lightBlue48;
  late TextStyle regularMidBlue18;
  late TextStyle regularMidBlue16;
  late TextStyle regularMidBlue14;
  late TextStyle boldMidBlue16;
  late TextStyle boldMidBlue18;
  late TextStyle regularGreen16;
  late TextStyle semiBoldRed8;
  late TextStyle semiBoldRed10;
  late TextStyle semiBoldRed12;
  late TextStyle semiBoldRed14;
  late TextStyle regularRed16;
  late TextStyle regularRed14;
  late TextStyle boldRed16;
  late TextStyle boldRed18;
  late TextStyle regularSilver18;
  late TextStyle regularAbbeyGray18;
  late TextStyle regularLightGrey12;
  late TextStyle regularPurple16;
  late TextStyle regularDarkShadeGray16;
  late TextStyle regularDarkShadeGray14;

  factory TextStyles.styles() => _styles ??= TextStyles._internal();

  TextStyles._internal() {
    regularWhite12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.white,
      fontWeight: FontWeight.w400,
    );
    regularWhite14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.white,
      fontWeight: FontWeight.w400,
    );
    regularWhite16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.white,
      fontWeight: FontWeight.w400,
    );

    regularWhite18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.white,
      fontWeight: FontWeight.w400,
    );

    lightBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w300,
    );

    regularBlue12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w400,
    );

    regularBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w400,
    );

    mediumDarkBlue12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w500,
    );

    semiBoldDarkBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w600,
    );

    semiBoldDarkBlue20 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 20,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w600,
    );

    regularDarkBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w400,
    );

    regularDarkBlue8 = regularDarkBlue16.copyWith(fontSize: 8);

    regularDarkBlue10 = regularDarkBlue16.copyWith(fontSize: 10);

    regularDarkBlue12 = regularDarkBlue16.copyWith(fontSize: 12);

    regularRed14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.red,
      fontWeight: FontWeight.w400,
    );

    boldLightGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w700,
    );

    regularDarkBlue14 = regularDarkBlue16.copyWith(fontSize: 14.0);

    regularDarkBlue16Underline = regularDarkBlue16.copyWith(decoration: TextDecoration.underline);

    regularDarkBlue18 = regularDarkBlue16.copyWith(fontSize: 18);

    boldDarkBlue14 = regularDarkBlue14.copyWith(fontWeight: FontWeight.bold);
    boldDarkBlue16 = regularDarkBlue16.copyWith(fontWeight: FontWeight.bold);
    boldDarkBlue18 = regularDarkBlue18.copyWith(fontWeight: FontWeight.bold);

    boldDarkBlue20 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 20.0,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w700,
    );

    boldDarkBlue24 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 24.0,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w700,
    );

    boldDarkBlueLogo84 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 84.0,
      color: AppColors.visionableDarkBlue,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    );

    boldBlue24 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 24.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w700,
    );

    boldBlue18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w700,
    );

    mediumWhite14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.white,
      fontWeight: FontWeight.w600,
    );

    mediumWhite14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.white,
      fontWeight: FontWeight.w600,
    );

    mediumWhite18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.white,
      fontWeight: FontWeight.w600,
    );

    lightWhite16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.white,
      fontWeight: FontWeight.w300,
    );

    boldWhite10 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 10.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite20 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 20.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhite24 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 24.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    boldWhiteLogo84 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 84.0,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    );

    boldCoolGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.coolGrayAccent,
      fontWeight: FontWeight.w700,
    );

    regularCoolGray10 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 10.0,
      color: AppColors.coolGrayAccent,
      fontWeight: FontWeight.w400,
    );

    regularCoolGray12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.coolGrayAccent,
      fontWeight: FontWeight.w400,
    );

    regularCoolGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.coolGrayAccent,
      fontWeight: FontWeight.w400,
    );

    regularCoolBlack16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.black,
      fontWeight: FontWeight.w400,
    );

    regularDarkGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.darkGray,
      fontWeight: FontWeight.w400,
    );

    boldDarkGray14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.darkGray,
      fontWeight: FontWeight.w700,
    );

    boldDarkGray18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.darkGray,
      fontWeight: FontWeight.w700,
    );

    regularDarkGray14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.darkGray,
      fontWeight: FontWeight.w400,
    );

    boldCoolGray18 = regularCoolGray16.copyWith(fontSize: 18, fontWeight: FontWeight.w700);

    regularLightGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGray8 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 8.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGray10 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 10.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGray12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGray14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGray18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    mediumLightGray14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w600,
    );

    lightBlue48 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 48.0,
      color: AppColors.visionableBlue,
      fontWeight: FontWeight.w300,
    );

    boldMidBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.visionableMidBlue,
      fontWeight: FontWeight.w700,
    );
    regularMidBlue18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.visionableMidBlue,
      fontWeight: FontWeight.w400,
    );
    regularMidBlue16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.visionableMidBlue,
      fontWeight: FontWeight.w400,
    );
    regularMidBlue14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.visionableMidBlue,
      fontWeight: FontWeight.w400,
    );
    boldMidBlue18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.visionableMidBlue,
      fontWeight: FontWeight.w700,
    );

    regularGreen16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.green,
      fontWeight: FontWeight.w400,
    );

    semiBoldRed8 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 8.0,
      color: AppColors.red,
      fontWeight: FontWeight.w600,
    );

    semiBoldRed10 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 10.0,
      color: AppColors.red,
      fontWeight: FontWeight.w600,
    );

    semiBoldRed12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.red,
      fontWeight: FontWeight.w600,
    );

    semiBoldRed14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.red,
      fontWeight: FontWeight.w600,
    );

    regularRed16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.red,
      fontWeight: FontWeight.w400,
    );

    boldRed16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.red,
      fontWeight: FontWeight.bold,
    );

    boldRed18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18.0,
      color: AppColors.red,
      fontWeight: FontWeight.bold,
    );

    regularSilver18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18,
      color: AppColors.silver,
      fontWeight: FontWeight.w400,
    );

    regularAbbeyGray18 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 18,
      color: AppColors.abbeyGray,
      fontWeight: FontWeight.w400,
    );

    regularLightGrey12 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 12.0,
      color: AppColors.lightGray,
      fontWeight: FontWeight.w400,
    );

    regularPurple16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.purple,
      fontWeight: FontWeight.w400,
    );

    regularDarkShadeGray16 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 16.0,
      color: AppColors.darkShadeGray,
      fontWeight: FontWeight.w400,
    );

    regularDarkShadeGray14 = const TextStyle(
      fontFamily: 'NunitoSans',
      fontSize: 14.0,
      color: AppColors.darkShadeGray,
      fontWeight: FontWeight.w400,
    );
  }
}
