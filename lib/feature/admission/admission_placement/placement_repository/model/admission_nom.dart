
import '../../../../../models/barcode_model.dart';

class AdmissionNoms {
    final List<AdmissionNom> noms;

    AdmissionNoms({
        required this.noms,
    });

static final empty = AdmissionNoms(noms: []);

}

class AdmissionNom {
    final String incomingInvoice;
    final String date;
    final String customer;
    final String name;
    final int qty;
    final String article;
    final List<Barcode> barcodes;
    final double count;
    final int task;
    final String nameCell;
    final String codeCell;

    AdmissionNom({
        required this.incomingInvoice,
        required this.date,
        required this.customer,
        required this.name,
        required this.qty,
        required this.article,
        required this.barcodes,
        required this.count,
        required this.task,
        required this.codeCell,
        required this.nameCell
    });


}

