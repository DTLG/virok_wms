import 'package:flutter/material.dart';
import 'package:virok_wms/feature/np_ttn_print/models/ttn_params.dart';
import 'package:virok_wms/feature/np_ttn_print/ui/np_ttn_print_page.dart';

class ParamRow extends StatelessWidget {
  final String label;
  final String measure;
  final bool isEnabled;
  TtnParams param;

  ParamRow({
    Key? key,
    required this.label,
    required this.param,
    required this.isEnabled,
    required this.measure,
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String hintText = param.getHint(label);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Flexible(
          child: TextFormField(
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            validator: (value) {
              if (hintText != "0.0" || (value != null && value.isNotEmpty)) {
                param = changeParam(param, controller.text, measure);
                return null;
              }
              return 'Поле має бути заповненим';
            },
            keyboardType: TextInputType.number,
            // onEditingComplete: () {
            //   param = changeParam(param, controller.text, measure);
            // },
          ),
        ),
      ],
    );
  }
}
