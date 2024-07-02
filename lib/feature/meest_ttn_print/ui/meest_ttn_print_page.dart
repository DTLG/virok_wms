import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../cubit/ttn_print_cubit.dart';

final _formKey = GlobalKey<FormState>();

class MeestTtnPrint extends StatelessWidget {
  const MeestTtnPrint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TtnPrintCubit(),
      child: const MeestTtnPrintView(),
    );
  }
}

class MeestTtnPrintView extends StatelessWidget {
  const MeestTtnPrintView({super.key});

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
            child: Form(
              key: _formKey,
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
                              Navigator.popAndPushNamed(
                                  context, AppRoutes.meestTtnPage);
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
                          if (state.action.isFetchingInfo) {
                            final receiverInfo = context
                                .read<TtnPrintCubit>()
                                .state
                                .receiverInfo;

                            String formattedInfo = '''
Ім'я: ${receiverInfo['name']}
Номер телефону: ${receiverInfo['phone']}
Адреса: ${receiverInfo['address']}
''';

                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth:
                                      300, // Максимальна ширина контейнера
                                ),
                                child: Column(
                                  children: [
                                    const Text('Отримувач'),
                                    Text(
                                      formattedInfo,
                                      textAlign: TextAlign
                                          .left, // Вирівнювання тексту по лівому краю
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      }
                      if (state.status.isInitial) {
                        return const Text("Зіскануйте штрих-код");
                      }
                      if (state.status.isError) {
                        return const Text("гг");
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

class ArticleInput extends StatefulWidget {
  const ArticleInput({Key? key}) : super(key: key);

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
          context.read<TtnPrintCubit>().getParcelID(value);
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
                          scan: (value) {},
                        )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintButton extends StatelessWidget {
  const PrintButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final state = context.read<TtnPrintCubit>().state;

            if (state.status != TtnPrintStatus.failure) {
              context.read<TtnPrintCubit>().printSticker(state.printValue);
            } else {
              Fluttertoast.showToast(msg: 'Не вдалося знайти parcelId');
            }
          },
          child: const Text('Друк'),
        ),
      ),
    );
  }
}
