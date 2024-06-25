// import 'dart:async';

// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:virok_wms/auth/view/auth_view.dart';
// import 'package:virok_wms/const.dart';

// import 'feature/home_page/cubit/home_page_cubit.dart';
// import 'route/route.dart';
// import 'ui/ui.dart';

// class MyApp extends StatelessWidget {
//   MyApp({super.key, required this.savedThemeMode});

//   final AdaptiveThemeMode? savedThemeMode;

//   final _navigatorKey = GlobalKey<NavigatorState>();
//   NavigatorState get _navigator => _navigatorKey.currentState!;

//   final sessionStateStream = StreamController<SessionState>();

//   @override
//   Widget build(BuildContext context) {
//     final sessionConfig = SessionConfig(
//       invalidateSessionForAppLostFocus: const Duration(minutes: timeOut),
//       invalidateSessionForUserInactivity: const Duration(minutes: timeOut),
//     );
//     sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
//       sessionStateStream.add(SessionState.stopListening);
//       if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
//         _navigator.pushAndRemoveUntil(
//             MaterialPageRoute(
//                 builder: (_) => AuthPage(
//                       sessionStateStream: sessionStateStream,
//                     )),
//             (route) => false);
//       } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
//         _navigator.pushAndRemoveUntil(
//             MaterialPageRoute(
//                 builder: (_) => AuthPage(
//                       sessionStateStream: sessionStateStream,
//                     )),
//             (route) => false);
//       }
//     });
    // return AdaptiveTheme(
    //   debugShowFloatingThemeButton: true,
    //   light: AppTheme.light,
    //   dark: AppTheme.dark,
    //   initial: savedThemeMode ?? AdaptiveThemeMode.light,
    //   builder: (light, dark) {
    //     return BlocProvider(
    //       create: (context) => HomePageCubit(),
    //       child: SessionTimeoutManager(
    //         userActivityDebounceDuration: const Duration(seconds: 1),
    //         sessionConfig: sessionConfig,
    //         sessionStateStream: sessionStateStream.stream,
    //         child: MaterialApp(
    //           navigatorKey: _navigatorKey,
    //           home: AuthPage(
    //             sessionStateStream: sessionStateStream,
    //           ),
    //           onGenerateRoute: RouteGenerator.generateRoute,
    //           theme: light,
    //           darkTheme: dark,
    //           debugShowCheckedModeBanner: false,
    //         ),
    //       ),
    //     );
//       },
//     );
//   }
// }
