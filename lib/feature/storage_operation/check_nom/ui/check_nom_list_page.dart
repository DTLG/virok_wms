import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/storage_operation/check_nom/models/barcodes_noms.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../cubit/check_nom_list_cubit.dart';

String _query = byArcticle;
String _value = '';
const byArcticle = 'get_from_article';
const byBarcode = 'get_from_barcode';

class CheckNomListPage extends StatelessWidget {
  const CheckNomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckNomListCubit(),
      child: const CheckNomListView(),
    );
  }
}

class CheckNomListView extends StatelessWidget {
  const CheckNomListView({super.key});

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
                'Перевірка номенклатури',
                textAlign: TextAlign.center,
                maxLines: 2,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 91, 79, 179)),
                    maximumSize: MaterialStatePropertyAll(Size.fromWidth(90)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                child: Text('Очистити',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  context.read<CheckNomListCubit>().clear();
                },
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              const ArticleInput(),
              BlocBuilder<CheckNomListCubit, CheckNomListState>(
                builder: (context, state) {
                  if (state.status.isFailure) {
                    return SizedBox(
                      height: 350,
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, AppRoutes.checkNomListPage);
                        },
                      ),
                    );
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isSuccess) {
                    return state.noms.noms.isNotEmpty
                        ? NomsList(
                            noms: state.noms,
                          )
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
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          );
                  }
                  return const Center();
                },
              )
            ],
          ),
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
    final state = context.select((CheckNomListCubit cubit) => cubit.state);
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
          context.read<CheckNomListCubit>().getNoms(
              _switchValue == true ? byArcticle : byBarcode,
              value);
          _value = value;
        },
        decoration: InputDecoration(
            hintText: _switchValue ? 'Введіть артикул' : 'Відскануйте штрихкод',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                cameraScaner
                    ? _switchValue
                        ? const SizedBox()
                        : CameraScanerButton(
                            scan: (value) {
                              context
                                  .read<CheckNomListCubit>()
                                  .getNoms(byBarcode, value);
                              _value = value;
                            },
                          )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() => _switchValue = value);
                      _query = value ? byArcticle : byBarcode;
                    },
                  ),
                ),
              ],
            )),
      ),
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            return NomsItem(
              nom: noms.noms[index],
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
  const NomsItem({super.key, required this.nom});

  final BarcodesNom nom;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

        Navigator.pushNamed(context, AppRoutes.checkNomPage, arguments: {
          'nom': nom,
          "nomsListCubit": context.read<CheckNomListCubit>(),
          'searchValue': _value,
          'query': _query
        });
      },
      title: Text(
        nom.name,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
          width: 100,
          child: Text(
            nom.article,
            textAlign: TextAlign.end,
          )),
    );
  }
}
