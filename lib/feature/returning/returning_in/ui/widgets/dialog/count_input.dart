import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/ui.dart';


import '../../../cubits/returning_in_data_cubit.dart';
import '../../../returning_in_repository/models/noms_model.dart';

void showManualCountIncrementAlert(
  BuildContext context,
  String nomBacode,
  String invoice,
  ReturningInNom nom,
) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ReturningInDataCubit>(),
          child: ManualCountIncrementAlert(
            nom: nom,
            invoice: invoice,
            nomBarcode: nomBacode,
          ),
        );
      });
}

class ManualCountIncrementAlert extends StatefulWidget {
  const ManualCountIncrementAlert(
      {super.key,
      required this.nom,
      required this.invoice,
      required this.nomBarcode});

  final ReturningInNom nom;
  final String invoice;
  final String nomBarcode;

  @override
  State<ManualCountIncrementAlert> createState() =>
      _ManualCountIncrementAlertState();
}

class _ManualCountIncrementAlertState extends State<ManualCountIncrementAlert> {
  final controller = TextEditingController();

  @override
  void initState() {
    context
        .read<ReturningInDataCubit>()
        .getNom(widget.invoice, widget.nomBarcode);
            super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        await context.read<ReturningInDataCubit>().clear();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ReturningInDataCubit, ReturningInDataState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                iconPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                actionsPadding: const EdgeInsets.only(bottom: 5),
                icon: DialogHead(
                  title: widget.nom.article,
                  onPressed: () {
                    context.read<ReturningInDataCubit>().clear();
                    Navigator.pop(context);
                  },
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.nom == ReturningInNom.empty
                          ? widget.nom.name
                          : state.nom.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.dialogYellow,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Кількість в замовленні:',
                                style: theme.textTheme.titleSmall!
                                    .copyWith(color: Colors.black)),
                            Text(
                                state.nom == ReturningInNom.empty
                                    ? widget.nom.qty.toStringAsFixed(0)
                                    : state.nom.qty.toStringAsFixed(0),
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.dialogGreen,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Відскановано:',
                                style: theme.textTheme.titleSmall!
                                    .copyWith(color: Colors.black)),
                            Text(
                                state.nom == ReturningInNom.empty
                                    ? widget.nom.count.toStringAsFixed(0)
                                    : state.nom.count.toStringAsFixed(0),
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10
                      ,
                    ),
                    Column(
                          children: [
                            SizedBox(
                              width: 70,
                                                            child: TextField(
                                controller: controller,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Введіть кількість',
                              style: theme.textTheme.titleMedium,
                        ),
                      ],
                    )
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        String barcode = '';
                        if (controller.text.isNotEmpty &&
                            controller.text != "0") {
                          for (var element in widget.nom.barcode) {
                            if (element.ratio == 1) {
                              barcode = element.barcode;
                              break;
                            }
                          }

                          context.read<ReturningInDataCubit>().addNom(barcode,
                              widget.invoice, double.parse(controller.text));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Додати',
                      ))
                ],
              );
            },
          ),
          BottomSheet(
            onClosing: () {},
            builder: (context) => Keyboard(
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}



// void showNomInput(BuildContext context, String cellBarcode, String docId,
//     String nomBarcode, ReturningInNom nom) {
//   showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => BlocProvider.value(
//             value: context.read<ReturningInDataCubit>(),
//             child: NomInputDialog(
//                 docId: docId,
//                 nomBarcode: nomBarcode,
//                 cellBarcode: cellBarcode,
//                 nom: nom),
//           ));
// }

// class NomInputDialog extends StatefulWidget {
//   const NomInputDialog(
//       {super.key,
//       required this.cellBarcode,
//       required this.docId,
//       required this.nomBarcode,
//       required this.nom});

//   final String nomBarcode;
//   final String cellBarcode;
//   final ReturningInNom nom;
//   final String docId;

//   @override
//   State<NomInputDialog> createState() => _NomInputDialogState();
// }

// class _NomInputDialogState extends State<NomInputDialog> {
//   final nomController = TextEditingController();
//   final nomFocusNode = FocusNode();

//   @override
//   void initState() {
//     context
//         .read<ReturningInDataCubit>()
//         .getNom(widget.docId, widget.nomBarcode);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return WillPopScope(
//       onWillPop: () async {
//         await context.read<ReturningInDataCubit>().clear();
//         return true;
//       },
//       child: AlertDialog(
//         iconPadding: EdgeInsets.zero,
//         contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//         icon: DialogHead(
//           article: widget.nom.article,
//           onPressed: () {
//             context.read<ReturningInDataCubit>().clear();
//             Navigator.pop(context);
//           },
//         ),
//         content:
//             BlocBuilder<ReturningInDataCubit, ReturningInDataState>(
//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text(
//                   state.nom == ReturningInNom.empty ? widget.nom.name : state.nom.name,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.titleSmall,
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 TextField(
//                   controller: nomController,
//                   focusNode: nomFocusNode,
//                   autofocus: true,
//                   onSubmitted: (value) {
//                     context
//                         .read<ReturningInDataCubit>()
//                         .scan(value);
//                     nomController.clear();
//                     nomFocusNode.requestFocus();
//                     setState(() {});
//                   },
//                   decoration:
//                       const InputDecoration(hintText: 'Відскануйте товар'),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(7),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColors.dialogGreen),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Кількість в замовленні:',
//                         style: theme.textTheme.titleSmall!.copyWith(color:Colors.black),
//                       ),
//                       Text(
//                         state.nom == ReturningInNom.empty
//                             ? widget.nom.qty.toStringAsFixed(0)
//                             : state.nom.qty.toStringAsFixed(0),
//                         style: const TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.w600,color:Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//                 BlocBuilder<ReturningInDataCubit, ReturningInDataState>(
//                   builder: (context, state) {
//                     double dialogSize = MediaQuery.of(context).size.height;
//                     final count = state.nom.count;
//                     return Text(
//                       state.count == 0
//                           ? count.toStringAsFixed(0)
//                           : state.count.toStringAsFixed(0),
//                       style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
//                     );
//                   },
//                 )
//               ]),
//             );
//           },
//         ),
//         actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
//         actions: [
//           BlocBuilder<ReturningInDataCubit, ReturningInDataState>(
//             builder: (context, state) {
//               return Column(
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
       
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStatePropertyAll(context
//                                           .read<ReturningInDataCubit>()
//                                           .state
//                                           .count >
//                                       0
//                                   ? Colors.green
//                                   : Colors.grey)),
//                           onPressed: () {
//                             // final state =
//                             //     context.read<ReturningInDataCubit>().state;
//                             // if (state.nomBarcode.isNotEmpty) {
//                             //   showCountAlert(context, state.nom);
//                             // }
//                           },
//                           child: const Text('Ввести в ручну')),
//                       ElevatedButton(
//                           onPressed: () {
//                             // final state =
//                             //     context.read<ReturningInDataCubit>().state;
//                             // if (state.nomBarcode.isNotEmpty) {
//                             //   context.read<ReturningInDataCubit>().send(
//                             //       state.nomBarcode,
//                             //       state.nom.docNumber,
//                             //       state.nom.count);
//                             //   Navigator.pop(context);
//                             //}
//                           },
//                           child: const Text('Додати'))
//                     ],
//                   )
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }