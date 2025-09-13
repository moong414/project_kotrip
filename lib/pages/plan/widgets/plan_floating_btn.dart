import 'package:flutter/material.dart';

class PlanFloatingBtn extends StatelessWidget {
  const PlanFloatingBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
        child: Icon(Icons.add),
      ),
    );
  }
}
