import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/barcode_generation/cubit/barcode_generation_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class BarcodeGenerationPage extends StatelessWidget {
  const BarcodeGenerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeGenerationCubit(),
      child: const BarcodeGenerationView(),
    );
  }
}

class BarcodeGenerationView extends StatelessWidget {
  const BarcodeGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Присвосвоєння Штрихкоду'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const ArticleInput(),
            BlocConsumer<BarcodeGenerationCubit, BarcodeGenerationState>(
              listener: (context, state) {
                if (state.status.isError) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isFailure) {
                  return SizedBox(
                    height: 350,
                    child: WentWrong(
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, '/barcode_generation');
                      },
                    ),
                  );
                }
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return NomsList(
                  noms: state.noms,
                );
              },
            )
          ],
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: (value) {
        context.read<BarcodeGenerationCubit>().getNom(value);
      },
      decoration: const InputDecoration(hintText: 'Введіть артикул'),
    );
  }
}

class NomsList extends StatelessWidget {
  const NomsList({super.key, required this.noms});

  final Noms noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                showNomInfoAlert(context, noms.noms[index]);
              },
              title: Text(
                noms.noms[index].name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(noms.noms[index].article),
                    Text(noms.noms[index].barcode.first.barcode.trim())
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
                height: 1,
              ),
          itemCount: noms.noms.length),
    );
  }
}

showNomInfoAlert(BuildContext context, Nom nom) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<BarcodeGenerationCubit>(),
        child: NewBarcodeInput(
          nom: nom,
        ),
      );
    },
  );
}

class NewBarcodeInput extends StatefulWidget {
  const NewBarcodeInput({super.key, required this.nom});

  final Nom nom;

  @override
  State<NewBarcodeInput> createState() => _NewBarcodeInputState();
}

class _NewBarcodeInputState extends State<NewBarcodeInput> {
  final controller = TextEditingController();
  final ratioController = TextEditingController();
  final focusNode = FocusNode();

  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_switchValue ? 'Штука' : 'Упаковка'),
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() => _switchValue = value);
          },
        )
      ]),
      iconPadding: const EdgeInsets.fromLTRB(20, 5, 5, 0),
      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (value) {
              focusNode.nextFocus();
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                hintText: 'Згенерувати штрихкод',
                suffixIcon: GenerationButoon(
                  controller: controller,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          _switchValue
              ? const SizedBox()
              : TextField(
                  autofocus: true,
                  controller: ratioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Кратність',
                  ),
                ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              if (widget.nom.barcode.first.barcode == controller.text) {
                Alerts(msg: "Штрихкод вже існує", context: context).showError();
              } else {
                if (_switchValue == true) {
                  context.read<BarcodeGenerationCubit>().sendBar('send_barcode',
                      '${widget.nom.article} ${controller.text}');
                                        Navigator.pop(context);

                } else {
                  if(ratioController.text.isNotEmpty) {
                    context.read<BarcodeGenerationCubit>().sendBar(
                      'send_pack_barcode',
                      '${widget.nom.article} ${controller.text} ${ratioController.text}');
                                        Navigator.pop(context);

                  }else{
                Alerts(msg: "Введіть кратність", context: context).showError();

                  }
                }
                
              }
            },
            child: const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Підвердити',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}

class GenerationButoon extends StatelessWidget {
  const GenerationButoon({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final DateTime now = DateTime.now();

          String genBar = now.millisecondsSinceEpoch
              .toString()
              .replaceFirst(RegExp(r'1'), '', 0);
          controller.text = genBar.checkDigitCalculation;
        },
        child: const Icon(Icons.add));
  }
}

extension on String {
  String get checkDigitCalculation {
    int oddSum = 0;
    int evenSum = 0;
    int totalSum = 0;
    String rev = toString().split('').reversed.join('');
    for (int i = 0; i < rev.length; i++) {
      int digit = int.parse(rev[i]);
      i % 2 == 0 ? oddSum += digit : evenSum += digit;
    }
    totalSum = oddSum * 3 + evenSum;
    int digit = int.parse(totalSum.toString().split('').last);

    return this + (digit == 0 ? 0 : 10 - digit).toString();
  }
}
