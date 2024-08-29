import 'package:equatable/equatable.dart';

class ServiceMovingDoc extends Equatable {
  final String number;
  final String date;
  final String cell;

  ServiceMovingDoc({
    required this.number,
    required this.date,
    required this.cell,
  });

  factory ServiceMovingDoc.fromJson(Map<String, dynamic> json) {
    return ServiceMovingDoc(
      number: json['number'] as String,
      date: json['date'] as String,
      cell: json['сell'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'date': date,
      'cell': cell,
    };
  }

  @override
  List<Object?> get props => [number, date, cell];
}
