
// import 'package:virok_wms/services/sqlite/db_services.dart';

// import '../../../models/nom_model_dto.dart';

// class SelectionDBClient {
//   Future<List<NomDTO>> selectionDb(NomsDTO noms) async {
//     final database = await SQFLiteServices().database;
//     String selectionValues = '';
//     String barcodeValues = '';

//     int id = 0;
//     for (var nom in noms.noms) {
//       id++;
//       selectionValues +=
//           ",($id,'${nom.name}','${nom.article}','${nom.nameCell}','${nom.docNumber}','${nom.table}',${nom.count},${nom.qty})";
//       for (var barcode in nom.barcodes) {
//         barcodeValues += ',($id,"${barcode.barcode}",${barcode.ratio})';
//       }
//     }

//     try {
//       await database.rawQuery('delete from selection');
//       await database.rawQuery('delete from barcodes');

//       await database.rawQuery(
//           'insert into selection (id,name, article,cell,doc_number, table_value, count, qty) values ${selectionValues.replaceFirst(',', '')}');
//       await database.rawQuery(
//           'insert into barcodes (nom_id,barcode,ratio) values ${barcodeValues.replaceFirst(',', '')}');
//       final res = await database.rawQuery(
//           'SELECT * from selection s left join barcodes b on s.id = b.nom_id');

//       List<NomDTO> nomList = [];
//       for (var i = 0; i <= res.length-1; i++) {
//         if (res[i]['id'] != res[res.length+1]['id']) {
//           nomList.add(NomDTO(
//               name: res[i]['name'] as String?,
//               table: res[i]['table_value'] as String?,
//               article: res[i]['article'] as String?,
//               barcodes: [],
//               nameCell: res[i]['cell'] as String?,
//               codeCell: '',
//               itsMyne: 0,
//               docNumber: res[i]['doc_number'] as String?,
//               qty: res[i]['qty'] as double?,
//               count: res[i]['count'] as double?));
//         }else{}
//       }
//             print(nomList.first.article);


//       // List<NomDTO> a = res
//       //     .map((e) {

//       //     return  NomDTO(
//       //         name: e['name'] as String?,
//       //         table: e['table_value'] as String?,
//       //         article: e['article'] as String?,
//       //         barcodes: [],
//       //         nameCell: e['cell'] as String?,
//       //         codeCell: '',
//       //         docNumber: e['doc_number'] as String?,
//       //         qty: e['qty'] as double?,
//       //         count: e['count'] as double?);
//       //     })
//       //     .toList();
//       return nomList;
//     } catch (e) {
//       throw Exception('Error sending request: $e');
//     }
//   }
// }
