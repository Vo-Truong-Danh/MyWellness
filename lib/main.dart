import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_wellness/views/screens/authentication/auth.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/controllers/providers/selected_date_provider.dart';
import 'package:my_wellness/controllers/providers/health_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Khởi tạo định dạng ngày tháng cho locale tiếng Việt
  await initializeDateFormatting('vi_VN', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedDateProvider()),
        ChangeNotifierProvider(create: (_) => HealthDataProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          primaryColor: Color(0xFF30C9B7),
        ),
        debugShowCheckedModeBanner: false,
        home: Auth(),
      ),
    ),
  );
}
