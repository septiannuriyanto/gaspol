import 'package:flutter/material.dart';

class UpdateVersionScreen extends StatelessWidget {
  const UpdateVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Versi Baru Tersedia!"),
            Text("Hubungi developer untuk update versi")
          ],
        ),
      ),
    );
  }
}
