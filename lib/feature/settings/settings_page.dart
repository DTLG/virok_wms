// ignore_for_file: must_be_immutable

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/feature/settings/cubit/settings_cubit.dart';
import 'package:virok_wms/utils.dart';

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
          context.read<SettingsCubit>().getStorage();
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
                      context.read<HomePageCubit>().getRefreshTime();

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
                    _StorageWidget(),
                    PrinterSettingsWidget(),
                    ThemeSettings(),
                    CameraSettings(),
                    AutoRefreshTimeSettings(),
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
              decoration:
                  const InputDecoration(hintText: 'Відскануйте шлях до бази'),
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
              ListTile(
                title: const Text('Друк ттн НП'),
                trailing: Switch(
                    value: state.npTtnPrintButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('np_ttn_print_button', value);
                    }),
              ),
              ListTile(
                title: const Text('Друк ттн Meest'),
                trailing: Switch(
                    value: state.meestTtnPrintButton,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('meest_ttn_print_button', value);
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
              ),
              ListTile(
                title: const Text('Операції з корзинами'),
                trailing: Switch(
                    value: state.basketOperation,
                    onChanged: (value) async {
                      context
                          .read<SettingsCubit>()
                          .writeToSP('basketOperation', value);
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

class _StorageWidget extends StatefulWidget {
  const _StorageWidget();

  @override
  State<_StorageWidget> createState() => _StorageWidgetState();
}

class _StorageWidgetState extends State<_StorageWidget> {
  @override
  Widget build(BuildContext context) {
    return SettingsCard(child: BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return PopupMenuButton(
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none),
          offset: const Offset(1, 51),
          onSelected: (value) {
            context.read<SettingsCubit>().setStorage(value);
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: Storages.lviv,
                child: Text('Львів'),
              ),
              const PopupMenuItem(
                value: Storages.kyiv,
                child: Text('Київ'),
              ),
              const PopupMenuItem(
                value: Storages.harkiv,
                child: Text('Харків'),
              ),
            ];
          },
          child: ListTile(
            title: const Text('Склад'),
            trailing: Text(state.storage.toStr),
            shape: Border.all(color: Colors.transparent),
          ),
        );
      },
    ));
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
      color: theme.isLight
          ? const Color.fromARGB(255, 243, 243, 243)
          : const Color.fromARGB(255, 67, 67, 67),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
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

class AutoRefreshTimeSettings extends StatefulWidget {
  const AutoRefreshTimeSettings({super.key});

  @override
  State<AutoRefreshTimeSettings> createState() =>
      _AutoRefreshTimeSettingsState();
}

class _AutoRefreshTimeSettingsState extends State<AutoRefreshTimeSettings> {
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: true,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsCard(
          child: ListTile(
              onTap: () {
                _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    scrollController: FixedExtentScrollController(
                      initialItem: _seconds.indexOf(state.autoRefreshTime),
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      context
                          .read<SettingsCubit>()
                          .changeRefreshTime(_seconds[selectedItem]);
                    },
                    children:
                        List<Widget>.generate(_seconds.length, (int index) {
                      return Center(child: Text(_seconds[index].toString()));
                    }),
                  ),
                );
              },
              title: const Text('Час авто оновлення'),
              contentPadding: const EdgeInsets.only(left: 20),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    return Text('${state.autoRefreshTime} сек.');
                  },
                ),
              )),
        );
      },
    );
  }
}

const double _kItemExtent = 32.0;
List<int> _seconds = List.generate(496, (index) => index + 5);

// class DeviceIdWidget extends StatefulWidget {
//   const DeviceIdWidget({super.key});

//   @override
//   State<DeviceIdWidget> createState() => _DeviceIdWidgetState();
// }

// class _DeviceIdWidgetState extends State<DeviceIdWidget> {
//   final controller = TextEditingController();
//   InputType _inputType = InputType.popup;

//   @override
//   Widget build(BuildContext context) {
//     final deviceId =
//         context.select((SettingsCubit cubit) => cubit.state.deviceId);

//     controller.text = deviceId;

//     final themeMode = AdaptiveTheme.of(context).mode;

//     List<PopupMenuItem> popupItem = [];
//     final deviceIds =
//         context.select((SettingsCubit cubit) => cubit.state.deviceIds);
//     if (deviceIds.ids.isEmpty) {
//       popupItem.add(const PopupMenuItem(child: Text('Зону не знайдено')));
//     }
//     for (var id in deviceIds.ids) {
//       popupItem.add(PopupMenuItem(
//         value: id.id,
//         child: Text(id.id),
//       ));
//     }
//     return SettingsCard(child: BlocBuilder<SettingsCubit, SettingsState>(
//       builder: (context, state) {
//         return ExpansionTile(
//           title: const Text('Серійний номер'),
//           shape: Border.all(color: Colors.transparent),
//           children: [
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: _inputType.isPopup
//                       ? Container(
//                           width: double.infinity,
//                           height: 54,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: PopupMenuButton(
//                               offset: const Offset(0, 38),
//                               elevation: 5,
//                               onSelected: (value) {
//                                 context
//                                     .read<SettingsCubit>()
//                                     .selectDeviceId(value);
//                               },
//                               itemBuilder: (context) => popupItem,
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.keyboard_arrow_down_rounded,
//                                       color: themeMode.isDark
//                                           ? Colors.white
//                                           : Colors.black),
//                                   Text(
//                                     state.deviceId.isEmpty
//                                         ? 'Виберіть серійний номер'
//                                         : state.deviceId,
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: themeMode.isDark
//                                             ? Colors.white
//                                             : Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ))
//                       : SizedBox(
//                           height: 54,
//                           child: TextField(
//                             style: const TextStyle(fontSize: 15),
//                             controller: controller,
//                             autofocus: true,
//                             onChanged: (value) async {
//                               context
//                                   .read<SettingsCubit>()
//                                   .selectDeviceId(value);
//                             },
//                             textAlignVertical: TextAlignVertical.bottom,
//                             decoration: const InputDecoration(
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(35, 22, 5, 18),
//                                 hintText: 'Введіть серійний номер'),
//                           ),
//                         ),
//                 ),
//                 Positioned(
//                     top: 20,
//                     right: 15,
//                     child: IconButton(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         onPressed: () {
//                           _inputType = _inputType.isPopup
//                               ? InputType.textField
//                               : InputType.popup;
//                           setState(() {});
//                         },
//                         icon: _inputType.isTextField
//                             ? const Icon(
//                                 Icons.arrow_drop_down_outlined,
//                                 color: Colors.grey,
//                               )
//                             : const Icon(
//                                 Icons.mode,
//                                 size: 18,
//                                 color: Colors.grey,
//                               )))
//               ],
//             ),
//           ],
//         );
//       },
//     ));
//   }
// }
