import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/noms_page_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/table_state_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

final SoundInterface _soundInterface = SoundInterface();

class CustomTable extends StatelessWidget {
  const CustomTable({
    Key? key,
    required this.noms,
    required this.docId,
    required this.guid,
    required this.indexJump,
    required this.onScrollEnd,
  }) : super(key: key);

  final Function onScrollEnd;
  final List<Nom> noms;
  final String docId;
  final String guid;
  final int indexJump;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NomsPageCubit()),
        BlocProvider(create: (context) => CustomTableCubit(noms)),
      ],
      child: CustomTableView(
        nomsCubit: context.read<NomsPageCubit>(),
        noms: noms,
        docId: docId,
        guid: guid,
        indexJump: indexJump,
        onScrollEnd: onScrollEnd,
      ),
    );
  }

  // @override
  // _CustomTableState createState() => _CustomTableState();
}

class CustomTableView extends StatefulWidget {
  const CustomTableView({
    super.key,
    required this.noms,
    required this.docId,
    required this.guid,
    required this.indexJump,
    required this.onScrollEnd,
    required this.nomsCubit,
  });

  final NomsPageCubit nomsCubit;
  final Function onScrollEnd;
  final List<Nom> noms;
  final String docId;
  final String guid;
  final int indexJump;

  @override
  State<CustomTableView> createState() => _CustomTableViewState();
}

