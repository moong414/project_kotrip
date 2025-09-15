import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class AiBtn extends StatefulWidget {
  const AiBtn({super.key});

  @override
  State<AiBtn> createState() => _AiBtnState();
}

class _AiBtnState extends State<AiBtn> {
  double top = 0;
  bool down = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (down) {
          top = 5;
        } else {
          top = 0;
        }
        down = !down;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '여행계획 세우기 귀찮을 땐?',
                  style: AppTxtSt.txtStL.copyWith(fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colGreenAi, colMintAi]),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                    onPressed: () {
                      //Ai에게 부탁하기
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/icon_ai.png', width: 20),
                        SizedBox(width: 8),
                        Text(
                          'AI에게 부탁하기!',
                          style: TextStyle(
                            color: colGreenAi,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            right: 10,
            top: top,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 1000),
            child: Image.asset('assets/images/img_ai.png', width: 85),
          ),
        ],
      ),
    );
  }
}
