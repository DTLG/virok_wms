import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';

import '../../cubit/placement_goods_cubit.dart';

class CellInput extends StatefulWidget {
  const CellInput({
    super.key,
  });

  @override
  State<CellInput> createState() => _CellInputState();
}

class _CellInputState extends State<CellInput> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((PlacementGoodsCubit cubit) => cubit.state.status);
    final count =
        context.select((PlacementGoodsCubit cubit) => cubit.state.count);

    if (status == PlacementGoodsStatus.initial) {
      controller.clear();
      nomController.clear();
      countController.clear();
      focusNode.requestFocus();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              autofocus: true,
              focusNode: focusNode,
              controller: controller,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  final status = await context.read<PlacementGoodsCubit>().getCeel(value);
                  if (status == 0) {
                    controller.clear();
                    focusNode.requestFocus();
                  } else {}
                } else {
                  focusNode.requestFocus();
                }
              },
              decoration:  const InputDecoration(
                
                hintText: 'Відскануйте комірку',
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nomController,
                    focusNode: focusNode1,
                    textAlignVertical: TextAlignVertical.bottom,
                    onSubmitted: (value) {
                      context.read<PlacementGoodsCubit>().addNom(value);
                      nomController.clear();
                      focusNode1.requestFocus();
                    },
                    decoration: const InputDecoration(
                      
                        hintText: 'Відскануйте товар'),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ButtonStyle(

                        backgroundColor: MaterialStatePropertyAll(
                            count == 0 ? Colors.grey : Colors.green),),
                    onPressed: () {
                      if (count == 0) {
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<PlacementGoodsCubit>(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                AlertDialog(
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: TextField(
                                          autofocus: true,
                                          controller: countController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          final nomBarcode = context
                                              .read<PlacementGoodsCubit>()
                                              .state
                                              .nomBarcode;
                                          context
                                              .read<PlacementGoodsCubit>()
                                              .manualAddNom(nomBarcode,countController.text);
                                          Navigator.pop(context);
                                          countController.clear();
                                        },
                                        child: const Text('Продовжити'))
                                  ],
                                ),
                                Keyboard(controller: countController)
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: const SizedBox(
                        width: 70,
                        child: Text(
                          'Ввести кількість',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NomInput extends StatefulWidget {
  const NomInput({
    super.key,
  });

  @override
  State<NomInput> createState() => _NomInputState();
}

class _NomInputState extends State<NomInput> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var barcode = '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlignVertical: TextAlignVertical.bottom,
          onSubmitted: (value) {
            // context
            //     .read<PlacementGoodsCubit>()
            //     .add(widget.countController, widget.controller);

            focusNode.requestFocus();
            controller.text = barcode;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.clear();
                    focusNode.requestFocus();

                    barcode = '';
                  },
                  icon: const Icon(Icons.close)),
              hintText: 'Відскануйте товар'),
        ),
      ),
    );
  }
}

class CountInput extends StatefulWidget {
  const CountInput({
    super.key,
  });

  @override
  State<CountInput> createState() => _CountInputState();
}

class _CountInputState extends State<CountInput> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            'Введіть кількість',
            style: TextStyle(fontSize: 17),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            width: 90,
            height: 50,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.datetime,
              textAlignVertical: TextAlignVertical.bottom,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      ],
    );
  }
}
