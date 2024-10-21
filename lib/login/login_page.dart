import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/login/cubit/login_cubit.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

import '../feature/home_page/cubit/home_page_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isLogin) {
            context.read<HomePageCubit>().getUser();
            context.read<HomePageCubit>().getActivButton();
            context.read<HomePageCubit>().checkTsdType();

            Navigator.pushReplacementNamed(context, AppRoutes.homePage);
          }
          if (state.status.isUnknown) {
            Alerts(msg: 'Користувача не знайдено', context: context)
                .showToast();
          }
          if (state.status.isFailure) {
            Alerts(
                    msg: 'Не має звязку з сервером',
                    color: const Color.fromARGB(255, 165, 11, 0),
                    context: context)
                .showToast();
          }
        },
        buildWhen: (previous, current) =>
            !current.status.isSaccsses || !current.status.isFailure,
        builder: (context, state) {
          if (state.status.isInitial) {
            context.read<LoginCubit>().writeDbPath();
          }
          if (state.status.a) {
            if (state.dbPath.isNotEmpty) {
              context.read<LoginCubit>().getUsers(state.dbPath);
            }
          }

          return const LoginView();
        },
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final pathController = TextEditingController();

  final passFocus = FocusNode();
  bool _passVisible = true;
  @override
  void initState() {
    context.read<LoginCubit>().fetchPathesCollection();

    super.initState();
  }

  bool isEnabled() {
    bool res;
    final zone = context.read<LoginCubit>().state.zone;
    if (zone.isEmpty || passwordController.text.isEmpty) {
      res = false;
    } else {
      res = true;
    }
    setState(() {});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.select((LoginCubit cubit) => cubit.state);
    state.status.a ? pathController.text = state.dbPath : pathController;
    final themeMode = AdaptiveTheme.of(context).mode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0.0, // Make the IconButton fully transparent
                  child: IconButton(
                    onPressed: null, // Disabled button
                    icon: Icon(Icons.refresh),
                    color:
                        Colors.transparent, // Set the icon color to transparent
                  ),
                ),
// Optional: Add spacing between text and button
                // Add a Spacer widget to push the button to the right
                Text(
                  'Вхід',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    context.read<LoginCubit>().forceFetchPathesCollection();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),
            TextField(
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('api', value);
                  if (context.mounted) {
                    context.read<LoginCubit>().getUsers(value);
                  }
                }
              },
              controller: pathController,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Шлях до бази',
                hintStyle: TextStyle(
                  color: themeMode.isDark ? Colors.white : Colors.black,
                ),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    pathController.text = value;
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('api', value);
                    context.read<LoginCubit>().getUsers(value);
                  },
                  itemBuilder: (context) {
                    return state.pathes.isNotEmpty
                        ? state.pathes.expand<PopupMenuItem<String>>((path) {
                            final keys = path.keys.toList();
                            return keys.map<PopupMenuItem<String>>((key) {
                              return PopupMenuItem<String>(
                                value: path[key],
                                child: Text(key),
                              );
                            }).toList();
                          }).toList()
                        : [];
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            const LoginPopupButton(),

            // TextField(
            //   onChanged: (value) {
            //     isEnamled();
            //   },
            //   textInputAction: TextInputAction.next,
            //   controller: loginController,
            //   decoration: const InputDecoration(hintText: 'Логін'),
            // ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                isEnabled();
              },
              onSubmitted: (value) {
                final String zone = context.read<LoginCubit>().state.zone;

                isEnabled()
                    ? context
                        .read<LoginCubit>()
                        .login(zone, passwordController.text)
                    : () {};
              },
              textInputAction: TextInputAction.search,
              controller: passwordController,
              obscureText: _passVisible,
              obscuringCharacter: '●',
              decoration: InputDecoration(
                  hintText: 'Пароль',
                  hintStyle: TextStyle(
                      color: themeMode.isDark ? Colors.white : Colors.black),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _passVisible = !_passVisible;
                        setState(() {});
                      },
                      splashRadius: 0.1,
                      icon: _passVisible
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: Colors.grey,
                            ))),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                final String zone = context.read<LoginCubit>().state.zone;
                isEnabled()
                    ? context
                        .read<LoginCubit>()
                        .login(zone, passwordController.text)
                    : () {};
              },
              style: theme.elevatedButtonTheme.style!.copyWith(
                  fixedSize: const MaterialStatePropertyAll(
                      Size.fromWidth(double.infinity)),
                  backgroundColor: MaterialStatePropertyAll(
                      isEnabled() ? const Color(0xFFB10000) : Colors.grey)),
              child: const Text('Увійти'),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.status.isLoading) {
                  return const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPopupButton extends StatelessWidget {
  const LoginPopupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> popupItem = [];
    final users = context.select((LoginCubit cubit) => cubit.state.users.users);
    if (users.isEmpty) {
      popupItem.add(const PopupMenuItem(child: Text('Зону не знайдено')));
    }
    for (var name in users) {
      popupItem.add(PopupMenuItem(
        value: name.user,
        child: Text(name.user),
      ));
    }

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final themeMode = AdaptiveTheme.of(context).mode;
        return Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PopupMenuButton(
                offset: const Offset(0, 38),
                elevation: 5,
                onSelected: (value) {
                  context.read<LoginCubit>().writeZone(value);
                },
                itemBuilder: (context) => popupItem,
                child: Row(
                  children: [
                    Text(
                      state.zone.isEmpty ? 'Зона складу' : state.zone,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              themeMode.isDark ? Colors.white : Colors.black),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: themeMode.isDark ? Colors.white : Colors.black)
                  ],
                ),
              ),
            ));
      },
    );
  }
}
