import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/home_page/cubit/home_page_cubit.dart';
import 'route/route.dart';
import 'ui/ui.dart';

class OldMyApp extends StatelessWidget {
  const OldMyApp({super.key, required this.savedThemeMode, required this.isLogin});

  final AdaptiveThemeMode? savedThemeMode;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      // debugShowFloatingThemeButton: true,
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) {
        return BlocProvider(
          create: (context) => HomePageCubit(),
          child: MaterialApp(
            initialRoute: getInitialPage(),
            onGenerateRoute: RouteGenerator.generateRoute,
            theme: light,
            darkTheme: dark,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }

  String getInitialPage() => isLogin ? AppRoutes.homePage : AppRoutes.login;
}
