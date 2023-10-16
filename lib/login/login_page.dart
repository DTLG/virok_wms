import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/login/cubit/login_cubit.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isLogin) {
            Navigator.pushReplacementNamed(
                context, '/homePage');
          }
          if (state.status.isUnknown) {
            Alerts(msg: 'Користувача не знайдено', context: context)
                .showNotFoundAlert();
          }
          if (state.status.isFailure) {
            Alerts(
                    msg: 'Не має звязку з сервером',
                    color: const Color.fromARGB(255, 165, 11, 0),
                    context: context)
                .showNotFoundAlert();
          }
        },
        child: const LoginView(),
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
  final passController = TextEditingController();

  final passFocus = FocusNode();
  bool _passVisible = true;

  bool isEnamled() {
    bool res;
    if (loginController.text.isEmpty || passwordController.text.isEmpty) {
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
            const Text(
              'Вхід',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (value) async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString('api', value);
              },
              textInputAction: TextInputAction.next,
              controller: passController,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(hintText: 'Шлях до бази'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {
                isEnamled();
              },
              textInputAction: TextInputAction.next,
              controller: loginController,
              decoration: const InputDecoration(hintText: 'Логін'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {
                isEnamled();
              },
              onSubmitted: (value) {
                isEnamled()
                    ? context
                        .read<LoginCubit>()
                        .login(loginController.text, passwordController.text)
                    : () {};
              },
              textInputAction: TextInputAction.search,
              controller: passwordController,
              obscureText: _passVisible,
              obscuringCharacter: '●',
              decoration: InputDecoration(
                  hintText: 'Пароль',
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
                isEnamled()
                    ? context
                        .read<LoginCubit>()
                        .login(loginController.text, passwordController.text)
                    : () {};
              },
              style: theme.elevatedButtonTheme.style!.copyWith(
                  fixedSize: const MaterialStatePropertyAll(
                      Size.fromWidth(double.infinity)),
                  backgroundColor: MaterialStatePropertyAll(
                      isEnamled() ? const Color(0xFFB10000) : Colors.grey)),
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
