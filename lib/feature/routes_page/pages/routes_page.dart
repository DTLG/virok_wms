import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virok_wms/feature/routes_page/cubit/routes_cubit.dart';
import 'package:virok_wms/feature/routes_page/pages/order_page.dart';
import 'package:virok_wms/feature/routes_page/pages/order_route_info_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/ui.dart';

import 'package:flutter/material.dart';
import 'package:virok_wms/feature/routes_page/cubit/routes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/ui.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoutesCubit()..fetchRoutes(),
      child: RoutesPageView(),
    );
  }
}

class RoutesPageView extends StatefulWidget {
  @override
  State<RoutesPageView> createState() => _RoutesPageViewState();
}

class _RoutesPageViewState extends State<RoutesPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пошук маршруту'),
      ),
      body: GridButton(children: [
        SquareButton(
          lable: 'Скан комірки',
          color: const Color.fromRGBO(148, 39, 32, 1),
          onTap: () {
            // Navigate to ScanCellPage
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ScanCellPage()),
            );
          },
        ),
        SquareButton(
          lable: 'Перевірка замовлення',
          color: const Color.fromRGBO(217, 219, 218, 1),
          onTap: () {
            // Navigate to OrderCheckPage
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderCheckPage()),
            );
          },
        ),
      ]),
    );
  }
}

class ScanCellPage extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скан комірки'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: _controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Проскануйте штрихкод',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) async {
                final routeGuid = value;
                _controller.clear();
                final bool res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderPage(routeGuid: routeGuid),
                      ),
                    ) ??
                    false;
                if (res) {
                  focusNode.requestFocus();
                }
              }),
        ),
      ),
    );
  }
}
// class ScanCellPage extends StatelessWidget {
//   TextEditingController _controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Скан комірки'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//               keyboardType: TextInputType.none,
//               autofocus: true,
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Проскануйте штрихкод комірки',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 print(value);
//               },
//               onSubmitted: (value) {
//                 final routeGuid = value;
//                 _controller.clear();

//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => OrderPage(routeGuid: routeGuid),
//                   ),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }

class OrderCheckPage extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Перевірка замовлення'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Введіть номер замовлення',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) async {
              final routeGuid = value;
              _controller.clear();

              final bool res = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderRouteInfoPage(orderId: routeGuid),
                    ),
                  ) ??
                  false;
              if (res) {
                focusNode.requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
