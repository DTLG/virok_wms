import 'package:flutter/material.dart';
import 'package:virok_wms/feature/routes_page/cubit/routes_cubit.dart';
import 'package:virok_wms/feature/routes_page/pages/order_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final TextEditingController _guidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter GUID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.none,
              autofocus: true,
              controller: _guidController,
              decoration: InputDecoration(
                labelText: 'Проскануйте штрихкод маршруту',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final routeGuid = _guidController.text;
                if (routeGuid.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderPage(routeGuid: routeGuid),
                    ),
                  );
                }
                _guidController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guidController
        .dispose(); // Clear the controller when the widget is disposed
    super.dispose();
  }
}
