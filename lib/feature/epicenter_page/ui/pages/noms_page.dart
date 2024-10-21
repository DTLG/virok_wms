import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/epicenter_page/client/print_label.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/noms_page_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/epicenter_cubit.dart'; // Import EpicenterCubit
import 'package:virok_wms/feature/epicenter_page/model/document.dart';
import 'package:virok_wms/feature/epicenter_page/model/label_info.dart';
import 'package:virok_wms/feature/epicenter_page/ui/widget/table.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/widgets/table_head.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/app_bar_button.dart';
import 'package:virok_wms/ui/widgets/general_button.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';
import 'package:scanwedge/scanwedge.dart';

SoundInterface soundInterface = SoundInterface();

class NomsPage extends StatelessWidget {
  const NomsPage({super.key, required this.doc});
  final Document doc;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NomsPageCubit()),
        BlocProvider(create: (context) => EpicenterCubit()),
      ],
      child: NomsDataView(
        doc: doc,
      ),
    );
  }
}

class NomsDataView extends StatefulWidget {
  const NomsDataView({super.key, required this.doc});
  final Document doc;

  @override
  _NomsDataViewState createState() => _NomsDataViewState();
}

class _NomsDataViewState extends State<NomsDataView> {
  final TextEditingController _scanController = TextEditingController();
  final FocusNode _scanFocusNode = FocusNode();
  Scanwedge? _scanwedgePlugin;
  String? _deviceInfo;
  String value = '';
  final ScrollController _scrollController = ScrollController();

