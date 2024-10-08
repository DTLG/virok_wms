import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';

Future<bool> printLabel({
  required String region_short,
  required String customer,
  required String address,
  required String date_number,
  required String order_date_number,
  required String customer_group,
  required String barcode,
  required String comment,
  required int totalAmount,
  required int currentIndex,
  required String pickup_type,
}) async {
  // Отримуємо IP принтера з SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? printerIp = prefs.getString('printer_host');
  String? printerPort = prefs.getString('printer_port');

  if (printerIp == null) {
    print('Printer IP not found in SharedPreferences');
    return false; // Повертаємо false, якщо IP не знайдено
  }

  String zplData = '''
^XA
^PW780
^LL1169
^LS0
^FO16,65^GB752,714,5^FS
^FO190,68^GB0,87,5^FS
^FO620,65^GB0,90,5^FS
^FT30,140^A0N,58,58^FH\\^CI28^FD$region_short^FS^CI27
^FPH,1^FT200,140^A0N,28,28^FB400,2,,\\^CI28^FD$customer_group^FS^CI27
^FT626,137^A0N,33,33^FH\\^CI28^FD$totalAmount - $currentIndex^FS^CI27  
^FO16,424^GB748,0,5^FS
^FO19,482^GB744,0,5^FS
^FT626,758^A0N,33,33^FH\\^CI28^FD$totalAmount - $currentIndex^FS^CI27
^FT21,224^A0N,33,33^FB720,2,,\\^CI28^FD$customer^FS^CI27
^FT21,338^A0N,28,28^FB720,3,,\\^CI28^FD$address^FS^CI27
^FT21,372^A0N,33,33^FH\\^CI28^FD$order_date_number^FS^CI27
^FT21,451^AAN,27,15^FH\\^CI28^FD$comment^FS
^BY3,3,100^FT125,615^BCN,70,Y,N,N
^FD$barcode^FS
^LRY^FO21,155^GB743,0,90^FS
^LRY^FO21,249^GB743,0,90^FS
^LRY^FO620,685^GB143,0,90^FS
^LRN
^PQ1,0,1,Y
^XZ
''';

  try {
    print('Connecting to $printerIp on port ${printerPort ?? '9100'}');
    Socket socket =
        await Socket.connect(printerIp, int.parse(printerPort ?? '9100'));
    print('Connected to the printer');

    socket.add(utf8.encode(zplData));
    await socket.flush();
    socket.destroy();
    print('Label sent successfully');
    return true; // Успішна відправка — повертаємо true
  } catch (e) {
    print('Error printing label: $e');
    showToast('Потрібно дописати тут код');
    //!!!!!!!!!!!!!!!!!!!!!!!!!
    return false; // У разі помилки — повертаємо false
  }
}
