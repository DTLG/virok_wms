import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/services/printer/connect_printer.dart';

class LablePrintPage extends StatelessWidget {
  const LablePrintPage({super.key});

  // Method to show dialog with input field for label quantity
  Future<void> _showQuantityDialog(
      BuildContext context, String labelName) async {
    int quantity = 1; // Default quantity

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Введіть кількість наліпок для $labelName'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            quantity =
                int.tryParse(value) ?? 1; // Parse input to int or default to 1
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Скасувати'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await PrinterConnect()
                  .connectToPrinter(await lable(labelName), quantity: quantity);
            },
            child: Text('Друк'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Друк етикеток'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await PrinterConnect().connectToPrinter((await lable('toya')));
              },
              onLongPress: () async {
                await _showQuantityDialog(context, 'toya');
              },
              child: const SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    'TOYA',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                await PrinterConnect()
                    .connectToPrinter((await lable('marolex')));
              },
              onLongPress: () async {
                await _showQuantityDialog(context, 'marolex');
              },
              child: const SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    'MAROLEX',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PrinterConnect()
                      .connectToPrinter((await lable('gobain')));
                },
                onLongPress: () async {
                  await _showQuantityDialog(context, 'gobain');
                },
                child: const SizedBox(
                    height: 60,
                    child: Center(
                        child: Text(
                      'SAINT-GOBAIN',
                      textAlign: TextAlign.center,
                    )))),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PrinterConnect().connectToPrinter((await lable('ush')));
                },
                onLongPress: () async {
                  await _showQuantityDialog(context, 'ush');
                },
                child: const SizedBox(
                    height: 60,
                    child: Center(
                        child: Text(
                      'USH',
                      textAlign: TextAlign.center,
                    )))),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PrinterConnect()
                      .connectToPrinter((await lable('stanley')));
                },
                onLongPress: () async {
                  await _showQuantityDialog(context, 'stanley');
                },
                child: const SizedBox(
                    height: 60,
                    child: Center(
                        child: Text(
                      'STANLEY',
                      textAlign: TextAlign.center,
                    )))),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PrinterConnect().connectToPrinter((await lable('nws')));
                },
                onLongPress: () async {
                  await _showQuantityDialog(context, 'nws');
                },
                child: const SizedBox(
                    height: 60,
                    child: Center(
                        child: Text(
                      'NWS',
                      textAlign: TextAlign.center,
                    )))),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PrinterConnect()
                      .connectToPrinter((await lable('stabila')));
                },
                onLongPress: () async {
                  await _showQuantityDialog(context, 'stabila');
                },
                child: const SizedBox(
                    height: 60,
                    child: Center(
                        child: Text(
                      'STABILA',
                      textAlign: TextAlign.center,
                    )))),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

Future lable(String lable) async {
  String a = '';

  const darknees = 2;

  if (lable == 'marolex') {
    a = 'Польща , Ломна, вул.Гдансська 35 на підприємстві MAROLEX Sp.z o. o.';
  } else if (lable == 'ush') {
    a = 'Німеччина, Гільхенбах, Глюк-Ауф-Штрассе 36 на підприємстві USH Germany Gmbh';
  } else if (lable == 'stanley') {
    a = 'Бельгія, Мехелен, Егеді Валтштрітарт 14-16 на підприємстві Stanley Europe';
  } else if (lable == 'nws') {
    a = 'Німеччина, Золінген, Розенштрассе 12-18 на підприємстві NWS Germany Produktion';
  } else if (lable == 'stabila') {
    a = 'Німеччина Аннвайлер-ам-Тріфельс Ландауер 45 на підприємстві STABILA GmbH';
  } else if (lable == 'toya') {
    a = 'Вроцлав, вул. Солтисовіцька 13-15, на підприємстві TOYA S.A., 51-168';
  } else if (lable == 'gobain') {
    a = 'Польща , Коло, вул. Нортон 1 на підприємстві “Saint-Gobain HPM Polska” 62-600';
  }

  return '''
^XA
^PW399
^PQ1
^MD$darknees


^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS

^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FD$a^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ


''';
}

const marolex = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS

^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FD Польща , Ломна, вул.Гдансська 35 на підприємстві MAROLEX Sp.z o. o.^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ


''';

const ush = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS

^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDНімеччина, Гільхенбах, Глюк-Ауф-Штрассе 36 на підприємстві USH Germany Gmbh^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS
^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ


''';

const stanley = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS

^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDБельгія, Мехелен, Егеді Валтштрітарт 14-16 на підприємстві Stanley Europe^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS
^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ

