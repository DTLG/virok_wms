import 'package:flutter/material.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_admission/ui/placement_head_page.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/ui/placement_from_return_page.dart';
import 'package:virok_wms/feature/admission/placement/ui/placement_data_page.dart';
import 'package:virok_wms/feature/admission/placement/ui/placement_head_page.dart';
import 'package:virok_wms/feature/epicenter_page/ui/pages/epicenter_page.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/task_noms/ui/task_noms.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/tasks/ui/tasks_page.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/ui/task_cells.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/tasks/ui/tasks_page.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_data/ui/full_inventory_data_page.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_head/ui/full_inventory_head_page.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/tasks/ui/tasks_page.dart';
import 'package:virok_wms/feature/inventory/inventory_page.dart';
import 'package:virok_wms/feature/label_print/lable_print_page.dart';
import 'package:virok_wms/feature/meest_ttn_print/ui/meest_ttn_print_page.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/moving_out_order_data_page.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/moving_out_order_head_page.dart';
import 'package:virok_wms/feature/moving/moving_in/ui/moving_in_data_page.dart';
import 'package:virok_wms/feature/moving/moving_in/ui/moving_in_head_page.dart';
import 'package:virok_wms/feature/moving/moving_page.dart';
import 'package:virok_wms/feature/moving_defective_page/ui/create_order.dart';
import 'package:virok_wms/feature/moving_defective_page/ui/moving_defective_page.dart';
import 'package:virok_wms/feature/moving_defective_page/ui/read_orders.dart';
import 'package:virok_wms/feature/np_ttn_print/ui/np_ttn_print_page.dart';
import 'package:virok_wms/feature/recharging/moving_in_cells/ui/moving_in_cells_page.dart';
import 'package:virok_wms/feature/recharging/recharging_menu_page.dart';
import 'package:virok_wms/feature/return/ui/return_data_page.dart';
import 'package:virok_wms/feature/return/ui/return_head_page.dart';
import 'package:virok_wms/feature/storage_operation/cell_generator/cell_generator.dart';
import 'package:virok_wms/feature/storage_operation/cell_generator/harkiv_page.dart';
import 'package:virok_wms/feature/storage_operation/cell_generator/kyiv_page.dart';
import 'package:virok_wms/feature/storage_operation/product_lable/view/product_lable_view.dart';
import 'package:virok_wms/login/login_page.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/feature/home_page/home_page.dart';
import 'package:virok_wms/feature/settings/settings_page.dart';

import '../feature/admission/admission_page.dart';
import '../feature/admission/displacement/ui/diplacement_order_data_page.dart';
import '../feature/admission/displacement/ui/displacement_order_head_page.dart';
import '../feature/moving/moving_out/ui/moving_out_order_data_page.dart';
import '../feature/moving/moving_out/ui/moving_out_order_head_page.dart';
import '../feature/recharging/recharge/ui/recharge_page.dart';
import '../feature/returning/return_epic/ui/return_epic_page.dart';
import '../feature/returning/returning_out/ui/returning_out_order_data_page.dart';
import '../feature/returning/returning_out/ui/returning_out_order_head_page.dart';
import '../feature/returning/returning_page.dart';
import '../feature/selection/ui/selection_order_data_page.dart';
import '../feature/selection/ui/selection_order_head_page.dart';
import '../feature/storage_operation/barcode_generation/ui/barcode_generation.dart';
import '../feature/storage_operation/barcode_lable_print/ui/barcode_lable_print_page.dart';
import '../feature/storage_operation/cell_generator/lviv_page.dart';
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
      //! Stickers print
      case AppRoutes.labelPrint:
        return buildRoute(const LablePrintPage(), settings: settings);
      case AppRoutes.npTtnPage:
        return buildRoute(const TtnNovaPostPrint(), settings: settings);
      case AppRoutes.meestTtnPage:
        return buildRoute(const MeestTtnPrint(), settings: settings);
      case AppRoutes.login:
        return buildRoute(const LoginPage(), settings: settings);
      case AppRoutes.epicenter:
        return buildRoute(const EpicenterPage(), settings: settings);
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
      case AppRoutes.movingdefectivePage:
        return buildRoute(const MovingDefectivePage(), settings: settings);
      case AppRoutes.movingdefectiveRead:
        return buildRoute(const ReadDefectiveOrdersPage(), settings: settings);
      case AppRoutes.movingdefectiveCreate:
        return buildRoute(const CreateDefectiveOrdersPage(),
            settings: settings);

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
        return buildRoute(const ReturnHeadPage(), settings: settings);
      case AppRoutes.returningInDataPage:
        return buildRoute(const ReturnDataPage(), settings: settings);
      case AppRoutes.returnEpicPage:
        return buildRoute(const ReturnEpicPage(), settings: settings);

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
      case AppRoutes.barcodeGeneration:
        return buildRoute(const BarcodeGenerationPage(), settings: settings);
      case AppRoutes.barcodeLablePrint:
        return buildRoute(const BarcodeLeblePrintPage(), settings: settings);
      case AppRoutes.productLablePrint:
        return buildRoute(const ProductLablesPage(), settings: settings);
      case AppRoutes.checkBasket:
        return buildRoute(const ChackBasketPage(), settings: settings);
      case AppRoutes.cellGeneratorPage:
        return buildRoute(const CellGenerationPage(), settings: settings);
      case AppRoutes.lvivCellsPage:
        return buildRoute(const LvivCellGeneratorPage(), settings: settings);
      case AppRoutes.kyivCellsPage:
        return buildRoute(const KyivCellGeneratorPage(), settings: settings);
      case AppRoutes.harkivCellsPage:
        return buildRoute(const HarkivCellGeneratorPage(), settings: settings);
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

      case AppRoutes.inventoryPage:
        return buildRoute(const InventoryPage(), settings: settings);

      case AppRoutes.fullInventoryHeadPage:
        return buildRoute(const FullInventoryHeadPage(), settings: settings);
      case AppRoutes.fullInventoryDataPage:
        return buildRoute(const FullInventoryDataPage(), settings: settings);

      case AppRoutes.inventoryByCellsTasksPage:
        return buildRoute(const InventoryByCellsTasksPage(),
            settings: settings);
      case AppRoutes.inventoryByCellsTaskNomsPage:
        return buildRoute(const InventoryByCellsTaskNomsPage(),
            settings: settings);

      case AppRoutes.inventoryByNomTasksPage:
        return buildRoute(const InventoryByNomTasksPage(), settings: settings);

      case AppRoutes.inventoryByNomTaskPage:
        return buildRoute(const InventoryByNomTaskCellsPage(),
            settings: settings);
      case AppRoutes.inventoryNomInCellTasksPage:
        return buildRoute(const InventoryNomInCellTasksPage(),
            settings: settings);
      //* Київ розміщення
      case AppRoutes.placementFromAdmissionPage:
        return buildRoute(const PlacementFromAdmissionHeadPage(),
            settings: settings);
      case AppRoutes.placementFromReturnPage:
        return buildRoute(const PlacementFromReturnPage(), settings: settings);
      //* ---------------
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
