import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'utils/app_theme.dart';
import 'routes/app_routes.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/auth_controller.dart';

void main() {
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controllers
    Get.put(AuthController());
    Get.put(TransactionController());
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}