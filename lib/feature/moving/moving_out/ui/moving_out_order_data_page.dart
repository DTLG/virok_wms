import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../../../home_page/cubit/home_page_cubit.dart';
import '../cubit/moving_out_order_data_cubit.dart';
import '../cubit/moving_out_order_head_cubit.dart';
import 'ui.dart';

class MovingOutDataPage extends StatelessWidget {
  const MovingOutDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingOutOrderDataCubit(),
      child: const MovingOutOrderDataView(),
    );
  }
}

class MovingOutOrderDataView extends StatelessWidget {
  const MovingOutOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    // Якщо тип тзд мезонін тоді використовуємо docId і bascket, якщо ні то не використовуємо
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String docId = argument['docId'] ?? '';
    final MovingOutOrdersHeadCubit movingOrderHeadCubit = argument['cubit'];
    //----

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
                movingOrderHeadCubit.getOrders();
                                  Navigator.pop(context);

            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          AppBarButton(
            cubit: movingOrderHeadCubit,
            docId: docId,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovingOutOrderDataCubit>().getNoms(docId);
        },
        child: Stack(
          children: [
                        WatermarkWidget(itsMezonine: itsMezonine),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TableInfo(),
                      itsMezonine ? const BascketInfo() : const SizedBox()
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
                        context.read<MovingOutOrderDataCubit>().getNoms(docId);
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
            
          ],
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

class WatermarkWidget extends StatelessWidget {
  const WatermarkWidget({super.key, required this.itsMezonine});

  final bool itsMezonine;

  @override
  Widget build(BuildContext context) {
    return  Center(
              child: Transform.rotate(
                angle: -math.pi / 4,
                child:  Text(
                  itsMezonine?
                  'Мезонін':'Палетний склад',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 70,
                      
                      color: Color.fromARGB(6, 17, 29, 57),
                      fontWeight: FontWeight.w800),
                ),
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
                      state.noms.noms.isNotEmpty? state.noms.noms.first.table:'',
                      style: theme.textTheme.titleLarge,
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
  const BascketInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        if (state.status.isSuccess) {
          final baskets = state.noms.noms.isEmpty?[Bascket.empty]:state.noms.noms.first.baskets;

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
                    'assets/icons/basket_icon.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    baskets.isNotEmpty ? baskets.first.name : '',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
