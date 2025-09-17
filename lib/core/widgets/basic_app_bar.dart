import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool darkMode;
  BasicAppBar({super.key, this.darkMode = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Image.asset(darkMode ? 'assets/images/logo_s_wt.png' : 'assets/images/logo_s.png', height: 19),
      leading: Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(darkMode ? 'assets/images/icon_back_wt.png' : 'assets/images/icon_back.png', height: 24),
      ),
    );
  }

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
