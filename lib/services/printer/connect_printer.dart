import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PrinterConnect {
  connectToPrinter(String lable) async {
    final prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('printer_host');
    final port = int.parse(prefs.getString('printer_port') ?? '9100');
    Socket.connect(host, port).then((socket) {
      socket.write(lable);
      socket.close();
    });
  }
}
