import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/return/cubits/return_data_cubit.dart';
import 'package:virok_wms/feature/return/return_repository/models/noms_model.dart';
import 'package:virok_wms/ui/ui.dart';

void showManualCountIncrementAlert(
  BuildContext context,
  String nomBacode,
  String invoice,
  ReturnNom nom,
) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ReturnDataCubit>(),
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

  final ReturnNom nom;
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
        .read<ReturnDataCubit>()
        .getNom(widget.invoice, widget.nomBarcode, widget.nom.nomStatus);
    nomStatus = widget.nom.nomStatus;
    super.initState();
  }

  String nomStatus = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        await context.read<ReturnDataCubit>().clear();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ReturnDataCubit, ReturnDataState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                iconPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                actionsPadding: const EdgeInsets.only(bottom: 5),
                icon: DialogHead(
                  title: widget.nom.article,
                  onPressed: () {
                    context.read<ReturnDataCubit>().clear();
                    Navigator.pop(context);
                  },
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.nom == ReturnNom.empty
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
                                state.nom == ReturnNom.empty
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
                                state.nom == ReturnNom.empty
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
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 50,
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
                              'Кількість',
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Кондиція',
                                  child: Text('Кондиція'),
                                ),
                                const PopupMenuItem(
                                  value: 'Брак',
                                  child: Text('Брак'),
                                ),
                                const PopupMenuItem(
                                  value: 'Уцінка',
                                  child: Text('Уцінка'),
                                ),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  nomStatus = value;
                                });
                              },
                              offset: const Offset(1, -1),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0))),
                              child: Container(
                                height: 50,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 100, 100, 100)),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(nomStatus),
                                    const Icon(Icons.arrow_drop_down_rounded)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Статус',
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        String barcode = '';
                        if (controller.text.isEmpty ||
                            controller.text == "0" ||
                            nomStatus.isEmpty) return;
                        for (var element in widget.nom.barcode) {
                          if (element.ratio == 1) {
                            barcode = element.barcode;
                            break;
                          }
                        }

                        context.read<ReturnDataCubit>().send(
                            barcode,
                            widget.invoice,
                            int.parse(controller.text),
                            nomStatus);
                        Navigator.pop(context);
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