''';

const nws = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS
^FO20,42
^GB368,1,1^FS
 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDНімеччина, Золінген, Розенштрассе 12-18 на підприємстві NWS Germany Produktion^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ


''';

const stabila = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS
^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDНімеччина Аннвайлер-ам-Тріфельс Ландауер 45 на підприємстві STABILA GmbH^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ


''';

const toya = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS
^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDВроцлав, вул. Солтисовіцька 13-15, на підприємстві TOYA S.A., 51-168^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS





^XZ




''';

const jpw = '''
^XA
^PW399

^PQ1

^FO215,115^GFA,240,240,6,,::I07F8007F,001FF803FF,007FF007FF,00FF001FE,01F8003F,03EI07C,07CI0F8,078I0F,0FI01E,1EI01E,1EI03C,1CI03C,3CI038,3CI078,38I078,38I07FF8,38I07FFC,:38I07FF8,38I078,3CI078,3CI038,1CI03C,1EI03C,1EI01E,0FI01E,078I0F,07CI0F8,03EI07E,01F8003F,00FF001FE,007FF007FF,001FF803FF,I07F8007F,,::^FS




^FO260,115^GFA,200,200,5,,J01,I03FFC,I0E007,003J0C,006J06,018J018,03L08,02,04001,0C001,08001,18001,1I03,:2I03,:20807001,20407006,20607038,2030F1F,201C71E,200E338,2007B7,2003D6,1001F8,1001F,1800F,08007,0C003,04001,02,01L08,018J018,006J06,003J0C,I0E007,I03FFC,J018,,^FS




^FO240,100^GFA,1926,1926,18,,gQ0C,gP03E,gP07F8,gO01F8C,gO07F02,gO0FE01,gN03FC00C,gN0FF8003,gM01FFJ08,gM07FEJ08,gL01FFCJ08,gL03FF8J08,gL0IFK08,gK03FFEK0C,gK01FFCK07,gL07F8L08gL01FM08gM07L01,gM01CK01,gN06K02,gJ0CI01K02,gI01E1C008J01,gH0E3122006K08gH0FE0E3003K04gG01CC001BC1K04gG018J0C408J0Cg07FL0404I018g07EL0606I01,g07CL0202I02,g078L0103I01,g07N081I01,Y01EN041J08Y0FCN0208I08Y0F8N01080018Y0FL03FE088007,Y0EL0E01E88004,Y0CK03I01C8008,X018K06M018,X01L0CM03C,X01K01BK0807C,X03K033K080FC,X02K0638J081FC,X02K0438J083F,X06K083CI0107C02X04J0183CI010F806X04J0103EI011F81AX04J0303EI023F832X04J0203FI067F842X02J0203F8004FF082X01J0403F800DE0302Y08I0403E400B80602Y04I0407C301F01802Y02I04078181807002Y0180040F007203C002g0C0080EI0FFEI02g0600806O02g0300803O02g01808018N02gG0C0801O02gG060801O02gK01O02:1FFCW07FE01O021FFE0FFEFFC1JF8I03E0780E3FF01FF821FFA18048041J06I0EI06010010201020FF310048041J018018I018I010401060FE130088041K0C07K0CI0104020E078120088041K0404K06I0108041E0781A0188041K0208K02I0110043E0300E0108041K0218K01I0110087E0300C010804100F8033001FI080012010FE0180C020804100840320070C0080010011FE018040208041008403600C020040014023F8008I04080410084036018010040018007E,00CI040804100FC024010010040018047,004I080804100E002403I0804001008C,006I080804100E006403I08040010048,00200100804100E00C403I0804001804,00200100804100E018403I0804001802,00100200804100E030401001004001402,00100200804100E010601803004001401,I080400804100E018200C06K01201,I080400804100E00820039C0080012008,I040400804100F00C1I0EL011008,I040800804100D00418K01I011004,I020800804100D80608K02I010804,I021I0804100C80204K04I010802,I021I0804100CC0303K08I01I03,I012I0804100C401018I03J010401,I012I0804100C601006I0CJ01I018,J0CI0FFC1FFC3FF801C07I03FF03FF8,J0CV01F,,:N01EL0CL0180CJ018,N01CL0CL0180CJ018,I01I041C1010300180406181E080C186,I0FC79F3E7C7CFCC7E7F1F981F3E3F19F,I0CE73198C6C0C0CE67331980C6I39B8,I0C663198FEF8F8CC76307980C633199F,I0C663198C07E7IC7633B980C637198F8,I0CE63198C4060ECE66331980C63319818,I0FC63B18ECEEIC6E633B980F763B1B98,I0D860E18387C78C3C631D98071C1E18F,I0C,:^FS


^CI28

^FO20,50
^FB400,4,3
^A0, 14, 18,
^FDJPW (Tool) AG ^FS


// ^FO20,70
// ^FB400,4,3
// ^A0, 14, 18,
// ^FDAckerstrasse 45 CH-8610 Usster Switzerland^FS


// ^FO20,90
// ^FB370,4,3
// ^A0, 14, 18,
// ^FDПостачальник: ТзОВ "1001 Дрібниця" ^FS


// ^FO20,110
// ^FB200,4,3
// ^A0, 14, 18,
// ^FD Україна, 79030, м. Львів, вул. Наукова, 29^FS



^A0, 11, 13,
^FO31,178^FDMade in PRC / Виготовлено в КНР^FS

^FO29,191
^GB190,2,2^FS

^AA, 5, 8,
^FO30,198^FDWWW.VIROK.COM.UA^FS






^XZ


 ''';

