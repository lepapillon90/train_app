import 'package:flutter/material.dart';
import 'package:flutter_train_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ✅ 전체 앱 테마 설정
      // - theme: 밝은 테마 (기본 테마)
      // - darkTheme: 다크 모드 테마
      // - themeMode: 시스템 설정에 따라 테마 자동 전환
      title: '기차 예매',
      theme: ThemeData(
        // ✅ 밝은 테마 설정
        // - primarySwatch: 기본 색상 보라색
        // - scaffoldBackgroundColor: 밝은 배경색 설정
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      darkTheme: ThemeData(
        // ✅ 다크 테마 설정
        // - brightness: 다크 모드
        // - scaffoldBackgroundColor: 어두운 배경색 설정
        // - colorScheme: 보라색을 기본 색상으로 사용
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.dark(primary: Colors.purple),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}