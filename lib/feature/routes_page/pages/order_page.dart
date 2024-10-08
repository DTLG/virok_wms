import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:virok_wms/ui/ui.dart';
import '../cubit/order_cubit.dart';
import '../ui/ui.dart'; // Ensure this is the correct import for your OrderCubit

class OrderPage extends StatelessWidget {
  final String routeGuid;
  const OrderPage({Key? key, required this.routeGuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (context) => OrderCubit(), // Correctly instantiate the cubit here
      child: OrderPageView(
        routeGuid: routeGuid,
      ),
    );
  }
}

class OrderPageView extends StatelessWidget {
  final String routeGuid;
  final TextEditingController scanController = TextEditingController();

  OrderPageView({Key? key, required this.routeGuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            // Set title based on state

            {
              if (state is OrderLoaded) {
                return Row(
                  children: [
                    Text(state.routeData.routeName),
                  ],
                );
              } else if (state is OrderError) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Loading...'),
                  ],
                ); // Placeholder until data is loaded
              } else {
                return Text('Loading...');
              }
            }
          },
        ),
        actions: [],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial) {
            context.read<OrderCubit>().loadOrder(routeGuid);
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading while initiating the state
          } else if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            // Display order data when loaded
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    keyboardType: TextInputType.none,
                    controller: scanController,
                    autofocus: true,
                    onSubmitted: (value) async {
                      final isSuccess = await context
                          .read<OrderCubit>()
                          .routeScan(routeGuid, value, state.routeData.docGuid);
                      scanController.clear();
                      if (isSuccess)
                        context.read<OrderCubit>().loadOrder(routeGuid);
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        'Document ID: ${state.routeData.docId}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TableHead(), // Assuming you have a custom widget for the table header
                  CustomTable(
                    orders: state.routeData
                        .data, // Fetching orders from routeData, as `data` is a list of OrderData
                    docId: routeGuid,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is OrderError) {
            return Center(
              child: Expanded(
                child: WentWrong(
                  errorMassage: state.message,
                  buttonDescription: state.message == 'No order found'
                      ? 'Створити новий документ'
                      : 'Спробувати ще раз',
                  onPressed: () {
                    if (state.message == 'No order found') {
                      context.read<OrderCubit>().startScan(routeGuid);
                    } else if (state.message ==
                        'Не знайдено замовлення з таким штрихкодом') {
                      context.read<OrderCubit>().loadOrder(routeGuid);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            );
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }
}
