// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/settings/cubit/settings_cubit.dart';

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
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/homePage', (route) => false);
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
            child:ListView(
            primary: false,
              children: [
                const DataBasePathWidget(),
                HomePageSettingsWidhet(
                  generationButton: state.generationButton,
                  printButton: state.printButton,
                  cellInfoButton: state.cellInfoButton,
                ),
                const PrinterSettingsWidget(),
                const LogOutWidget()
              ],
            )
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

class HomePageSettingsWidhet extends StatefulWidget {
  HomePageSettingsWidhet(
      {super.key,
      required this.generationButton,
      required this.printButton,
      required this.cellInfoButton});

  bool generationButton;
  bool printButton;
  bool cellInfoButton;

  @override
  State<HomePageSettingsWidhet> createState() => _HomePageSettingsWidhetState();
}

class _HomePageSettingsWidhetState extends State<HomePageSettingsWidhet> {
  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: ExpansionTile(
        title: const Text('Налаштування головної сторінки'),
        shape: Border.all(color: Colors.transparent),
        children: [
          ListTile(
            title: const Text('Присвоєння штрихкоду'),
            trailing: Switch(
                value: widget.generationButton,
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();

                  prefs.setBool('generation_bar_button', value);
                  setState(() => widget.generationButton = value);
                }),
          ),
          ListTile(
            title: const Text('Друк етикетки'),
            trailing: Switch(
                value: widget.printButton,
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();

                  prefs.setBool('barcode_print_lable_button', value);
                  setState(() => widget.printButton = value);
                }),
          ),
          ListTile(
            title: const Text('Комірка'),
            trailing: Switch(
                value: widget.cellInfoButton,
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();

                  prefs.setBool('cell_info_button', value);
                  setState(() => widget.cellInfoButton = value);
                }),
          )
        ],
      ),
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
      trailing:    IconButton(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('password');
                prefs.remove('username');
              },
              icon:  const Icon(Icons.logout_rounded, color: Color.fromARGB(255, 199, 0, 0),)),
    ));
  }
}
