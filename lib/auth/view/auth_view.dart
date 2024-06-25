// import 'dart:async';

// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:virok_wms/auth/cubit/auth_cubit.dart';
// import 'package:virok_wms/const.dart';
// import 'package:virok_wms/utils.dart';

// import '../../feature/home_page/cubit/home_page_cubit.dart';
// import '../../route/app_routes.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key, required this.sessionStateStream});

//   final StreamController<SessionState> sessionStateStream;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AuthCubit(),
//       child: AuthView(
//         sessionStateStream: sessionStateStream,
//       ),
//     );
//   }
// }

// class AuthView extends StatelessWidget {
//   const AuthView({super.key, required this.sessionStateStream});
//   final StreamController<SessionState> sessionStateStream;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         body: BlocListener<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state.status.isFailure) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(content: Text(state.errorMassage)),
//                 );
//             }
//             if (state.status.isLogin) {
//               context.read<HomePageCubit>().getUser();
//               context.read<HomePageCubit>().getActivButton();
//               context.read<HomePageCubit>().checkTsdType();
//               Navigator.pushReplacementNamed(context, AppRoutes.homePage);
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: const Alignment(0, -1 / 3),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 30),
//                       child: Text(
//                         'Вхід',
//                         style: theme.textTheme.displayMedium,
//                       ),
//                     ),
//                     _ApiInput(),
//                     const Padding(padding: EdgeInsets.all(5)),
//                     _ZoneInput(),
//                     const Padding(padding: EdgeInsets.all(5)),
//                     _UserInput(),
//                     const Padding(padding: EdgeInsets.all(5)),
//                     _PasswordInput(),
//                     const Padding(padding: EdgeInsets.all(16)),
//                     LogInButton(
//                       sessionStateStream: sessionStateStream,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ApiInput extends StatefulWidget {
//   @override
//   State<_ApiInput> createState() => _ApiInputState();
// }



// class _ApiInputState extends State<_ApiInput> {
//   InputType _inputType = InputType.popup;

