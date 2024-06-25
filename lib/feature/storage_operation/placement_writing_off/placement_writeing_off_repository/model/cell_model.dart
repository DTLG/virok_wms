// import 'package:equatable/equatable.dart';

// class Cell extends Equatable {
//   final String name;
//   final dynamic quantity;
//   final String barcode;
//   final String article;

//   final String number;
//   final String nameCell;
//   final String codeCell;
//   final int zoneStatus;
//   final int status;

//   const Cell(
//       {required this.name,
//     required this.quantity,
//     required this.article,
//       required this.codeCell,
//       required this.nameCell,
//     required this.barcode,
//       required this.number,
//       required this.zoneStatus,
//       required this.status});

//   @override
//   List<Object?> get props => [name, quantity, barcode, number, status, zoneStatus];

//   static const empty =
//       Cell(name: '', quantity: '', barcode: '',article: '', number: '', status: 0, codeCell: '', nameCell: '', zoneStatus: 1);
// }
import 'package:equatable/equatable.dart';

class Cell extends Equatable{
  final List<CellData> cell;
  final int zone;

  const Cell({required this.cell, required this.zone});
  
  @override
  List<Object?> get props => [cell, zone];

  static const empty = Cell(cell: [CellData.empty], zone: 1);

}

class CellData extends Equatable{
  final String name;
  final dynamic quantity;
  final String nameCell;
  final String codeCell;
  final List<String> barcodes;
  final String article;

  final int status;

  const CellData(
      {required this.name,
      required this.quantity,
      required this.nameCell,
      required this.codeCell,
      required this.article,
      required this.barcodes,
      required this.status});
        @override
  List<Object?> get props => [name, quantity, barcodes,  status, nameCell, codeCell,article ];

    static const empty = CellData(name: '', quantity: 0, nameCell: '', codeCell: '', article: '', barcodes: [], status: 1);

}
