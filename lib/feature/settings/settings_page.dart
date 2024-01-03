// ignore_for_file: must_be_immutable

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

        return Scaffold(
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
                  StorageOperationSettingsWidhet(
                   
                  ),
                  PrinterSettingsWidget(),
                  LogOutWidget()
                ],
              )),
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
              style: const TextStyle(fontSize: 12),
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('api', value);
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                        focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.clear)),
                  hintText: 'Відскануйте шлях до бази'),
            ),
          ),
        ],
      ),
    );
  }
}

class StorageOperationSettingsWidhet extends StatefulWidget {
  const StorageOperationSettingsWidhet(
      {super.key,});



  @override
  State<StorageOperationSettingsWidhet> createState() =>
      _StorageOperationSettingsWidhetState();
}

class _StorageOperationSettingsWidhetState
    extends State<StorageOperationSettingsWidhet> {
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

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 243, 243, 243),
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
