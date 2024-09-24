import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/noms_page_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/epicenter_cubit.dart'; // Import EpicenterCubit
import 'package:virok_wms/feature/epicenter_page/model/document.dart';
import 'package:virok_wms/feature/epicenter_page/ui/widget/table.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/widgets/table_head.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/app_bar_button.dart';
import 'package:virok_wms/ui/widgets/general_button.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';
import 'package:flutter_beep/flutter_beep.dart';

class NomsPage extends StatelessWidget {
  const NomsPage({super.key, required this.doc});
  final Document doc;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NomsPageCubit()),
        BlocProvider(create: (context) => EpicenterCubit()),
      ],
      child: NomsDataView(
        doc: doc,
      ),
    );
  }
}

class NomsDataView extends StatefulWidget {
  const NomsDataView({super.key, required this.doc});
  final Document doc;

  @override
  _NomsDataViewState createState() => _NomsDataViewState();
}

class _NomsDataViewState extends State<NomsDataView> {
  final TextEditingController _scanController = TextEditingController();
  final FocusNode _scanFocusNode = FocusNode();
  String value = '';
  @override
  void initState() {
    super.initState();
    // Задаємо фокус полю введення при ініціалізації
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Очищаємо ресурси
    _scanController.dispose();
    _scanFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var nomsCubit = context.read<NomsPageCubit>();
    var epicenterCubit = context.read<EpicenterCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.doc.number,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          onPressed: () {
            nomsCubit.getNoms(widget.doc.guid);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          AppBarButton(
            onPressed: () {
              showPlaceCountDialog(
                  context, nomsCubit, widget.doc.guid, epicenterCubit);
              epicenterCubit.fetchDocuments();
            },
            title: 'Завершити',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          nomsCubit.getNoms(widget.doc.guid);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: _scanController,
                focusNode: _scanFocusNode, // Фокусне поле
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Зіскануйте штрихкод',
                ),
                onSubmitted: (value) {
                  nomsCubit.docScan(widget.doc.guid, value.trim(), 1);
                  _scanController.clear();
                  _scanFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 8),
              const TableHead(),
              BlocConsumer<NomsPageCubit, EpicenterDataState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    FlutterBeep.beep(false);
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    nomsCubit.getNoms(widget.doc.guid);
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    FlutterBeep.beep(false);
                    return Expanded(
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  }
                  return CustomTable(
                    noms: state.noms,
                    docId: widget.doc.number,
                    guid: widget.doc.guid,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
            lable: 'Оновити',
            onPressed: () {
              nomsCubit.getNoms(widget.doc.guid);
            },
          ),
        ],
      ),
    );
  }

  void showPlaceCountDialog(BuildContext context, NomsPageCubit cubit,
      String docGuid, EpicenterCubit epicenterCubit) {
    TextEditingController _placeCountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Введіть кількість місць'),
          content: TextField(
            controller: _placeCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Введіть число'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                // Validate the input and ensure the place count is > 0
                final int placeCount =
                    int.tryParse(_placeCountController.text) ?? 0;

                if (placeCount > 0) {
                  // Valid input, proceed with finishDoc and fetchDocuments
                  await cubit.finishDoc(docGuid, placeCount);
                  await epicenterCubit.fetchDocuments();

                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(true); // Close the screen
                } else {
                  showToast('Введіть дійсне число, більше 0!');
                }
              },
              child: const Text('Підтвердити'),
            ),
          ],
        );
      },
    );
  }
}

class TableInfo extends StatelessWidget {
  const TableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NomsPageCubit, EpicenterDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        return Card(
            color: const Color.fromARGB(255, 219, 219, 219),
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 8),
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/table_icon.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    state.noms.isNotEmpty ? state.noms.first.tovar : '',
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            ));
      },
    );
  }
}
