import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../widget/status_label.dart' as StatusLabel;

import '../cubit/ttn_print_cubit.dart';

String _query = byArcticle;
String _value = '';
const byArcticle = 'get_from_article';
const byBarcode = 'get_from_barcode';

class TtnTempRecreated extends StatelessWidget {
  const TtnTempRecreated({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TtnPrintCubit(),
      child: const TtnTempRecreatedView(),
    );
  }
}

class TtnTempRecreatedView extends StatelessWidget {
  const TtnTempRecreatedView({super.key});

  @override
  Widget build(BuildContext context) {
    String barcode = '';
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const SizedBox(
              width: 140,
              child: Text(
                'Друк накладної',
                textAlign: TextAlign.center,
                maxLines: 2,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArticleInput(
                onSubmitted: (value) {
                  barcode = value;
                },
              ),
              BlocBuilder<TtnPrintCubit, TtnPrintState>(
                builder: (context, state) {
                  if (state.status.isFailure) {
                    return SizedBox(
                      height: 350,
                      child: WentWrong(
                        errorMassage: state.errorMassage,
                        onPressed: () {
                          Navigator.popAndPushNamed(context, AppRoutes.ttnPage);
                        },
                      ),
                    );
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isSuccess) {
                    if (state.action.isFetchingInfo) {
                      var ttnData = context.read<TtnPrintCubit>().state.ttnData;
                      var ttnParams =
                          context.read<TtnPrintCubit>().state.ttnParams;
                      return ttnData.isNotEmpty()
                          ? Column(
                              children: [
                                StatusLabel.showInfo(ttnData),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount: ttnParams.length,
                                    itemBuilder: (context, index) {
                                      final param = ttnParams[index];
                                      return Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {
                                            context.read<TtnPrintCubit>().removeTtnParam(param);
                                            ttnParams.remove(param);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.all(8),
                                          color: Colors.grey[200],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Номер місця:',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: param
                                                            .placeNumber
                                                            .toString(),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        param.placeNumber =
                                                            int.tryParse(value) ??
                                                                param.placeNumber;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Висота:',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: param.height
                                                            .toString(),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        // Оновлення значення height
                                                        param.height =
                                                            double.tryParse(
                                                                    value) ??
                                                                param.height;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Ширина:',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: param.width
                                                            .toString(),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        // Оновлення значення width
                                                        param.width =
                                                            double.tryParse(
                                                                    value) ??
                                                                param.width;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Довжина:',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: param.length
                                                            .toString(),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        // Оновлення значення length
                                                        param.length =
                                                            double.tryParse(
                                                                    value) ??
                                                                param.length;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: Text(
                                                      'Вага:',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: param.weight
                                                            .toString(),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        // Оновлення значення weight
                                                        param.weight =
                                                            double.tryParse(
                                                                    value) ??
                                                                param.weight;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        
                                        context.read<TtnPrintCubit>().saveTtnParams(barcode, ttnParams);
                                      },
                                      child: const Text('Зберегти зміни'),
                                    ),
                                    SizedBox(width: 30,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green[600],
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.error_outline_outlined),
                                SizedBox(width: 5),
                                Text(
                                  'Нічого не знайдено',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                    }

                    if (state.action.isPrinting) {
                      return Text(state.errorMassage);
                    }
                  }
                  return const Center();
                },
              ),
              const PrintButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintButton extends StatelessWidget {
  const PrintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (context.read<TtnPrintCubit>().state.status !=
                TtnPrintStatus.failure) {
              var ttnData = context.read<TtnPrintCubit>().state.ttnData;
              context.read<TtnPrintCubit>().printBarcodeLabel(ttnData);
            }
          },
          child: const Text('Друк'),
        ),
      ),
    );
  }
}

class ArticleInput extends StatefulWidget {
  const ArticleInput({Key? key, required this.onSubmitted}) : super(key: key);

  final Function(String) onSubmitted;

  @override
  State<ArticleInput> createState() => _ArticleInputState();
}

class _ArticleInputState extends State<ArticleInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final state = context.select((TtnPrintCubit cubit) => cubit.state);
    state.status.isInitial ? controller.clear() : controller;
    state.status.isInitial ? focusNode.requestFocus() : focusNode;
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;
    if (_switchValue == false && cameraScaner) {
      focusNode.unfocus();
    }

    return Padding(
            padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        autofocus: true,
        onSubmitted: (value) {
          context.read<TtnPrintCubit>().getTtnData(byBarcode, value);
          widget.onSubmitted(value); 
          _value = value;
        },
        decoration: InputDecoration(
          hintText: 'Відскануйте штрихкод',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              cameraScaner
                  ? _switchValue
                      ? const SizedBox()
                      : CameraScanerButton(
                          scan: (value) {
                            widget.onSubmitted(value);
                            _value = value;
                          },
                        )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}