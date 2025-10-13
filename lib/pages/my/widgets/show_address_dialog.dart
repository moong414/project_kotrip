import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';
import 'package:project_kotrip/pages/my/data/kakao_repository.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';

Future<String?> showAddressDialog(BuildContext context) async {
  Timer? debounce; //타이머
  final TextEditingController dialogController = TextEditingController();

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
                      // 헤더
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('주소', style: AppTxtSt.txtStLB),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: (){
                              Navigator.pop(context);
                              dialogController.dispose();
                              debounce?.cancel();
                            },
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
                              DialogTextFormField(
                                controller: dialogController,
                                hintText: '주소 입력',
                                onChanged: (value) async {
                                  if (debounce?.isActive ?? false) debounce!.cancel();//타이머취소
                                  // 새 타이머 시작
                                  debounce = Timer(const Duration(milliseconds: 500), () async {
                                    if (value.isEmpty) {
                                      setState(() => searchResultList = []);
                                      return;
                                    }
                                    final results = await KakaoRepository().getAddress(value);
                                    setState(() => searchResultList = results);
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 160,
                                child: searchResultList.isEmpty
                                    ? Center(
                                        child: Text('주소를 입력해주세요!', style: AppTxtSt.hintStL),
                                      )
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        thickness: 6,
                                        radius: const Radius.circular(8),
                                        child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            final addItem = searchResultList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                //userViewModel 업데이트
                                                ref.read(userViewModelProvider.notifier).setUser(address: addItem.addressName);
                                                Navigator.pop(context, addItem.addressName);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(addItem.addressName, style: AppTxtSt.txtStR),
                                                    const SizedBox(height: 2),
                                                    Text(addItem.placeName, style: AppTxtSt.txtStL),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const Divider(color: colGreyBtn),
                                          itemCount: searchResultList.length,
                                        ),
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
  ).then((_) {
    dialogController.dispose();
    debounce?.cancel();
  });
  return null;
}
