import 'package:flutter/material.dart';
import 'package:mind_clean/models/auth.dart';
import 'package:mind_clean/models/chat.dart';
import 'package:mind_clean/pages/chat_page.dart';
import 'package:mind_clean/pages/forgot_password_page.dart';
import 'package:mind_clean/utils/app_routes.dart';
import 'package:mind_clean/pages/auth_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Mind Clean',
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: const Color(0xFF242C3B),
            secondary: const Color(0xFF3D98EB),
            surface: const Color(0xFF424C62),
            error: Colors.red,
            onPrimary: const Color(0xFFF5F5F5),
            onSecondary: const Color(0xFFF5F5F5),
            onSurface: const Color(0xFF242C3B),
            onError: Colors.red,
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            // Definindo texto padrão e título
            bodyLarge: TextStyle(color: Color(0xFFF5F5F5)),
            bodyMedium: TextStyle(color: Color(0xFFA7A9AF)),
            bodySmall: TextStyle(color: Color(0xFFA7A9AF)),
          ),
        ),
        initialRoute: AppRoutes.AUTH,
        routes: {
          AppRoutes.AUTH: (ctx) => const AuthPage(),
          AppRoutes.CHAT: (ctx) => const ChatPage(),
          AppRoutes.FORGOT_PASSWORD: (ctx) => const ForgotPasswordPage(),
        },
      ),
    );
  }
}
