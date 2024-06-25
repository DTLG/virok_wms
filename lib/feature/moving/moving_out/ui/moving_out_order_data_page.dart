import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/moving/moving_out/cubit/moving_out_order_data_cubit.dart';

import 'package:virok_wms/feature/moving/moving_out/cubit/moving_out_order_head_cubit.dart';
import 'package:virok_wms/feature/moving/moving_out/ui/widgets/app_bar_button.dart';
import 'package:virok_wms/feature/moving/moving_out/ui/widgets/table.dart';
import 'package:virok_wms/models/noms_model.dart';

import '../../../../ui/widgets/widgets.dart';
import '../../../returning/returning_out/ui/widgets/table_head.dart';



class MovingOutDataPage extends StatelessWidget {
  const MovingOutDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingOutOrderDataCubit(),
      child: const MovingGateOrderDataView(),
    );
  }
}

class MovingGateOrderDataView extends StatelessWidget {
  const MovingGateOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    // Якщо тип тзд мезонін тоді використовуємо docId і bascket, якщо ні то не використовуємо
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String docId = argument['docId'] ?? '';
    final MovingOutOrdersHeadCubit movingOutOrdersHeadCubit = argument['cubit'];
    final String basket = argument['basket'];
    final bool itsMezonine = context.read<HomePageCubit>().state.itsMezonine;
    //----


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          docId,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              movingOutOrdersHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          AppBarButtonO(
            cubit: movingOutOrdersHeadCubit,
            docId: docId,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovingOutOrderDataCubit>().getNoms(docId);
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
                      ? BascketInfo(
                          docId: docId,
                        )
                      : const SizedBox()
                ],
              ),
              const TableHead(),
              BlocConsumer<MovingOutOrderDataCubit,
                  MovingOutOrderDataState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context
                        .read<MovingOutOrderDataCubit>()
                        .writeBasket(basket);
                    context.read<MovingOutOrderDataCubit>().getNoms(docId);
                    return  const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
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
                context.read<MovingOutOrderDataCubit>().getNoms(docId);
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

    return BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        if (state.status.isSuccess) {
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
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.black),
                    )
                  ],
                ),
              ));
        }
        return const SizedBox();
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

    return BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        if (state.status.isSuccess) {
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
                      value: context.read<MovingOutOrderDataCubit>(),
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
                      borderSide: index == 0?const BorderSide(): BorderSide.none,
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
                          style: theme.textTheme.titleSmall?.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: baskets.length,
            ),
          );
        }
        return const SizedBox();
      },
    );
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
        decoration: const InputDecoration(hintText: "Відскануйте кошик"),
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
                    .read<MovingOutOrderDataCubit>()
                    .setBasketToOrder(controller.text, widget.docId);
              }
            })
      ],
    );
  }
}
