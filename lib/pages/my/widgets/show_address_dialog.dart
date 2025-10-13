import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';
import 'package:project_kotrip/pages/my/data/kakao_repository.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';

Future<String?> showAddressDialog(BuildContext context, WidgetRef ref) async {
  final dialogController = TextEditingController();
  Timer? debounce;
  List<AddressModel> searchResultList = [];

  return await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('주소', style: AppTxtSt.txtStLB),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close, size: 24),
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
                            onChanged: (value) {
                              if (debounce?.isActive ?? false) debounce!.cancel();
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
                                ? Center(child: Text('주소를 입력해주세요!', style: AppTxtSt.hintStL))
                                : Scrollbar(
                                    thumbVisibility: true,
                                    thickness: 6,
                                    radius: const Radius.circular(8),
                                    child: ListView.separated(
                                      itemCount: searchResultList.length,
                                      separatorBuilder: (context, index) => const Divider(color: colGreyBtn),
                                      itemBuilder: (context, index) {
                                        final addItem = searchResultList[index];
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await ref.read(userViewModelProvider.notifier).setUser(address: addItem.addressName.isNotEmpty ? addItem.addressName : addItem.placeName,);
                                            
                                            if (result == true) {
                                              Navigator.pop(dialogContext, addItem.addressName);
                                            }
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
}
