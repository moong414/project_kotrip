import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';

class AppTxtSt {

  //제목스타일
  static const TextStyle titleSt = TextStyle(
    color: colBkTxt,
    fontSize: 18,
    fontWeight: FontWeight.w400
  );
  static const TextStyle titleStB = TextStyle(
    color: colBkTxt,
    fontSize: 18,
    fontWeight: FontWeight.w700
  );
  static const TextStyle titleStWtB = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    shadows: [Shadow(offset: Offset(1, 1), blurRadius: 4, color: Colors.black38)]
  );

  //본문스타일 16폰트
  static const TextStyle txtStL = TextStyle(
    color: colBkTxt,
    fontSize: 16,
    fontWeight: FontWeight.w400
  );
  static const TextStyle txtStLB = TextStyle(
    color: colBkTxt,
    fontSize: 16,
    fontWeight: FontWeight.w700
  );
  

  //본문스타일 14폰트
  static const TextStyle txtStR = TextStyle(
    color: colBkTxt,
    fontSize: 14,
    fontWeight: FontWeight.w400
  );
  
  static const TextStyle txtStRB = TextStyle(
    color: colBkTxt,
    fontSize: 14,
    fontWeight: FontWeight.w700
  );

  static const TextStyle txtStRWt = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    shadows: [Shadow(offset: Offset(0, 0), blurRadius: 6, color: Colors.black26)]
  );

  //본문스타일 12폰트
  static const TextStyle txtStS = TextStyle(
    color: colBkTxt,
    fontSize: 12,
    fontWeight: FontWeight.w400
  );


  //강조 16
  static const TextStyle txtPrimary = TextStyle(
    color: colPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500
  );

  //힌트스타일 14
  static const TextStyle hintStR = TextStyle(
    color: colHintTxt,
    fontSize: 14,
    fontWeight: FontWeight.w400
  );

  
}