  get trimmedValue => null;
  @override
  void initState() {
    super.initState();
    // Задаємо фокус полю введення при ініціалізації
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanFocusNode.requestFocus();
    });
    Scanwedge.initialize().then((scanwedge) {
      _scanwedgePlugin = scanwedge;
      setState(() {});
      scanwedge.getDeviceInfo().then((devInfo) => setState(() {
            _deviceInfo = devInfo;
          }));
    });
  }

  @override
  void dispose() {
    // Очищаємо ресурси
    _scanController.dispose();
    _scanFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var nomsCubit = context.read<NomsPageCubit>();
    var epicenterCubit = context.read<EpicenterCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.doc.number,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          onPressed: () {
            nomsCubit.getNoms(widget.doc.guid);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          AppBarButton(
            onPressed: () {
              showPlaceCountDialog(
                  context, nomsCubit, widget.doc.guid, epicenterCubit);
              epicenterCubit.fetchDocuments();
            },
            title: 'Завершити',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          nomsCubit.getNoms(widget.doc.guid);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: _scanController,
                focusNode: _scanFocusNode, // Фокусне поле
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Зіскануйте штрихкод для пошуку..',
                ),
                onSubmitted: (value) async {
                  // nomsCubit.docScan(widget.doc.guid, value, count);
                  _scanController.clear();
                  _scanFocusNode.requestFocus();

                  // Find the item index using nomsCubit
                  final nom = nomsCubit.getIndexByBarcode(value);
                  if (nom != null) {
                    nomInputDialogue(
                        context,
                        Theme.of(context),
                        widget.doc.guid,
                        context.read<NomsPageCubit>(),
                        nom,
                        value);
                    // showNomInput(context, value, widget.doc.guid, nom);
                  } else {
                    soundInterface.play(Event.error);
                    Alerts(msg: 'Товару не знайдено', context: context)
                        .showError();
                  }

                  // if (itemIndex != null) {
                  //   // Set the jump index if necessary (for other logic in your app)
                  //   nomsCubit.setJumpIndex(itemIndex);

                  //   // Scroll to the found item
                  //   // Assuming each item has a fixed height of 60 pixels
                  //   double itemHeight = 60.0;
                  //   double scrollPosition = itemIndex * itemHeight;

                  //   // Animate to the calculated position
                  //   // _scrollController.animateTo(
                  //   //   scrollPosition,
                  //   //   duration: const Duration(milliseconds: 300),
                  //   //   curve: Curves.easeInOut,
                  //   // );
                  // }
                },
              ),
              const SizedBox(height: 8),
              const TableHead(),
              BlocConsumer<NomsPageCubit, EpicenterDataState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    // FlutterBeep.beep(false);
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    nomsCubit.getNoms(widget.doc.guid);
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    return Expanded(
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () {
                          soundInterface.play(Event.error);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                  return CustomTable(
                    noms: state.noms,
                    docId: widget.doc.number,
                    guid: widget.doc.guid,
                    indexJump: state.jumpIndex,
                    onScrollEnd: _scanFocusNode.requestFocus,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
            lable: 'Оновити',
            onPressed: () {
              print('U pressed');
              nomsCubit.getNoms(widget.doc.guid);
              _scanFocusNode.requestFocus();
            },
          ),
        ],
      ),
    );
  }

  void showPlaceCountDialog(BuildContext context, NomsPageCubit cubit,
      String docGuid, EpicenterCubit epicenterCubit) {
    TextEditingController placeCountController = TextEditingController();
    bool isPrintButtonVisible = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white, // Колір фону діалогу
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Закруглені кути
              ),
              title: const Text(
                'Введіть кількість місць',
                style:
                    TextStyle(fontWeight: FontWeight.bold), // Жирний заголовок
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: placeCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Введіть число',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Закруглені кути
                        borderSide:
                            const BorderSide(color: Colors.grey), // Колір рамки
                      ),
                      contentPadding:
                          const EdgeInsets.all(10.0), // Внутрішній відступ
                    ),
                  ),
                  // if (isPrintButtonVisible)
                  //   ElevatedButton(
                  //     onPressed: () async {
                  //       int count = int.parse(placeCountController.text);
                  //       LabelInfo? info = await cubit.getLabelInfo(docGuid);
                  //       if (info != null) {
                  //         for (var i = 0; i < count; i++) {
                  //           printLabel(
                  //             address: info.address,
                  //             barcode: info.barcode,
                  //             currentIndex: i + 1,
                  //             customer: info.customer,
                  //             customer_group: info.customerGroup,
                  //             date_number: info.dateNumber,
                  //             order_date_number: info.orderDateNumber,
                  //             region_short: info.regionShort,
                  //             totalAmount: count,
                  //             comment: info.errorMassage,
                  //             pickup_type: info.errorMassage,
                  //           );
                  //         }
                  //         Navigator.of(context).pop(); // Закриваємо діалог
                  //         Navigator.of(context).pop(true); // Закриваємо екран
                  //       } else {
                  //         print('Не вдалося отримати інформацію про етикетку');
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       foregroundColor: Colors.blue, // Колір кнопки
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.circular(10.0), // Закруглені кути
                  //       ),
                  //     ),
                  //     child: const Text('Друк'),
                  //   )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закриваємо діалог без дії
                  },
                  child: const Text('Скасувати'),
                ),
                TextButton(
                  onPressed: () async {
                    final int placeCount =
                        int.tryParse(placeCountController.text) ?? 0;

                    if (placeCount > 0) {
                      try {
                        LabelInfo? info = await cubit.getLabelInfo(docGuid);

                        if (info != null) {
                          int count = int.parse(placeCountController.text);
                          List<bool> res = [];
                          for (var i = 0; i < count; i++) {
                            res.add(await printLabel(
                              address: info.address,
                              barcode: info.barcode,
                              currentIndex: i + 1,
                              customer: info.customer,
                              customer_group: info.customerGroup,
                              date_number: info.dateNumber,
                              order_date_number: info.orderDateNumber,
                              region_short: info.regionShort,
                              totalAmount: count,
                              comment: info.errorMassage,
                              pickup_type: info.errorMassage,
                            ));
                          }
                          if (!res.contains(false)) {
                            await cubit.finishDoc(context, docGuid, placeCount);
                            await epicenterCubit.fetchDocuments();
                            Navigator.of(context).pop(true); // Закриваємо екран
                          } else {
                            soundInterface.play(Event.error);
                            showToast('Не можливо роздрукувати');
                          }
                        } else {
                          soundInterface.play(Event.error);
                          print('Не вдалося отримати інформацію про етикетку');
                          throw Exception(
                              'Не вдалося отримати інформацію про етикетку'); // Генеруємо помилку
                        }

                        setState(() {
                          isPrintButtonVisible = true;
                        });
                      } catch (e) {
                        // Обробка виключення
                        soundInterface.play(Event.error);
                        showToast('Сталася помилка: ${e.toString()}');
                      } finally {
                        // Завжди закриваємо діалог
                        Navigator.of(context).pop(); // Закриваємо діалог
                      }
                    } else {
                      soundInterface.play(Event.error);
                      showToast('Введіть дійсне число, більше 0!');
                      Navigator.of(context).pop(); // Закриваємо діалог
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue, // Колір тексту
                  ),
                  child: const Text('Підтвердити та роздрукувати'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TableInfo extends StatelessWidget {
  const TableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NomsPageCubit, EpicenterDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        return Card(
            color: const Color.fromARGB(255, 219, 219, 219),
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 8),
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/table_icon.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    state.noms.isNotEmpty ? state.noms.first.tovar : '',
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            ));
      },
    );
  }
}
