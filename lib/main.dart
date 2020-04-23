
import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/screens/account_screen.dart';
import 'package:hyper_garage_sale/screens/garage_screen.dart';
import 'package:camera/camera.dart';
import 'package:hyper_garage_sale/screens/post_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:path/path.dart' show join;
import 'dart:async';
import 'dart:io';


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        GarageScreen.id: (context) => GarageScreen(),
        PostScreen.id: (context) => PostScreen(),
        AccountScreen.id: (context) => AccountScreen(),
        TakePictureScreen.routeName : (context) => new TakePictureScreen(camera: firstCamera),
      },
    ),
  );
}
