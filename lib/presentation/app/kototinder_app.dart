import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../auth/auth_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'app_flow_controller.dart';
import 'main_tabs.dart';

class KototinderApp extends StatefulWidget {
  const KototinderApp({super.key, required this.scope});

  final AppScope scope;

  @override
  State<KototinderApp> createState() => _KototinderAppState();
}

class _KototinderAppState extends State<KototinderApp> {
  @override
  void initState() {
    super.initState();
    widget.scope.appFlowController.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFFFFF4E8);
    const accent = Color(0xFFE8673C);
    const deep = Color(0xFF243447);

    return MaterialApp(
      title: 'Kototinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.light,
          primary: accent,
          secondary: const Color(0xFF0E7C7B),
          surface: cardColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFCF9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: deep,
            letterSpacing: 0.2,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: deep,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: deep, height: 1.3),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF43576A),
            height: 1.35,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: false,
          foregroundColor: deep,
        ),
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: AnimatedBuilder(
        animation: widget.scope.appFlowController,
        builder: (context, _) {
          final state = widget.scope.appFlowController.state;
          return switch (state) {
            AppFlowState.loading => const _LoadingScreen(),
            AppFlowState.onboarding => OnboardingScreen(
              onFinished: widget.scope.appFlowController.completeOnboarding,
            ),
            AppFlowState.auth => AuthScreen(
              controller: widget.scope.authController,
              onAuthenticated: widget.scope.appFlowController.onAuthenticated,
            ),
            AppFlowState.main => MainTabs(
              homeController: widget.scope.homeController,
              breedsController: widget.scope.breedsController,
              onSignOut: widget.scope.appFlowController.signOut,
            ),
          };
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
