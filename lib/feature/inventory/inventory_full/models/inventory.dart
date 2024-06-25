
class Inventory {
    final String nom;
    final String article;
    final List<Barcode> barcodes;
    final List<Cell> cells;
    final String docNumber;
    final String errorMassage;

    Inventory({
        required this.nom,
        required this.article,
        required this.barcodes,
        required this.cells,
        required this.docNumber,
        required this.errorMassage,
    });


static final empty = Inventory(nom: '', article: '', barcodes: [], cells: [], docNumber: '', errorMassage: '');


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

class Cell {
    final String cellCode;
    final String cellName;
    final int planCount;
    final int factCount;
    final String nomStatus;

    Cell({
        required this.cellCode,
        required this.cellName,
        required this.planCount,
        required this.factCount,
        required this.nomStatus
    });


}
