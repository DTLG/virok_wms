import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/ui.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import '../cubit/order_cubit.dart';
import '../model/order.dart';
import '../ui/ui.dart'; // Ensure this is the correct import for your OrderCubit

final SoundInterface _soundInterface = SoundInterface();

class OrderPage extends StatelessWidget {
  final String routeGuid;
  const OrderPage({Key? key, required this.routeGuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (context) => OrderCubit(),
      child: OrderPageView(cellBarcode: routeGuid),
    );
  }
}

class OrderPageView extends StatelessWidget {
  final String cellBarcode;
  String orderBarcode = '';
  final TextEditingController scanController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  OrderPageView({Key? key, required this.cellBarcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Номер маршруту'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context, true); // Return true when the back arrow is pressed
          },
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial) {
            context.read<OrderCubit>().loadOrder(cellBarcode);
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderReview) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableHead(),
                  CustomTable(
                    orders: state.orders,
                    docId: cellBarcode,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 190,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Закруглені кути
                          ),
                        ),
                        onPressed: () {
                          context.read<OrderCubit>().backToLoaded();
                        },
                        child: const Text(
                          'Повернутись',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is OrderLoaded) {
            // Find the scanned order by barcode
            final scannedOrder = state.orders.firstWhere(
              (order) => order.orderBarcode == orderBarcode,
              orElse: () => OrderData.empty(), // handle when no match is found
            );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    focusNode: myFocusNode,
                    keyboardType: TextInputType.none,
                    controller: scanController,
                    autofocus: true,
                    onSubmitted: (value) async {
                      orderBarcode = value;
                      scanController.clear();
                      myFocusNode.requestFocus();
                      await context.read<OrderCubit>().routeScan(
                          state.routeData.routeGuid,
                          value,
                          state.routeData.docGuid);
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Номер маршруту:',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.routeData.docId,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Center(
                        child: FilledButton(
                          onPressed: () {
                            Alerts(
                              msg: 'Ви впевнені що хочете завершити?',
                              context: context,
                              onConfirm: () async {
                                String res = await context
                                    .read<OrderCubit>()
                                    .closeRouteDoc(state.routeData.docGuid);
                                if (res == "OK") {
                                  showToast("Операція успішна");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                            ).showDialogue();
                          },
                          child: const Text('Завершити'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Show details of the scanned order if found
                  if (scannedOrder != OrderData.empty()) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: scannedOrder.scannedCount ==
                                scannedOrder.orderPlacesCount
                            ? Colors.green.withOpacity(0.3)
                            : Colors.yellow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сканований ордер:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                scannedOrder.orderBarcode,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Номер:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                scannedOrder.orderNumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Потрібно:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                scannedOrder.orderPlacesCount.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Проскановано:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                scannedOrder.scannedCount.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  // Add "Переглянути все" button to view all orders
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 190,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Закруглені кути
                          ),
                        ),
                        onPressed: () {
                          context.read<OrderCubit>().reviewAllOrders();
                        },
                        child: const Text(
                          'Переглянути все',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is OrderError) {
            _soundInterface.play(Event.error);
            return Center(
              child: WentWrong(
                errorMassage: state.message,
                buttonDescription: state.message == 'No order found'
                    ? 'Створити новий документ'
                    : 'Спробувати ще раз',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            );
          } else {
            return const Center(child: Text('Unexpected state encountered.'));
          }
        },
      ),
    );
  }
}
