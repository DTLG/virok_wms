import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/ttn_temp_recreated/models/ttn_params.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../widget/status_label.dart' as StatusLabel;

import '../cubit/ttn_print_cubit.dart';

String _value = '';
final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                              Navigator.popAndPushNamed(
                                  context, AppRoutes.ttnPage);
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
                          var ttnData =
                              context.read<TtnPrintCubit>().state.ttnData;
                          var ttnParams =
                              context.read<TtnPrintCubit>().state.ttnParams;
                          return ttnData.isNotEmpty()
                              ? Column(
                                  children: [
                                    StatusLabel.showInfo(ttnData),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 300,
                                      height: 250,
                                      child: ListView.builder(
                                        itemCount: ttnParams.length,
                                        itemBuilder: (context, index) {
                                          final param = ttnParams[index];
                                          return Dismissible(
                                            key: UniqueKey(),
                                            onDismissed: (direction) {
                                              context
                                                  .read<TtnPrintCubit>()
                                                  .removeTtnParam(param);
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    64, 158, 158, 158),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ParamRow(
                                                    param: param,
                                                    label: "Номер місця",
                                                    measure: "Номер місця",
                                                    isEnabled: false,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ParamRow(
                                                    param: param,
                                                    label: "Висота",
                                                    measure: "Висота",
                                                    isEnabled: true,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ParamRow(
                                                    param: param,
                                                    label: "Ширина",
                                                    measure: "Ширина",
                                                    isEnabled: true,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ParamRow(
                                                    param: param,
                                                    label: "Довжина",
                                                    measure: "Довжина",
                                                    isEnabled: true,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ParamRow(
                                                    param: param,
                                                    label: "Вага",
                                                    measure: "Вага",
                                                    isEnabled: true,
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<TtnPrintCubit>()
                                                  .saveTtnParams(
                                                      barcode, ttnParams);
                                            }
                                          },
                                          child: const Text('Зберегти зміни'),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green[600],
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              final newParam = TtnParams.empty;
                                              context
                                                  .read<TtnPrintCubit>()
                                                  .addTtnParam(newParam,
                                                      ttnParams.length);
                                              ttnParams.add(newParam);
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        )
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
            )),
      ),
    );
  }
}

class ParamRow extends StatelessWidget {
  final String label;
  final String measure;
  final bool isEnabled;
  TtnParams param;

  ParamRow({
    Key? key,
    required this.label,
    required this.param,
    required this.isEnabled,
    required this.measure,
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String hintText = param.getHint(label);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Flexible(
          child: TextFormField(
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            validator: (value) {
              if (hintText != "0.0" || (value != null && value.isNotEmpty)) {
                param = changeParam(param, controller.text, measure);
                return null;
              }
              return 'Поле має бути заповненим';
            },
            keyboardType: TextInputType.number,
            // onEditingComplete: () {
            //   param = changeParam(param, controller.text, measure);
            // },
          ),
        ),
      ],
    );
  }
}

TtnParams changeParam(TtnParams param, String value, String measure) {
  switch (measure) {
    case 'Номер місця':
      param.placeNumber = int.tryParse(value) ?? param.placeNumber;
      break;
    case 'Висота':
      param.height = double.tryParse(value) ?? param.height;
      break;
    case 'Ширина':
      param.width = double.tryParse(value) ?? param.width;
      break;
    case 'Довжина':
      param.length = double.tryParse(value) ?? param.length;
      break;
    case 'Вага':
      param.weight = double.tryParse(value) ?? param.weight;
      break;
    default:
      print('Unknown measure: $measure');
  }
  return param;
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
  final bool _switchValue = true;

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
          context.read<TtnPrintCubit>().getTtnData(value);
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
