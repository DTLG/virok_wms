import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/barcode_lable_print/barcode_lable_print_repo/models/barcodes_noms.dart';
import 'package:virok_wms/feature/barcode_lable_print/cubit/barcode_lable_print_cubit.dart';

import '../../../ui/widgets/went_wrong.dart';

class BarcodeLeblePrintPage extends StatelessWidget {
  const BarcodeLeblePrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeLablePrintCubit(),
      child: const BarcodeLeblePrintView(),
    );
  }
}

class BarcodeLeblePrintView extends StatelessWidget {
  const BarcodeLeblePrintView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Друк етикетки'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            const ArticleInput(),
            BlocBuilder<BarcodeLablePrintCubit, BarcodeLablePrintState>(
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
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: (value) {
          context.read<BarcodeLablePrintCubit>().getNoms(
              _switchValue == true ? 'get_from_article' : 'get_from_barcode', value);
        },
        decoration: InputDecoration(
            hintText: _switchValue ? 'Введіть артикул' : 'Відскануйте штрихкод',
            suffixIcon: Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() => _switchValue = value);
              },
            )),
      ),
    );
  }
}

class NomsList extends StatelessWidget {
  const NomsList({super.key, required this.noms});

  final BarcodesNoms noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return NomsItem(
              noms: noms.noms[index],
            );
          },
          separatorBuilder: (context, index) => const Divider(
                height: 1,
              ),
          itemCount: noms.noms.length),
    );
  }
}

class NomsItem extends StatelessWidget {
  const NomsItem({super.key, required this.noms});

  final BarcodesNom noms;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      title: Text(
        noms.name,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
          width: 100,
          child: Text(
            noms.article,
            textAlign: TextAlign.end,
          )),
      children: [
        SizedBox(
          height: noms.barodes.length * 37,
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: InkWell(
                    onTap: () {
                      showPrintAlertAlert(
                          context,
                          noms,
                          noms.barodes[index].barcode,
                          noms.barodes[index].ratio);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            noms.barodes[index].barcode,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Text(
                            noms.barodes[index].ratio.toString(),
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                    endIndent: 18,
                    indent: 18,
                    height: 1,
                  ),
              itemCount: noms.barodes.length),
        )
      ],
    );
  }
}

showPrintAlertAlert(
    BuildContext context, BarcodesNom nom, String barcode, int ratio) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<BarcodeLablePrintCubit>(),
        child: PrintAlert(
          nom: nom,
          barcode: barcode,
          ratio: ratio,
        ),
      );
    },
  );
}

class PrintAlert extends StatelessWidget {
  const PrintAlert(
      {super.key,
      required this.nom,
      required this.barcode,
      required this.ratio});

  final BarcodesNom nom;
  final String barcode;
  final int ratio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nom.name,
            textAlign: TextAlign.center,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Артикул:'),
            trailing: Text(nom.article, style: theme.textTheme.titleLarge),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Штрихкод:'),
            trailing: Text(
              barcode,
              style: theme.textTheme.titleLarge,
            ),
          )
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              context
                  .read<BarcodeLablePrintCubit>()
                  .printLable(nom, barcode, ratio);
            },
            child: const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Друк',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}
