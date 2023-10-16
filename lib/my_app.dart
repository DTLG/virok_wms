import 'package:flutter/material.dart';
import 'package:virok_wms/feature/barcode_generation/ui/barcode_generation.dart';
import 'package:virok_wms/feature/placement_writing_off/check_cell/ui/check_cell_page.dart';
import 'package:virok_wms/feature/placement_writing_off/writing_off/ui/writing_off_page.dart';
import 'package:virok_wms/feature/selection1/order_head/ui/selection_order_invoice_head.dart';
import 'package:virok_wms/feature/settings/settings_page.dart';
import 'package:virok_wms/feature/shipment_orders/shipment_orders.dart';
import 'package:virok_wms/home_page/home_page.dart';
import 'package:virok_wms/login/login_page.dart';

import 'feature/barcode_lable_print/ui/barcode_lable_print_page.dart';
import 'feature/placement_writing_off/placement_goods/ui/placement_goods_page.dart';
import 'feature/selection1/order_data/ui/selection_order_data.dart';
import 'feature/shipment_orders/shipment_order_data.dart';
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLogin ? '/homePage' : '/',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginPage(),
        '/homePage': (context) => const HomePage(),
        '/placementGoodsPage': (context) => const PlacementGoodsPage(),
        '/writing_off': (context) => const WritingOffPage(),
        '/selection_head': (context) => const SelectionOrderHeadPage(),
        '/selection_head/selection_data': (context) =>
            const SelectionOrderDataPage(),
        '/barcode_generation': (context) => const BarcodeGenerationPage(),
        '/check_cell': (context) => const CheckCellPage(),

        '/barcode_Lable_print': (context) => const BarcodeLeblePrintPage(),
        '/shipment_orders': (context) => const ShipmentOrdersPage(),
        '/shipment_orders/data': (context) => const ShipmentOrderDataPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
