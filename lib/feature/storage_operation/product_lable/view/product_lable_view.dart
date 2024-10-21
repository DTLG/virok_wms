import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/storage_operation/product_lable/cubit/product_lables_cubit.dart';
import 'package:virok_wms/ui/ui.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

final SoundInterface _soundInterface = SoundInterface();

class ProductLablesPage extends StatelessWidget {
  const ProductLablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductLablesCubit(),
      child: const ProductLablesView(),
    );
  }
}

class ProductLablesView extends StatelessWidget {
  const ProductLablesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Етикетки продукту"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ProductLablesCubit, ProductLablesState>(
          builder: (context, state) {
            if (state.status.isInitial) {
              context.read<ProductLablesCubit>().getLables();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status.isFailure) {
              _soundInterface.play(Event.error);
              return Center(
                child: WentWrong(
                  errorDescription: state.errorMassage,
                  onPressed: () =>
                      context.read<ProductLablesCubit>().getLables(),
                ),
              );
            }
            final lables = state.filteredLables.labels;
            return Column(
              children: [
                const SearchField(),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: lables.length,
                    itemBuilder: (context, index) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          showPrintPreview(context, lables[index].text);
                        },
                        title: Text(lables[index].name),
                        trailing: const Icon(Icons.print)),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<ProductLablesCubit>().search(value),
      decoration: const InputDecoration(hintText: 'Пошук по назві'),
    );
  }
}

showPrintPreview(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<ProductLablesCubit>(),
      child: PrintAlert(text: text),
    ),
  );
}

class PrintAlert extends StatefulWidget {
  final String text;

  const PrintAlert({super.key, required this.text});
  @override
  State<PrintAlert> createState() => _PrintAlertState();
}

class _PrintAlertState extends State<PrintAlert> {
  final controller = TextEditingController();
  bool countButton = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        countButton ? const Spacer() : const SizedBox(),
        AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              countButton
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 60,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                              controller: controller,
                              autofocus: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[1-90]"))
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Введіть кількість'),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  controller.clear();
                  countButton = countButton == false ? true : false;
                  setState(() {});
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                child: const SizedBox(
                  height: 50,
                  width: 95,
                  child: Center(
                    child: Text(
                      'Кількість',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  int count = controller.text.isEmpty
                      ? 1
                      : int.parse(
                          controller.text.isEmpty ? '1' : controller.text);

                  if (count > 100) {
                    Alerts(
                            msg: 'Максимальна кількість друку 100',
                            context: context)
                        .showError();
                    return;
                  }
                  context
                      .read<ProductLablesCubit>()
                      .printLable(widget.text, count);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  height: 50,
                  width: 95,
                  child: Center(
                    child: Text(
                      'Друк',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
          ],
        ),
        countButton ? Keyboard(controller: controller) : const SizedBox()
      ],
    );
  }
}