const gobain = '''
^XA
^PW399
^PQ1

^FO335,150^GFA,420,420,7,M06,K03IF8,J01KF,J07KFE,I01FFI0FF,I07F8I01FC,I0FCK07E,001F8K01F8,003EM07C,007CM03E,00FJ04I01F,01EJ06J0F,03CJ06J06,07CJ0E,078J0C,0FK0D,0EK0D,1EJ01C,1CJ01C,3CJ01C8,38J01C8,38J03C,78J03C4,7K03C4,7K03C,7038007CI018,701E007C200F8,F00CC07C203F,F00718FC01FA,F00382FC1FF4,F001C0FC1FC8,F001F07C3F9,FI0F87C3E,7I07E3C7C2,7I03F1CF84,7I01F9CE08,7J0FEDC1,78I0IF02,38I07FE04,38I03FC,3CI01FC,1CJ0FC1,1EJ07C2,0EJ03C4,0FJ03C8,078I01C,078J0C,03CJ06J02,01EO07,01FO0F,00F8M03E,007CM07C,003FM0F8,I0FCK03F,I07FK0FE,I01FEI07F8,J0IF9FFE,J03KF8,K07IFC,L07FC,^FS

^CI28

 ^FO20,30
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження виробника:^FS

^FO20,42
^GB368,1,1^FS

 ^FO20,48
 ^FB360,5,5
 ^A0, 12, 15,
 ^FDПольща , Коло, вул. Нортон 1 на підприємстві “Saint-Gobain HPM Polska” 62-600^FS

 ^FO20,83
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDНайменування та місцезнаходження імпортера:^FS

^FO20,96
^GB368,1,1^FS

 ^FO20,104
 ^FB360,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів, вул. Наукова, 29, 79030, тел.:032-244-71-08^FS


 ^FO20,136
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDДата виготовлення:^FS

^FO20,149
^GB147,1,1^FS

 ^FO170,136
 ^FB360,4,3
 ^A0, 12, 15,
^FDвказана на інструменті.^FS

 ^FO20,156
 ^FB400,4,3
 ^A0, 14, 18,
 ^FDПідприємство, що здійснює ремонт:^FS

^FO20,169
^GB276,1,1^FS

 ^FO20,172
 ^FB320,4,3
 ^A0, 12, 15,
 ^FDТзОВ «1001 Дрібниця» м.Львів,
                           вул. Наукова, 29,79030, тел.:032-244-71-08
^FS


 ^FO20,202
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDТермін придатності необмежений
^FS


 ^FO20,217
 ^FB280,4,3
 ^A0, 12, 15,
 ^FDГарантійний термін 2 роки
^FS

^XZ

''';

const price = '''
^XA
^PQ1
^PW399


^CI28

 ^FO290,25
 ^FB350,4,3
 ^A0, 14, 19,
 ^FD12.01.2024^FS




 ^FO10,40
 ^FB350,4,3
 ^A0, 18, 22,
 ^FD(DW)Пила-сучкоріз акумуляторна 18 В YATO зим держаком :100- 220см,акум-р 3 Ах Г,шина- 20^FS



 ^FO10,130
 ^FB350,4,3
 ^A0, 28, 32,
 ^FDАрт: 85120^FS


 ^FO35,160
^BY2^BEN,60,Y,N
^FD8033609249442^FS



 ^FO250,170
 ^FB350,4,3
 ^A0, 30, 35,
 ^FD3861грн.^FS



 ^FO250,205
 ^FB350,4,3
 ^A0, 14, 19,
 ^FDЦіна за 1 шт.^FS




^XZ



''';
