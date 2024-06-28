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
      height: json['height'].toDouble(),
      width: json['width'].toDouble(),
      length: json['length'].toDouble(),
      weight: json['weight'].toDouble(),
    );
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
  static  TtnParams empty =  TtnParams(
    placeNumber: 0,
    height: 0.0,
    width: 0.0,
    length: 0.0,
    weight: 0.0,
  );
}