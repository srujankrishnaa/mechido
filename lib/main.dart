import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signin_screen.dart';
import 'config/theme.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vygkofpomhykmlpmyjzq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5Z2tvZnBvbWh5a21scG15anpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NTk5OTEsImV4cCI6MjA2MzEzNTk5MX0.SXb-MT4vuR23saHehPAavVtJsHSQhtsFLWNEZ7-VU8s',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MechidoApp(),
    ),
  );
}

class MechidoApp extends StatelessWidget {
  const MechidoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechido',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
