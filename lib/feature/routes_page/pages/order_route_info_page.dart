import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';

import '../cubit/order_route_info_cubit.dart';

final SoundInterface _soundInterface = SoundInterface();

class OrderRouteInfoPage extends StatelessWidget {
  final String orderId;

  OrderRouteInfoPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderRouteInfoCubit()..fetchOrderRouteInfo(orderId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Інформація про замовлення'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context, true); // Return true when the back arrow is pressed
            },
          ),
        ),
        body: BlocBuilder<OrderRouteInfoCubit, OrderRouteInfoState>(
          builder: (context, state) {
            if (state is OrderRouteInfoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderRouteInfoLoaded) {
              final info = state.orderRouteInfo;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Номер замовлення", info.orderNumber),
                    _buildInfoRow("Кількість місць у замовленні",
                        info.orderPlacesCount.toString()),
                    _buildInfoRow("Кількість просканованих",
                        info.scannedCount.toString()),
                    _buildInfoRow("Назва маршруту", info.orderRouteName),
                    _buildInfoRow("ID документа", info.docId),
                    _buildInfoRow("Статус документа", info.docStatus),
                  ],
                ),
              );
            } else if (state is OrderRouteInfoError) {
              _soundInterface.play(Event.error);
              return Center(
                child: WentWrong(
                  errorMassage: state.error ?? 'Невідома помилка',
                  buttonDescription: 'Спробувати ще раз',
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