class _CustomTableViewState extends State<CustomTableView> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.indexJump);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          index >= 0 &&
          index < widget.noms.length) {
        scrollController.animateTo(
          index * 45.0, // Висота рядка таблиці
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CustomTableCubit, CustomTableState>(
        builder: (context, state) {
          var cubit = context.read<CustomTableCubit>();

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                widget.onScrollEnd();
              } else if (notification is ScrollStartNotification) {
                cubit.updateScrollIndex(
                  (scrollController.offset / 45.0)
                      .round(), // Зберігаємо індекс прокрутки
                );
              }
              return true;
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.noms.length,
              itemBuilder: (context, index) {
                final nom = state.noms[index];
                return InkWell(
                  onTap: () => _handleNomTap(context, nom, widget.docId),
                  child: CustomTableRow(
                    index: index,
                    guid: widget.guid,
                    lastIndex: state.noms.length - 1,
                    nom: nom,
                    nomsCubit: widget.nomsCubit,
                    onLongPress: () {
                      if (nom.countNeed > 15) {
                        final cubit = context.read<NomsPageCubit>();
                        showCountInputDialog(context, nom, cubit, widget.guid);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNomTap(BuildContext context, Nom nom, String docId) {
    if (nom.countNeed < nom.countScanned) {
      final barcode = nom.barcodes.isEmpty ? '' : nom.barcodes.first.barcode;

      if (barcode.isEmpty) {
        Alerts(msg: 'Вибраному товару не присвоєний штрихкод', context: context)
            .showError();
        return;
      }
      nomInputDialogue(
          context, Theme.of(context), widget.guid, widget.nomsCubit, nom);

      // showNomInput(context, docId, barcode, Nom.empty);
      context.read<NomsPageCubit>().getNoms(docId);
    }
  }
}

Future<int?> showCountInputDialog(
    BuildContext context, Nom nom, NomsPageCubit cubit, String guid) {
  final TextEditingController countController = TextEditingController();
  int count = 0;

  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Закруглені кути
            ),
            title: Text(
              'Введіть кількість для ${nom.tovar}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12), // Круглі кути
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Вже відскановано:',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          nom.countScanned.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12), // Круглі кути
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Всього потрібно:',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          nom.countNeed.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Кількість',
                        border:
                            InputBorder.none, // Прибираємо стандартний border
                      ),
                      onChanged: (value) {
                        setState(() {
                          count = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (count > 0) {
                                count--;
                                countController.text = count.toString();
                              }
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.red),
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (count + nom.countScanned < nom.countNeed) {
                                count++;
                                countController.text = count.toString();
                              }
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрити діалог
                },
                child: const Text('Скасувати',
                    style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () async {
                  final int inputCount =
                      int.tryParse(countController.text) ?? 0;
                  if (inputCount > 0 &&
                      (inputCount + nom.countScanned <= nom.countNeed)) {
                    Navigator.of(context)
                        .pop(inputCount); // Повернути введену кількість
                  } else {
                    showToast('Невірно введена кількість');

                    _soundInterface.play(Event.error);
                  }
                },
                child: const Text('Підтвердити',
                    style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    },
  );
}

// class _CustomTableState extends State<CustomTable> {
//   final ScrollController scrollController = ScrollController();
//   bool _isScrolling = false;
//   List<Nom> _noms = [];

//   @override
//   void initState() {
//     super.initState();
//     _noms = widget.noms;
//     _scrollToIndex(widget.indexJump);
//   }

//   void updateNoms(List<Nom> newNoms) {
//     setState(() {
//       _noms = newNoms;
//     });
//   }

//   void _scrollToIndex(int index) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (index >= 0 && index < _noms.length) {
//         scrollController.animateTo(
//           index * 45.0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: BlocBuilder<CustomTableCubit, CustomTableState>(
//         builder: (context, state) {
//           return NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification notification) {
//               if (notification is ScrollEndNotification) {
//                 widget.onScrollEnd();
//               } else if (notification is ScrollStartNotification) {
//                 _isScrolling = true;
//               }
//               return true;
//             },
//             child: ListView.builder(
//               controller: scrollController,
//               itemCount: _noms.length,
//               itemBuilder: (context, index) {
//                 final nom = _noms[index];
//                 return InkWell(
//                   onTap: () => _handleNomTap(context, nom, widget.docId),
//                   child: CustomTableRow(
//                     index: index,
//                     lastIndex: _noms.length - 1,
//                     nom: nom,
//                     onLongPress: () {
//                       if (nom.countNeed > 15) {
//                         final cubit = context.read<NomsPageCubit>();
//                         _showCountInputDialog(context, nom, cubit);
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _handleNomTap(BuildContext context, Nom nom, String docId) {
//     if (nom.countNeed < nom.countScanned) {
//       final barcode = nom.barcodes.isEmpty ? '' : nom.barcodes.first.barcode;

//       if (barcode.isEmpty) {
//         Alerts(msg: 'Вибраному товару не присвоєний штрихкод', context: context)
//             .showError();
//         return;
//       }

//       showNomInput(context, nom.article, docId, barcode, Nom.empty);
//       context.read<NomsPageCubit>().getNoms(docId);
//     }
//   }

//   void _showCountInputDialog(
//       BuildContext context, Nom nom, NomsPageCubit cubit) {
//     final TextEditingController countController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Введіть кількість для ${nom.tovar}'),
//           content: TextField(
//             controller: countController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(hintText: 'Кількість'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Скасувати'),
//             ),
//             TextButton(
//               onPressed: () {
//                 final int count = int.tryParse(countController.text) ?? 0;
//                 if (count > 0 && (count + nom.countScanned <= nom.countNeed)) {
//                   cubit.docScan(widget.guid, nom.barcodes.first.barcode, count);
//                 } else {
//                   showToast('Невірно введена кількість');
//                 }

//                 Navigator.of(context).pop();
//               },
//               child: const Text('Підтвердити'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
class CustomTableRow extends StatelessWidget {
  const CustomTableRow({
    super.key,
    required this.index,
    required this.lastIndex,
    required this.nom,
    required this.onLongPress,
    required this.guid,
    required this.nomsCubit,
  });

  final Nom nom;
  final int index;
  final String guid;
  final NomsPageCubit nomsCubit;
  final int lastIndex;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isLastRow = index == lastIndex;

    return GestureDetector(
      onTap: () {
        // Show dialog when the row is tapped
        nomInputDialogue(context, theme, guid, nomsCubit, nom);
      },
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: isLastRow ? 8 : 0),
        height: 45,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: nom.countNeed == nom.countScanned
              ? const Color.fromARGB(255, 132, 255, 142)
              : const Color.fromARGB(248, 255, 255, 91),
          border: const Border.symmetric(
            vertical: BorderSide(width: 1),
            horizontal: BorderSide(width: 0.5),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(isLastRow ? 15 : 0),
            bottomRight: Radius.circular(isLastRow ? 15 : 0),
          ),
        ),
        child: Row(
          children: [
            RowElement(
              flex: 8,
              value: nom.tovar,
              textStyle: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
                fontSize: 9,
              ),
            ),
            RowElement(
              flex: 2,
              value: nom.article,
              textStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            RowElement(
              flex: 2,
              value: nom.countNeed.toString(),
              textStyle: theme.textTheme.labelMedium,
            ),
            RowElement(
              flex: 2,
              value: nom.countScanned.toString(),
              textStyle: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> nomInputDialogue(BuildContext context, ThemeData theme,
    String guid, NomsPageCubit cubit, Nom nom,
    [String? barcode]) {
  bool isEnterManualButtonVisible = false;
  int manualCount = 0;
  int counter = 0; // Initialize a counter
  int minNeedValue = 15; //! Змінити

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController manualInputController = TextEditingController();
      TextEditingController barcodeInputController = TextEditingController();
      FocusNode barcodeFocusNode =
          FocusNode(); // Define FocusNode for barcode input
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Stack(
              children: [
                Center(
                  child: Text(
                    nom.article,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(nom.tovar, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      autofocus: true,
                      controller: barcodeInputController,
                      focusNode: barcodeFocusNode, // Attach the FocusNode here
                      keyboardType: TextInputType.none,
                      onSubmitted: (value) async {
                        barcodeInputController.clear();

                        if (nom.barcodes
                            .map((barcode) => barcode.barcode)
                            .contains(value)) {
                          if (nom.countScanned + counter + 1 <= nom.countNeed) {
                            setState(() {
                              counter++;
                            });
                          } else {
                            _soundInterface.play(Event.error);

                            showToast('Кількість перевищує ${nom.countNeed}',
                                backgroundColor: Colors.red);
                          }
                          FocusScope.of(context).requestFocus(
                              barcodeFocusNode); // Request focus again after submission
                        } else {
                          _soundInterface.play(Event.error);

                          showToast('Не той штрихкод ${nom.countNeed}',
                              backgroundColor: Colors.red);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Відскануйте товар',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 69, 224, 74),
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Кількість в замовленні:'),
                          Text(nom.countNeed.toString()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${nom.countScanned + counter}', // Display countScanned + counter
                    style: const TextStyle(
                      fontSize: 66,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: nom.countNeed >= minNeedValue
                                ? const Color.fromARGB(255, 224, 162, 69)
                                : Colors
                                    .grey, // Change background color when disabled
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          onPressed: nom.countNeed >= minNeedValue
                              ? () async {
                                  var value = await showCountInputDialog(
                                      context, nom, cubit, guid);
                                  if (value != null) {
                                    setState(() {
                                      counter = value;
                                    });
                                  }
                                  // Show confirmation dialog before entering manual quantity
                                }
                              : null, // Disable the button if countNeed < 15
                          child: const Text('Ввести вручну'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 69, 224, 74),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Закруглені кути діалогу
                                  ),
                                  title: const Text(
                                    'Підтвердження',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    'Ви дійсно бажаєте ввести кількість $counter?',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight
                                          .bold, // Робимо число жирним
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment
                                      .center, // Центрування кнопок
                                  actions: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                            20), // Круглі контейнери
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Закрити діалог підтвердження
                                          cubit.docScan(
                                              guid,
                                              nom.barcodes.first.barcode,
                                              counter);
                                          Navigator.of(context)
                                              .pop(); // Закрити основний діалог
                                        },
                                        child: const Text(
                                          'Так',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.green, // Зелений текст
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8), // Відступ між кнопками
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                            20), // Круглі контейнери
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Закрити діалог підтвердження
                                        },
                                        child: const Text(
                                          'Ні',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red, // Червоний текст
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Navigator.of(context).pop();
                          },
                          child: const Text('Ок'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

// void showNomInput(
//     BuildContext context, String docId, String nomBarcode, Nom nom) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (_) => BlocProvider.value(
//       value: context.read<NomsPageCubit>(),
//       child: NomInputDialog(
//         docId: docId,
//         nomBarcode: nomBarcode,
//         nom: nom,
//       ),
//     ),
//   );
// }

// class NomInputDialog extends StatelessWidget {
//   const NomInputDialog({
//     Key? key,
//     required this.docId,
//     required this.nomBarcode,
//     required this.nom,
//   }) : super(key: key);

//   final String docId;
//   final String nomBarcode;
//   final Nom nom;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(nom.tovar),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text('Enter details for ${nom.tovar}'),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
