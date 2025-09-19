import 'package:flutter/cupertino.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message, {bool justConfirm = false}) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        // title: Text('알림'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              return Navigator.of(context).pop(false);
            },
            child: const Text('취소'),
          ),
          if(!justConfirm)
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}