//   final List<PopupMenuItem> popupItem = [
//     const PopupMenuItem(
//       value: apiLviv222,
//       child: Text('Львів_222'),
//     ),
//     const PopupMenuItem(
//       value: apiLviv178,
//       child: Text('Львів_178'),
//     ),
//     const PopupMenuItem(
//       value: apiKyiv,
//       child: Text('Київ'),
//     ),
//     const PopupMenuItem(
//       value: apiLvivTest,
//       child: Text('Львів_тест'),
//     ),
//     const PopupMenuItem(
//       value: apiKyivTest,
//       child: Text('Київ_тест'),
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = AdaptiveTheme.of(context).mode;

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         return Stack(
//           children: [
//             _inputType.isPopup
//                 ? Container(
//                     width: double.infinity,
//                     height: 54,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: PopupMenuButton(
//                         offset: const Offset(-20, 58),
//                         elevation: 5,
//                         onSelected: (value) {
//                           context.read<AuthCubit>().selectPath(value);
//                         },
//                         itemBuilder: (context) => popupItem,
//                         child: Row(
//                           children: [
//                             Icon(Icons.keyboard_arrow_down_rounded,
//                                 color: themeMode.isDark
//                                     ? Colors.white
//                                     : Colors.black),
//                             Text(
//                               state.dbPath.isEmpty
//                                   ? 'Шлях до бази'
//                                   : state.dbPath,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: themeMode.isDark
//                                       ? Colors.white
//                                       : Colors.black),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ))
//                 : TextField(
//                     onSubmitted: (value) =>
//                         context.read<AuthCubit>().selectPath(value),
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: themeMode.isDark ? Colors.white : Colors.black),
//                     decoration: const InputDecoration(
//                         labelText: 'Введіть шлях до бази'),
//                   ),
//             Positioned(
//                 top: 16.5,
//                 right: 10,
//                 child: IconButton(
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                     onPressed: () {
//                       _inputType = _inputType.isPopup
//                           ? InputType.textField
//                           : InputType.popup;
//                       setState(() {});
//                     },
//                     icon: _inputType.isTextField
//                         ? const Icon(
//                             Icons.arrow_drop_down_outlined,
//                             color: Colors.grey,
//                           )
//                         : const Icon(
//                             Icons.mode,
//                             size: 18,
//                             color: Colors.grey,
//                           )))
//           ],
//         );
//       },
//     );
//   }
// }

// class _ZoneInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = AdaptiveTheme.of(context).mode;

//     List<PopupMenuItem> popupItem = [];
//     final zones =
//         context.select((AuthCubit cubit) => cubit.state.usersAndZones.zones);
//     if (zones.isEmpty) {
//       popupItem.add(const PopupMenuItem(child: Text('Зону не знайдено')));
//     }
//     for (var name in zones) {
//       popupItem.add(PopupMenuItem(
//         value: name.user,
//         child: Text(name.user),
//       ));
//     }

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         return Container(
//             width: double.infinity,
//             height: 54,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: PopupMenuButton(
//                 offset: const Offset(0, 38),
//                 elevation: 5,
//                 onSelected: (value) {
//                   context.read<AuthCubit>().selectZone(value);
//                 },
//                 itemBuilder: (context) => popupItem,
//                 child: Row(
//                   children: [
//                     Icon(Icons.keyboard_arrow_down_rounded,
//                         color: themeMode.isDark ? Colors.white : Colors.black),
//                     Text(
//                       state.zone.isEmpty ? 'Зона складу' : state.zone,
//                       style: TextStyle(
//                           fontSize: 13,
//                           color:
//                               themeMode.isDark ? Colors.white : Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//       },
//     );
//   }
// }

// class _UserInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = AdaptiveTheme.of(context).mode;

//     List<PopupMenuItem> popupItem = [];
//     final users =
//         context.select((AuthCubit cubit) => cubit.state.usersAndZones.users);
//     if (users.isEmpty) {
//       popupItem.add(const PopupMenuItem(child: Text('Користувача не знайдено')));
//     }
//     for (var name in users) {
//       popupItem.add(PopupMenuItem(
//         value: name.user,
//         child: Text(name.user),
//       ));
//     }

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         return Container(
//             width: double.infinity,
//             height: 54,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: PopupMenuButton(
//                 offset: const Offset(0, 38),
//                 elevation: 5,
//                 onSelected: (value) {
//                   context.read<AuthCubit>().selectUser(value);
//                 },
//                 itemBuilder: (context) => popupItem,
//                 child: Row(
//                   children: [
//                     Icon(Icons.keyboard_arrow_down_rounded,
//                         color: themeMode.isDark ? Colors.white : Colors.black),
//                     Text(
//                       state.user.isEmpty ? 'Користувач' : state.user,
//                       style: TextStyle(
//                           fontSize: 13,
//                           color:
//                               themeMode.isDark ? Colors.white : Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = AdaptiveTheme.of(context).mode;

//     return SizedBox(
//       height: 54,
//       child: TextField(
//         onChanged: (pass) => context.read<AuthCubit>().changeZonePass(pass),
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           labelText: 'Пароль',
//           labelStyle: TextStyle(
//               fontSize: 13,
//               color: themeMode.isDark ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }
// }

// class LogInButton extends StatelessWidget {
//   const LogInButton({super.key, required this.sessionStateStream});

//   final StreamController<SessionState> sessionStateStream;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         final isEnabled = state.dbPath.isNotEmpty &&
//                 state.zone.isNotEmpty &&
//                 // state.userPass.isNotEmpty &&
//                 state.user.isNotEmpty
//             ? true
//             : false;

//         return ElevatedButton(
//           onPressed: () {
//             sessionStateStream.add(SessionState.startListening);

//             if (!isEnabled) return;
//             context.read<AuthCubit>().logIn();
//           },
//           style: theme.elevatedButtonTheme.style!.copyWith(
//               fixedSize: const MaterialStatePropertyAll(
//                   Size.fromWidth(double.infinity)),
//               backgroundColor: MaterialStatePropertyAll(
//                   isEnabled ? const Color(0xFFB10000) : Colors.grey)),
//           child: BlocBuilder<AuthCubit, AuthState>(
//             builder: (context, state) {
//               if (state.status.isLoading) {
//                 return const Padding(
//                   padding: EdgeInsets.all(4.0),
//                   child: CircularProgressIndicator(
//                     color: Color.fromARGB(255, 234, 234, 234),
//                   ),
//                 );
//               }
//               return const Text('Увійти');
//             },
//           ),
//         );
//       },
//     );
//   }
// }
