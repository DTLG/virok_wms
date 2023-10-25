import 'package:flutter/material.dart';
import 'package:virok_wms/feature/barcode_generation/ui/barcode_generation.dart';
import 'package:virok_wms/feature/check_basket/ui/check_basket_page.dart';
import 'package:virok_wms/feature/placement_writing_off/check_cell/ui/check_cell_page.dart';
import 'package:virok_wms/feature/placement_writing_off/writing_off/ui/writing_off_page.dart';
import 'package:virok_wms/feature/selection/ui/selection_order_head_page.dart';
import 'package:virok_wms/feature/settings/settings_page.dart';
import 'package:virok_wms/home_page/home_page.dart';
import 'package:virok_wms/login/login_page.dart';

import 'feature/barcode_lable_print/ui/barcode_lable_print_page.dart';
import 'feature/placement_writing_off/placement_goods/ui/placement_goods_page.dart';
import 'feature/selection/ui/selection_order_data_page.dart';
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
            '/selection_P': (context) => const SelectionOrderDataPage(),
            '/selection_M': (context) => const SelectioOrdersHeadPage(),
            '/barcode_generation': (context) => const BarcodeGenerationPage(),
            '/check_cell': (context) => const CheckCellPage(),
            '/barcode_Lable_print': (context) => const BarcodeLeblePrintPage(),
            '/settings': (context) => const SettingsPage(),
            '/check_basket': (context) => const ChackBasketPage(),
          },
        );
  }
}
