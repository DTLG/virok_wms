import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virok_wms/feature/moving_defective_page/api_client/api_client.dart';
import 'package:virok_wms/feature/moving_defective_page/model/service_moving_doc.dart';

part 'docs_defect_state.dart';

class DocsDefectCubit extends Cubit<DocsDefectState> {
  DocsDefectCubit() : super(DocsDefectState());

  Future<void> getDocs() async {
    emit(state.copyWith(status: DocsDefectStatus.loading));
    final client = ApiClient();
    final docs = await client.getDocs();
    if (docs == null) {
      emit(state.copyWith(
        status: DocsDefectStatus.error,
        erorrMessage: 'Схоже тут пусто',
      ));
      return;
    }
    emit(state.copyWith(docs: docs, status: DocsDefectStatus.loaded));
  }
}
