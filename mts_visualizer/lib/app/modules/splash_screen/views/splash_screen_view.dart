import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplashScreenView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SplashScreenView is working',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? filePath = await controller.pickFile();
                if (filePath != null) {
                  print('Picked file: $filePath');
                  controller.loadSettings();
                } else {
                  print('No file selected');
                }
              },
              child: Text('Pick a File'),
            ),
          ],
        ),
      ),
    );
  }
}