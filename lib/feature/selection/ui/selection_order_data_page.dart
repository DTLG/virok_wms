import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../cubit/selection_order_head_cubit.dart';
import 'ui.dart';

SoundInterface soundInterface = SoundInterface();

class SelectionOrderDataPage extends StatelessWidget {
  const SelectionOrderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionOrderDataCubit(),
      child: const SelectionOrderDataView(),
    );
  }
}

class SelectionOrderDataView extends StatelessWidget {
  const SelectionOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String docId = argument['docId'] ?? '';
    final SelectionOrdersHeadCubit selectionOrderHeadCubit = argument['cubit'];
    final String basket = argument['basket'];
    final bool itsMezonine = context.read<HomePageCubit>().state.itsMezonine;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          docId,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              selectionOrderHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          AppBarButton(
            onPressed: () {
              final int checkFullScan =
                  context.read<SelectionOrderDataCubit>().checkFullOrder();

              if (checkFullScan == 0) {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: context.read<SelectionOrderDataCubit>(),
                          child: CheckFullScanDialog(
                            cubit: selectionOrderHeadCubit,
                            docId: docId,
                          ),
                        ));
              } else {
                context
                    .read<SelectionOrderDataCubit>()
                    .closeOrder(docId, selectionOrderHeadCubit);
                selectionOrderHeadCubit.getOrders();

                Navigator.pop(context);
              }
            },
            title: 'Завершити',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SelectionOrderDataCubit>().getNoms(docId);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TableInfo(),
                  itsMezonine
                      ? NewBascketInfo(
                          docId: docId,
                        )
                      : const SizedBox()
                ],
              ),
              const TableHead(),
              BlocConsumer<SelectionOrderDataCubit, SelectionOrderDataState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<SelectionOrderDataCubit>().writeBasket(basket);
                    context.read<SelectionOrderDataCubit>().getNoms(docId);
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    () async {
                      soundInterface.play(Event.error);
                    };
                    return Expanded(
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  }
                  return CustomTable(
                    noms: state.noms.noms,
                    docId: docId,
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
                context.read<SelectionOrderDataCubit>().getNoms(docId);
              })
        ],
      ),
    );
  }
}

class TableInfo extends StatelessWidget {
  const TableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
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
                    state.noms.noms.isNotEmpty
                        ? state.noms.noms.first.table
                        : '',
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

class BascketInfo extends StatelessWidget {
  const BascketInfo({super.key, required this.docId});

  final String docId;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
        buildWhen: (previous, current) => !current.status.isLoading,
        builder: (context, state) {
          final baskets = state.noms.noms.isEmpty
              ? [Bascket.empty]
              : state.noms.noms.first.baskets;

          return SizedBox(
            width: 230,
            height: 45,
            child: ListView.separated(
              reverse: true,
              separatorBuilder: (context, index) => const SizedBox(
                width: 5,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<SelectionOrderDataCubit>(),
                      child: SetBuscetDialog(
                        docId: docId,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 219, 219, 219),
                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 8),
                  shape: OutlineInputBorder(
                      borderSide:
                          index == 0 ? const BorderSide() : BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/basket_icon.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          baskets[index].name,
                          style: theme.textTheme.titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: baskets.length,
            ),
          );
        });
  }
}

class SetBuscetDialog extends StatefulWidget {
  const SetBuscetDialog({super.key, required this.docId});

  final String docId;

  @override
  State<SetBuscetDialog> createState() => _SetBuscetDialogState();
}

class _SetBuscetDialogState extends State<SetBuscetDialog> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 50),
          const Text(
            'Присвоєння кошика',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
            hintText: "Відскануйте кошик",
            suffixIcon: cameraScaner
                ? CameraScanerButton(scan: (value) {
                    controller.text = value;
                  })
                : const SizedBox()),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.zero,
      actions: [
        GeneralButton(
            lable: 'Присвоїти',
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                context
                    .read<SelectionOrderDataCubit>()
                    .setBasketToOrder(controller.text, widget.docId);
              }
            })
      ],
    );
  }
}

class NewBascketInfo extends StatelessWidget {
  const NewBascketInfo({super.key, required this.docId});

  final String docId;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
        buildWhen: (previous, current) => !current.status.isLoading,
        builder: (context, state) {
          final baskets = state.noms.noms.isEmpty
              ? [Bascket.empty]
              : state.noms.noms.first.baskets;

          return Row(
            children: [
              if (baskets.length > 1)
                Column(
                  children: [
                    Text(
                      '✦',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  showListDasket(context, docId);
                },
                child: Card(
                  color: const Color.fromARGB(255, 219, 219, 219),
                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 8),
                  shape: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/basket_icon.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          baskets[0].name,
                          style: theme.textTheme.titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

showListDasket(BuildContext context, String docId) {
  final theme = Theme.of(context);
  showModal(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<SelectionOrderDataCubit>(),
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        icon: DialogHead(
            title: 'Корзини',
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            onPressed: () {
              Navigator.pop(context);
            }),
        content: BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
          builder: (context, state) {
            final baskets = state.noms.noms.isEmpty
                ? [Bascket.empty]
                : state.noms.noms.first.baskets;
            return SizedBox(
              height: baskets.length * 50,
              child: ListView.builder(
                  itemCount: baskets.length,
                  itemBuilder: (context, index) {
                    double size = index == 0 ? 25 : 20;
                    Color color = index == 0 ? Colors.black : Colors.grey;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          baskets[index].name.startsWith('К')
                              ? Image.asset('assets/icons/basket_icon.png',
                                  width: size, height: size, color: color)
                              : baskets[index].name.startsWith("В")
                                  ? Image.asset(
                                      'assets/icons/cart.png',
                                      width: size,
                                      height: size,
                                      color: color,
                                    )
                                  : const SizedBox(),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            baskets[index].name,
                            style: index == 0
                                ? theme.textTheme.titleLarge!
                                    .copyWith(fontSize: 24)
                                : theme.textTheme.titleLarge!
                                    .copyWith(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          },
        ),
        actions: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<SelectionOrderDataCubit>(),
                  child: SetBuscetDialog(
                    docId: docId,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          )
        ],
      ),
    ),
  );
}
