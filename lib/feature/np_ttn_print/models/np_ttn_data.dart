import 'package:flutter/widgets.dart';

class TtnData {
  final String ttnNumber;
  final String apiKey;
  final String ttnRef;
  final String errorMessage;

  const TtnData({
    required this.ttnNumber,
    required this.apiKey,
    required this.ttnRef,
    required this.errorMessage,
  });

  static const TtnData empty = TtnData(
    ttnNumber: '',
    apiKey: '',
    ttnRef: '',
    errorMessage: '',
  );
  
  bool isNotEmpty() {
    return ttnNumber.isNotEmpty || apiKey.isNotEmpty || ttnRef.isNotEmpty || errorMessage.isNotEmpty;
  }
}
