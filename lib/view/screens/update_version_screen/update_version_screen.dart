import 'package:flutter/material.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';

class UpdateVersionScreen extends StatelessWidget {
  const UpdateVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          height: cHeight(context),
          width: cWidth(context),
          'lib/assets/image/bg-blue3.jpg',
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  width: cWidth(context) * 0.9,
                  'lib/assets/image/new-update.png',
                  fit: BoxFit.cover,
                ),
                vSpace(20),
                Image.asset(
                  height: 30,
                  'lib/assets/image/gaspol-landscape-trans.png',
                  fit: BoxFit.cover,
                ),
                vSpace(10),
                Text(
                  "Versi Baru Tersedia!",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text("Hubungi developer untuk update versi")
              ],
            ),
          ),
        ),
      ],
    );
  }
}
