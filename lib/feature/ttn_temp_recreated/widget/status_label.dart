import 'package:flutter/material.dart';
import 'package:virok_wms/feature/ttn_temp_recreated/models/ttn_data.dart';

Widget showInfo(TtnData data) {
  const TextStyle boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Номер TTN: ${data.ttnNumber}',
        style: boldTextStyle,
      ),
      Text(
        'Статус: ${data.errorMessage}',
        style: boldTextStyle,
      ),
    ],
  );
}
