// ignore_for_file: must_be_immutable

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/feature/settings/cubit/settings_cubit.dart';

import '../home_page/cubit/home_page_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.status.isInitial) {
          context.read<SettingsCubit>().init();
        }

        return WillPopScope(
          onWillPop: () async {
            context.read<HomePageCubit>().getActivButton();
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: const SizedBox(),
              actions: [
                TextButton(
                    onPressed: () {
                      context.read<HomePageCubit>().getActivButton();
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.homePage, (route) => false);
                    },
                    child: const Text(
                      'Зберегти',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ))
              ],
              title: const Text("Налаштування"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  primary: false,
                  children: const [
                    DataBasePathWidget(),
                    HomePageSettingsWidget(),
                    StorageOperationSettingsWidget(),
                    PrinterSettingsWidget(),
                    ThemeSettings(),
                    CameraSettings()
                  ],
                )),
          ),
        );
      },
    );
  }
}

class DataBasePathWidget extends StatefulWidget {
  const DataBasePathWidget({super.key});

  @override
  State<DataBasePathWidget> createState() => _DataBasePathWidgetState();
}

class _DataBasePathWidgetState extends State<DataBasePathWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final dbPath = context.select((SettingsCubit cubit) => cubit.state.dbPath);

    controller.text = dbPath;
    return SettingsCard(
      child: ExpansionTile(
        title: const Text('Шлях до бази даних'),
        shape: Border.all(color: Colors.transparent),
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 12),
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('api', value);
              },
              decoration: const InputDecoration(

                  // suffixIcon: IconButton(
                  //     onPressed: () {
                  //       controller.clear();
                  //       focusNode.requestFocus();
                  //     },
                  //     icon: const Icon(Icons.clear)),
                  hintText: 'Відскануйте шлях до бази'),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageSettingsWidget extends StatelessWidget {
  const HomePageSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsCard(
          child: ExpansionTile(
            title: const Text('Налаштування головної сторінки'),
            shape: Border.all(color: Colors.transparent),
            children: [
              ListTile(
                title: const Text('Завдання на відбір'),
                trailing: Switch(
                    value: state.selectionButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('selection_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Поступлення'),
                trailing: Switch(
                    value: state.admissionButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('admission_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Переміщення'),
                trailing: Switch(
                    value: state.movingButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('moving_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Повернення'),
                trailing: Switch(
                    value: state.returningButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('returning_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Підпитка'),
                trailing: Switch(
                    value: state.rechargeButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('recharge_button', value);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StorageOperationSettingsWidget extends StatelessWidget {
  const StorageOperationSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsCard(
          child: ExpansionTile(
            title: const Text('Налаштування складських операцій'),
            shape: Border.all(color: Colors.transparent),
            children: [
              ListTile(
                title: const Text('Розміщення товарів'),
                trailing: Switch(
                    value: state.placementButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('placement_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Списання товарів'),
                trailing: Switch(
                    value: state.writeOffButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('writing_off_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Генерація штрихкоду'),
                trailing: Switch(
                    value: state.generationButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('generation_bar_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Друк етикетки'),
                trailing: Switch(
                    value: state.printButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('barcode_print_lable_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Комірка'),
                trailing: Switch(
                    value: state.cellInfoButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('cell_info_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Кошик'),
                trailing: Switch(
                    value: state.basketInfoButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('basket_info_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Друк етикетки комірки'),
                trailing: Switch(
                    value: state.cellGeneratorButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('cell_generator_button', value);
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}

class PrinterSettingsWidget extends StatefulWidget {
  const PrinterSettingsWidget({super.key});

  @override
  State<PrinterSettingsWidget> createState() => _PrinterSettingsWidgetState();
}

class _PrinterSettingsWidgetState extends State<PrinterSettingsWidget> {
  final hostController = TextEditingController();
  final portController = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final state = context.select((SettingsCubit cubit) => cubit.state);

    hostController.text = state.printerHost;
    portController.text = state.printerPort;
    return SettingsCard(
      child: ExpansionTile(
        title: const Text('Налаштування принтера'),
        shape: Border.all(color: Colors.transparent),
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              focusNode: focusNode,
              style: const TextStyle(fontSize: 12),
              controller: hostController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('printer_host', value);
              },
              onSubmitted: (value) {
                focusNode.nextFocus();
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        hostController.clear();
                        focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.clear)),
                  hintText: 'host'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: TextField(
              style: const TextStyle(fontSize: 12),
              controller: portController,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('printer_port', value);
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        portController.clear();
                        focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.clear)),
                  hintText: 'port'),
            ),
          ),
        ],
      ),
    );
  }
}

class Statisticwidget extends StatefulWidget {
  const Statisticwidget({super.key});

  @override
  State<Statisticwidget> createState() => _StatisticwidgetState();
}

class _StatisticwidgetState extends State<Statisticwidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsCard(
          child: ExpansionTile(
            title: const Text('Статистика'),
            shape: Border.all(color: Colors.transparent),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Кількість 406 помилок',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(state.errorCounter,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Кількість 406 помилок за 1 год',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text(state.errorCounterH,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Кількість запитів',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text(state.scan,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Кількість запитів за 1 год',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text(state.scanH,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
         final theme = AdaptiveTheme.of(context).mode;

    return Card(
      elevation: 3,
      color: theme.isLight?
      
       const Color.fromARGB(255, 243, 243, 243):Color.fromARGB(255, 67, 67, 67),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
        child: ListTile(
      contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      title: const Text('Вийти'),
      trailing: IconButton(
          onPressed: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false);
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('password');
            prefs.remove('username');
          },
          icon: const Icon(
            Icons.logout_rounded,
            color: Color.fromARGB(255, 199, 0, 0),
          )),
    ));
  }
}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    final themeManager = AdaptiveTheme.of(context);
    _switchValue = themeManager.mode.isDark ? true : false;

    return SettingsCard(
        child: ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: const Text('Темна тема'),
            trailing: Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                  _switchValue == false
                      ? AdaptiveTheme.of(context).setLight()
                      : AdaptiveTheme.of(context).setDark();
                });
              },
            )));
  }
}

class CameraSettings extends StatelessWidget {
  const CameraSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsCard(
          child: ListTile(
            title: const Text('Камера'),
            contentPadding: const EdgeInsets.only(left: 20),
            trailing: Switch(
                value: state.cameraScaner,
                onChanged: (value) async {
                  context
                      .read<SettingsCubit>()
                      .writeToSP('camera_scaner', value);
                }),
          ),
        );
      },
    );
  }
}
