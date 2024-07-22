import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PrinterConnect {
  connectToPrinter(String label, {int quantity = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('printer_host');
    final port = int.parse(prefs.getString('printer_port') ?? '9100');

    Socket.connect(host, port).then((socket) {
      for (int i = 0; i < quantity; i++) {
        socket.write(label);
      }
      socket.close();
    });
  }
}
