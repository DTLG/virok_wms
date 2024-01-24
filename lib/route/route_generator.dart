import 'package:flutter/material.dart';
import 'package:virok_wms/feature/admission/admission_placement/ui/admission/admission_placement_page.dart';
import 'package:virok_wms/feature/admission_placement/ui/placement_data_page.dart';
import 'package:virok_wms/feature/admission_placement/ui/placement_head_page.dart';
import 'package:virok_wms/feature/inventory/inventory_data/ui/inventory_data_page.dart';
import 'package:virok_wms/feature/inventory/inventory_head/ui/inventory_head_page.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/moving_out_order_data_page.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/moving_out_order_head_page.dart';

import 'package:virok_wms/feature/moving/moving_in/ui/moving_in_data_page.dart';
import 'package:virok_wms/feature/moving/moving_in/ui/moving_in_head_page.dart';

import 'package:virok_wms/feature/moving/moving_page.dart';
import 'package:virok_wms/feature/recharging/moving_in_cells/ui/moving_in_cells_page.dart';
import 'package:virok_wms/feature/recharging/recharging_menu_page.dart';
import 'package:virok_wms/feature/returning/returning_in/ui/returning_in_head_page.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/feature/home_page/home_page.dart';

import 'package:virok_wms/feature/settings/settings_page.dart';
import 'package:virok_wms/login/login_page.dart';
import '../feature/admission/admission_page.dart';
import '../feature/admission/displacement/ui/diplacement_order_data_page.dart';
import '../feature/admission/displacement/ui/displacement_order_head_page.dart';

import '../feature/moving/moving_out/ui/moving_out_order_data_page.dart';
import '../feature/moving/moving_out/ui/moving_out_order_head_page.dart';
import '../feature/recharging/recharge/ui/recharge_page.dart';
import '../feature/returning/returning_in/ui/returning_in_data_page.dart';
import '../feature/returning/returning_out/ui/returning_out_order_data_page.dart';
import '../feature/returning/returning_out/ui/returning_out_order_head_page.dart';
import '../feature/returning/returning_page.dart';
import '../feature/selection/ui/selection_order_data_page.dart';
import '../feature/selection/ui/selection_order_head_page.dart';
import '../feature/storage_operation/barcode_generation/ui/barcode_generation.dart';
import '../feature/storage_operation/barcode_lable_print/ui/barcode_lable_print_page.dart';
import '../feature/storage_operation/cell_generator/cell_generator_page.dart';
import '../feature/storage_operation/check_basket/ui/check_basket_page.dart';
import '../feature/storage_operation/check_cell/ui/check_cell_page.dart';
import '../feature/storage_operation/check_nom/ui/check_nom_list_page.dart';
import '../feature/storage_operation/check_nom/ui/nom_operation_page.dart';
import '../feature/storage_operation/placement_writing_off/placement_goods/ui/placement_goods_page.dart';
import '../feature/storage_operation/placement_writing_off/writing_off/ui/writing_off_page.dart';
import '../feature/storage_operation/storage_operation_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(const LoginPage(), settings: settings);
      case AppRoutes.storageOperations:
        return buildRoute(const StorageOperationPage(), settings: settings);
      case AppRoutes.homePage:
        return buildRoute(const HomePage(), settings: settings);
      case AppRoutes.placementGoodsPage:
        return buildRoute(const PlacementGoodsPage(), settings: settings);
      case AppRoutes.writingOff:
        return buildRoute(const WritingOffPage(), settings: settings);
      case AppRoutes.selectionOrderHeadPage:
        return buildRoute(const SelectionOrdersHeadPage(), settings: settings);
      case AppRoutes.selectionOrderDataPage:
        return buildRoute(const SelectionOrderDataPage(), settings: settings);
      case AppRoutes.movingPage:
        return buildRoute(const MovingPage(), settings: settings);
      case AppRoutes.movingOutHeadPage:
        return buildRoute(const MovingOutHeadPage(), settings: settings);
      case AppRoutes.movingOutDataPage:
        return buildRoute(const MovingOutDataPage(), settings: settings);

      case AppRoutes.movingGateHeadPage:
        return buildRoute(const MovingGateHeadPage(), settings: settings);
      case AppRoutes.movingGateDataPage:
        return buildRoute(const MovingGateDataPage(), settings: settings);

      case AppRoutes.movingInHeadPage:
        return buildRoute(const MovingInHeadPage(), settings: settings);
      case AppRoutes.movingInDataPage:
        return buildRoute(const MovingInDataPage(), settings: settings);

      case AppRoutes.returningPage:
        return buildRoute(const ReturningPage(), settings: settings);
      case AppRoutes.returningOutHeadPage:
        return buildRoute(const ReturningOutHeadPage(), settings: settings);
      case AppRoutes.returningOutDataPage:
        return buildRoute(const ReturningOutDataPage(), settings: settings);

      case AppRoutes.returningInHeadPage:
        return buildRoute(const ReturningInHeadPage(), settings: settings);
      case AppRoutes.returningInDataPage:
        return buildRoute(const ReturningInDataPage(), settings: settings);


      case AppRoutes.rechargePage:
        return buildRoute(const RechargePage(), settings: settings);
           case AppRoutes.rechargingMenuPage:
        return buildRoute(const RechargingMenuPage(), settings: settings);
             case AppRoutes.movingInCells:
        return buildRoute(const MovingInCellsPage(), settings: settings);

      case AppRoutes.admissionPage:
        return buildRoute(const AdmissionPage(), settings: settings);
      case AppRoutes.displacementOrderHeadPage:
        return buildRoute(const DisplacementOrdersHeadPage(),
            settings: settings);
      case AppRoutes.displacementorderDataPage:
        return buildRoute(const DiplacementOrderDataPage(), settings: settings);

      case AppRoutes.admissionOlacementOrderHeadPage:
      return buildRoute(const PlacementOrdersHeadPage(), settings: settings);

      case AppRoutes.admissionPlacementPage:
        return buildRoute(const AdmissingPlacementPage(), settings: settings);
      case AppRoutes.barcodeGeneration:
        return buildRoute(const BarcodeGenerationPage(), settings: settings);
      case AppRoutes.barcodeLablePrint:
        return buildRoute(const BarcodeLeblePrintPage(), settings: settings);
      case AppRoutes.checkBasket:
        return buildRoute(const ChackBasketPage(), settings: settings);
      case AppRoutes.cellGeneratorPage:
        return buildRoute(const CellGeneratorPage(), settings: settings);
      case AppRoutes.checkCell:
        return buildRoute(const CheckCellPage(), settings: settings);
      case AppRoutes.settings:
        return buildRoute(const SettingsPage(), settings: settings);
      case AppRoutes.checkNomListPage:
        return buildRoute(const CheckNomListPage(), settings: settings);
      case AppRoutes.checkNomPage:
        return buildRoute(const CheckNomPage(), settings: settings);

      case AppRoutes.placementPage:
        return buildRoute(const AdmissingPlacementPage1(), settings: settings);
          case AppRoutes.inventoryHeadPage:
        return buildRoute(const InventoryHeadPage(), settings: settings);
                  case AppRoutes.inventoryDataPage:
        return buildRoute(const InventoryDataPage(), settings: settings);
      default:
        return buildRoute(const HomePage(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
        settings: settings, builder: (BuildContext context) => child);
  }
}
