import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/input_style.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/my/widgets/show_address_dialog.dart';
import 'package:project_kotrip/pages/splash/splash_page.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class InfoEditPage extends ConsumerStatefulWidget {
  const InfoEditPage({super.key});

  @override
  ConsumerState<InfoEditPage> createState() => _InfoEditPageState();
}

class _InfoEditPageState extends ConsumerState<InfoEditPage> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nicknameCon;
  late final TextEditingController addressCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(userViewModelProvider).user;
    nicknameCon = TextEditingController(text: state?.nickName ?? state?.displayName ?? '',);
  }

  @override
  Widget build(BuildContext context) {
    final authFunc = ref.read(authViewModelProvider.notifier);
    final userState = ref.watch(userViewModelProvider).user;
    final userFunc = ref.read(userViewModelProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          appBar: BasicAppBar(),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //닉네임
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('닉네임', style: AppTxtSt.titleSt),
                      ),
                      TextFormField(
                        controller: nicknameCon,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '닉네임을 입력하세요';
                          }
                          return null;
                        },
                        cursorColor: colPrimary,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          hintText: '닉네임을 입력해주세요',
                          hintStyle: AppTxtSt.hintStL,
                          border: baseInputBorder,
                          disabledBorder: baseInputBorder,
                          enabledBorder: baseInputBorder,
                          focusedBorder: baseInputBorder.copyWith(
                            borderSide: baseInputBorder.borderSide.copyWith(
                              color: colPrimary,
                            ),
                          ),
                        ),
                      ),
                      //주소
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('주소', style: AppTxtSt.titleSt),
                            TextButton(
                              onPressed: () {
                                //GPS
                              },
                              child: Row(
                                children: [
                                  Text('GPS'),
                                  SizedBox(width: 2),
                                  Image.asset(
                                    'assets/images/icon_location_on.png',
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colGreyBg,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text('주소는 날씨위젯과 연동됩니다.', style: AppTxtSt.txtStS),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                          showAddressDialog(context, addressCon);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: colGreyBtn,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            userState?.address ?? '주소를 입력해주세요',
                            style: (userState?.address != '주소가 없습니다.')
                                ? AppTxtSt.txtStL
                                : AppTxtSt.hintStL,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      AppButton(
                        text: '저장',
                        bgColor: colBkBtn,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            //저장!
                            setState(() {
                              isLoading = true;
                            });
                            userFunc.setUser(
                              nickName: nicknameCon.text,
                              address: addressCon.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AppBtNavi(initialIndex: 3);
                                },
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final confirm = await showConfirmDialog(
                                context,
                                '탈퇴 하시겠습니까?',
                              );
                              if (confirm == true) {
                                await authFunc.deleteAccount();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => SplashPage(),
                                  ),
                                );
                              }
                            },
                            child: Text('탈퇴하기', style: AppTxtSt.txtStR),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading) LoadingWidget(message: '저장하는중...'),
      ],
    );
  }
}
