import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/home_page/cubit/home_page_cubit.dart';
import 'route/route.dart';
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode, required this.isLogin});

  final AdaptiveThemeMode? savedThemeMode;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      debugShowFloatingThemeButton: true,
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

// class PCApp extends StatefulWidget {
//   const PCApp({super.key});

//   @override
//   State<PCApp> createState() => _PCAppState();
// }

// class _PCAppState extends State<PCApp> {
//   double sliderValue = 100;
//   double height = 100;
//   double width = 300;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//           child: Column(
//         children: [
//           Slider(
//             max: 300,
//             min: 100,
//             value: height,
//             onChanged: (value) {
//               setState(() {
//                 sliderValue = value;
//                 height = value;
//               });
//             },
//           ),
//           BarcodeWidget(
//             backgroundColor: Colors.white,
//             height: height,
//             width: height*2.5,
//             padding: EdgeInsets.all(height*2.5 / 40),
//             barcode: Barcode.code128(),
//             data: '5906083851209',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall!
//                 .copyWith(color: Colors.black),
//           ),
//         ],
//       )),
//     );
//   }
// }
