import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'feature/home_page/cubit/home_page_cubit.dart';
import 'route/route.dart';
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(),
      child: MaterialApp(
        initialRoute: getInitialPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
       
      ),
    );
  }

  String getInitialPage() => isLogin ? AppRoutes.homePage : AppRoutes.login;
}
