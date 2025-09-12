import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool darkMode;
  BasicAppBar({super.key, this.darkMode = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(darkMode ? 'assets/images/logo_s_wt.png' : 'assets/images/logo_s.png', height: 19),
    );
  }

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
