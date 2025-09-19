import 'package:flutter/cupertino.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message) {
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
