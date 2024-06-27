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
              const ArticleInput(),
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
                      return context
                              .read<TtnPrintCubit>()
                              .state
                              .ttnData
                              .isNotEmpty()
                          ? StatusLabel.showInfo(
                              context.read<TtnPrintCubit>().state.ttnData)
                          : const Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.error_outline_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Нічого не знайдено',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
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
  const ArticleInput({super.key});

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
                              context
                                  .read<TtnPrintCubit>()
                                  .getTtnData(byBarcode, value);
                              _value = value;
                            },
                          )
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }
}
