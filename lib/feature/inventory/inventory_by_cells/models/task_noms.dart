class CellInventoryTaskNoms {
  final List<CellInventoryTaskNom> cellInventoryTaskData;
  final String errorMassage;

  CellInventoryTaskNoms(
      {required this.cellInventoryTaskData, required this.errorMassage});

  static final empty =
      CellInventoryTaskNoms(cellInventoryTaskData: [], errorMassage: '');
}

class CellInventoryTaskNom {
  final String nom;
  final String article;
  final List<Barcode> barcodes;
  final String taskNumber;
  final String codCell;
  final String nameCell;
  final int count;
  final int scannedCount;
  final String nomStatus;

  static final empty = CellInventoryTaskNom(
      nom: '',
      article: '',
      barcodes: [],
      taskNumber: '',
      codCell: '',
      nameCell: '',
      count: 0,
      scannedCount: 0,
      nomStatus: '');

  CellInventoryTaskNom({
    required this.nom,
    required this.article,
    required this.barcodes,
    required this.taskNumber,
    required this.codCell,
    required this.nameCell,
    required this.count,
    required this.scannedCount,
    required this.nomStatus,
  });
}

class Barcode {
  final String barcode;
  final int count;
  final int ratio;

  Barcode({
    required this.barcode,
    required this.count,
    required this.ratio,
  });
}
