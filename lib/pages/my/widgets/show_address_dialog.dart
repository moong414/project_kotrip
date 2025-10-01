import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';
import 'package:project_kotrip/pages/my/data/kakao_repository.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';

Future<void> showAddressDialog(BuildContext context, TextEditingController addCon) async {
  final kakaorepo = KakaoRepository();

  await showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          List<AddressModel> searchResultList = [];

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- 헤더 ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('주소', style: AppTxtSt.txtStLB),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.black, size: 24),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  DialogTextFormField(
                                    controller: addCon,
                                    hintText: '주소 입력',
                                    autoFocus: true,
                                    onChanged: (value) async {
                                      if (value.isEmpty) {
                                        setState(() => searchResultList = []);
                                        return;
                                      }
                                      //카카오지도 키워드검색
                                      final results = await kakaorepo.getAddress(value);
                                      setState(() => searchResultList = results);
                                    },
                                  ),
                                  Positioned(
                                    top: 1,
                                    right: 4,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                        'assets/images/icon_search.png',
                                        width: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 160,
                                child: searchResultList.isEmpty
                                    ? Center(
                                        child: Text('주소를 입력해주세요!', style: AppTxtSt.hintStL),
                                      )
                                    : Scrollbar(
                                      thumbVisibility: true,
                                      thickness: 6, 
                                      radius: Radius.circular(8),
                                      child: ListView.separated(itemBuilder: (context, index) {
                                        final addItem = searchResultList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            addCon.text = addItem.addressName;
                                            ref.read(userViewModelProvider.notifier).setUser(address: addItem.addressName); // 선택한 주소UserViewModel에 적용
                                            Navigator.pop(context);
                                          },
                                          child: Padding(padding: EdgeInsets.all(10), child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text(addItem.addressName, style: AppTxtSt.txtStR,),
                                            SizedBox(height: 2,),
                                            Text(addItem.placeName, style: AppTxtSt.txtStL),
                                          ],),),
                                        );
                                      }, separatorBuilder: (context, index) {
                                        return Divider(color: colGreyBtn,);
                                      }, itemCount: searchResultList.length)
                                    ),
                              ),
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
        },
      );
    },
  );
}
