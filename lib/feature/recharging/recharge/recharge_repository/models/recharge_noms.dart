import 'package:virok_wms/models/barcode_model.dart';

class RechargeNoms {
  final List<RechargeNom> tasks;
  final String errorMassage;

  RechargeNoms({
    required this.tasks,
    required this.errorMassage,
  });

  static final empty = RechargeNoms(tasks: [], errorMassage: '');
}

class RechargeNom {
  final String taskNumber;
  final String date;
  final String tovar;
  final int qty;
  final String article;
  final List<Barcode> barcodes;
  final int countTake;
  final int countPut;
  final String codCellFrom;
  final String nameCellFrom;
  final String codCellTo;
  final String nameCellTo;
  final double isStarted;

  RechargeNom({
    required this.taskNumber,
    required this.date,
    required this.tovar,
    required this.qty,
    required this.article,
    required this.barcodes,
    required this.countTake,
    required this.countPut,
    required this.codCellFrom,
    required this.nameCellFrom,
    required this.codCellTo,
    required this.nameCellTo,
    required this.isStarted,
  });
}
