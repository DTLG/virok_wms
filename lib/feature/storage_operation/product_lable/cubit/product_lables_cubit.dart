import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/storage_operation/product_lable/models/product_models.dart';
import 'package:virok_wms/feature/storage_operation/product_lable/product_lable_client/product_lable_client.dart';

import '../../../../services/printer/connect_printer.dart';
import '../../../../services/printer/lables.dart';

part 'product_lables_state.dart';

class ProductLablesCubit extends Cubit<ProductLablesState> {
  ProductLablesCubit() : super(const ProductLablesState());

  Future<void> getLables() async {
    try {
      final lables = await ProductLableClient().getlables();
      emit(state.copyWith(status: ProductLableStatus.success, lables: lables, filteredLables: lables));
    } catch (e) {
      emit(state.copyWith(
          status: ProductLableStatus.failure, errorMassage: e.toString()));
    }
  }

  search(String searchValue) {
    final filteredLables = state.lables.labels
        .where((lables) =>
            lables.name.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredLables: ProductLables(labels: filteredLables)));
  }

  Future<void> printLable(String text, int count) async {
    PrinterConnect().connectToPrinter(PrinterLables.productLable(text, count));
  }
}
