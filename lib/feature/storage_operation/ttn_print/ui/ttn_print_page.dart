import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

String _query = byArcticle;
String _value = '';
const byArcticle = 'get_from_article';
const byBarcode = 'get_from_barcode';

class DataFromApiScreen extends StatefulWidget {
  @override
  _DataFromApiScreenState createState() => _DataFromApiScreenState();
}

class _DataFromApiScreenState extends State<DataFromApiScreen> {
  // URL API
  final String apiUrl =
      'http://192.168.2.50:81/virok_wms/hs/New/get_np_data?DocBarcode=280818202405';

  // Your username and password
  final String username = 'Адмін';
  final String password = 'fnk98#L<pH';

  // Function to fetch data from API
  Future<Map<String, dynamic>> fetchData() async {
    // Encode username and password for Basic Authentication
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    // Perform GET request
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': basicAuth,
      },
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Parse JSON
      return json.decode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data from API'),
      ),
      body: Column(
        children: [
          const ArticleInput(),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No data found');
                } else {
                  final data = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('TTN Number: ${data['ttn_number']}'),
                      Text('API Key: ${data['api_key']}'),
                      Text('TTN Ref: ${data['ttn_ref']}'),
                      Text('Error Message: ${data['ErrorMassage']}'),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleInput extends StatefulWidget {
  const ArticleInput({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ArticleInputState();
  }
}

class _ArticleInputState extends State<ArticleInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool _switchValue = true;
  late String enteredArticle;

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;
    if (_switchValue == false && cameraScaner) {
      focusNode.unfocus();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        autofocus: true,
        onSubmitted: (value) {
          enteredArticle = value;
        },
        decoration: InputDecoration(
            hintText: _switchValue ? 'Введіть артикул' : 'Відскануйте штрихкод',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                cameraScaner
                    ? _switchValue
                        ? const SizedBox()
                        : CameraScanerButton(
                            scan: (value) {
                              context
                                  .read<CheckNomListCubit>()
                                  .getNoms(byBarcode, value);
                              _value = value;
                            },
                          )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() => _switchValue = value);
                      _query = value ? byArcticle : byBarcode;
                    },
                  ),
                ),
              ],
            )),
        // decoration: InputDecoration(
        //     hintText: _switchValue ? 'Введіть артикул' : 'Відскануйте штрихкод',
        //     suffixIcon: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         cameraScaner
        //             ? _switchValue
        //                 ? const SizedBox()
        //                 : CameraScanerButton(
        //                     scan: (value) {
        //                       context
        //                           .read<CheckNomListCubit>()
        //                           .getNoms(byBarcode, value);
        //                       _value = value;
        //                     },
        //                   )
        //             : const SizedBox(),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 2),
        //           child: Switch(
        //             value: _switchValue,
        //             onChanged: (value) {
        //               setState(() => _switchValue = value);
        //               _query = value ? byArcticle : byBarcode;
        //             },
        //           ),
        //         ),
        //       ],
        //     )),
      ),
    );
  }
}
