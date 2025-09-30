import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/input_style.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/splash/splash_page.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class InfoEditPage extends ConsumerStatefulWidget {
  const InfoEditPage({super.key});

  @override
  ConsumerState<InfoEditPage> createState() => _InfoEditPageState();
}

class _InfoEditPageState extends ConsumerState<InfoEditPage> {
  late final TextEditingController nicknameCon;
  late final TextEditingController addressCon;

  //주소선택
  Future<void> showAddressDialog(BuildContext context, TextEditingController addCon) async {
    await showDialog(
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
                    Text('주소', style: AppTxtSt.txtStLB),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        return Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.black, size: 24),
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
                          controller: addCon,
                          hintText: '주소 입력',
                          autoFocus: true,
                        ),
                        SizedBox(
                          height: 160,
                          child: Center(
                            child: Text('주소를 입력해주세요!', style: AppTxtSt.hintStL),
                          ),
                        ),
                        AppButton(
                          onPressed: () {
                            return Navigator.pop(context);
                          },
                          height: 50,
                          bgColor: colBkBtn,
                          text: '작성',
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
  }

  @override
  void initState() {
    nicknameCon = TextEditingController();
    addressCon = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authFunc = ref.read(authViewModelProvider.notifier);
    
    return Scaffold(
      appBar: BasicAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      Text('주소 수정', style: AppTxtSt.titleSt),
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colGreyBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('주소는 날씨위젯과 연동됩니다.', style: AppTxtSt.txtStS),
                ),
                SizedBox(height: 10),
                FormField(
                  validator: (value) {
                    if (value == null) {
                      //빈값일 경우
                    }
                  },
                  builder: (FormFieldState<Object> field) {
                    return GestureDetector(
                      onTap: () async {
                        await showAddressDialog(context, addressCon);
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            color: field.hasError
                                ? Color(0xffBE2C48)
                                : colGreyBtn,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          addressCon.text.isEmpty
                              ? '주소를 입력해주세요'
                              : addressCon.text,
                          style: AppTxtSt.hintStL,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                AppButton(
                  text: '저장',
                  bgColor: colBkBtn,
                  onPressed: () {
                    //저장!
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
                            MaterialPageRoute(builder: (_) => SplashPage()),
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
    );
  }
}
