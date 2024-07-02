class TtnParams {
  int placeNumber;
  double height;
  double width;
  double length;
  double weight;

  TtnParams({
    required this.placeNumber,
    required this.height,
    required this.width,
    required this.length,
    required this.weight,
  });

  factory TtnParams.fromJson(Map<String, dynamic> json) {
    return TtnParams(
      placeNumber: json['PlaceNumber'],
      height: _parseDouble(json['height']),
      width: _parseDouble(json['width']),
      length: _parseDouble(json['length']),
      weight: _parseDouble(json['weight']),
    );
  }

  static double _parseDouble(dynamic value) {
    try {
      if (value == null) {
        return 0.0;
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else if (value is int) {
        return value.toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'PlaceNumber': placeNumber,
      'height': height,
      'width': width,
      'length': length,
      'weight': weight,
    };
  }

  static TtnParams empty = TtnParams(
    placeNumber: 0,
    height: 0.0,
    width: 0.0,
    length: 0.0,
    weight: 0.0,
  );

  bool get notEmpty {
    return height != 0.0 || width != 0.0 || length != 0.0 || weight != 0.0;
  }

  String getHint(String label) {
    switch (label) {
      case 'Номер місця':
        return placeNumber.toString();
      case 'Висота':
        return height.toString();
      case 'Ширина':
        return width.toString();
      case 'Довжина':
        return length.toString();
      case 'Вага':
        return weight.toString();
      default:
        return 'Немає даних';
    }
  }
}

List<TtnParams> checkIfEmptyExist(List<TtnParams> ttnParams) {
  List<TtnParams> nonEmptyParams = [];
  for (var param in ttnParams) {
    if (param.notEmpty) {
      nonEmptyParams.add(param);
    }
  }
  return nonEmptyParams;
}
