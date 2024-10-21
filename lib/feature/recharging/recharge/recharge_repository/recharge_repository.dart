import 'package:virok_wms/feature/recharging/recharge/recharge_client/recharge_client.dart';
import 'package:virok_wms/feature/recharging/recharge/recharge_repository/models/recharge_noms.dart';
import 'package:virok_wms/models/barcode_model.dart';

class RechargeRepository {
  RechargeRepository({RechargeClient? rechargeClient})
      : _rechargeClient = rechargeClient ?? RechargeClient();

  final RechargeClient _rechargeClient;

  Future<RechargeNoms> rechargeRepo(String query, String body) async {
    final listNom = await _rechargeClient.rechargeApi(query, body);

    List<RechargeNom> tasks = listNom.tasks
        .map((e) => RechargeNom(
            taskNumber: e.taskNumber ?? '',
            date: e.date ?? '',
            tovar: e.tovar ?? '',
            qty: e.qty ?? 0,
            article: e.article ?? '',
            barcodes: e.barcodes
                .map((e) => Barcode(
                    barcode: e.barcode ?? '', ratio: e.ratio?.toInt() ?? 1))
                .toList(),
            countTake: e.countTake ?? 0,
            countPut: e.countPut ?? 0,
            codCellFrom: e.codCellFrom ?? '',
            nameCellFrom: e.nameCellFrom ?? '',
            codCellTo: e.codCellTo ?? '',
            nameCellTo: e.nameCellTo ?? '',
            isStarted: e.isStarted ?? 0))
        .toList();
    return RechargeNoms(
        tasks: tasks, errorMassage: listNom.errorMassage ?? 'OK');
  }
}
