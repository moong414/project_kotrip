import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';
import 'package:project_kotrip/pages/place/model/review_model.dart';

class MyReviewDialog extends StatelessWidget {
  ReviewModel? myReview;
  MyReviewDialog({super.key, this.myReview});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('내 리뷰', style: AppTxtSt.txtStL),
          ),
          SizedBox(height: 20),
          (myReview == null)
              ? GestureDetector(
                onTap: (){
                  //작성
                  showMyReviewDialog(context);
                },
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: colGreyBtn),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('작성된 리뷰가 없습니다!', style: AppTxtSt.hintStR),
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(10),
                          child: Image.asset('assets/images/icon_edit_gr.png'),
                        ),
                      ],
                    ),
                  ),
              )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 10, 8),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(color: colGreyBtn),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myReview!.content, style: AppTxtSt.txtStR),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(myReview!.date, style: AppTxtSt.txtStR),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //수정
                                  showMyReviewDialog(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/icon_edit_gr.png',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //삭제
                                  print('클릭됨');
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/icon_delete_gr.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}


void showMyReviewDialog(BuildContext context) {
  final reviewCon = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 10, 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('내 리뷰', style: AppTxtSt.txtStLB),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.black, size: 24,),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      DialogTextFormField(title: '할 일', controller: reviewCon, hintText: '리뷰 작성', maxLines: 3,),
                      SizedBox(height: 10,),
                      AppButton(onPressed: (){}, bgColor: colBkBtn, text: '작성',)
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      );
    },
  );
}