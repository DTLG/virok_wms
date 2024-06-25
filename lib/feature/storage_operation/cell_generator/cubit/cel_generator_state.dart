part of 'cel_generator_cubit.dart';

final class CellGeneratorState extends Equatable {
  const CellGeneratorState(
      {this.floor = '01',
      this.range = '01',
      this.rack = '01',
      this.floorRack = '01',
      this.cell = '01',
      this.arrowUp = false});

  final String floor;
  final String range;
  final String rack;
  final String floorRack;
  final String cell;
  final bool arrowUp;

  CellGeneratorState copyWith(
      {String? floor,
      String? range,
      String? rack,
      String? floorRack,
      String? cell,
      bool? arrowUp}) {
    return CellGeneratorState(
        floor: floor ?? this.floor,
        range: range ?? this.range,
        rack: rack ?? this.rack,
        floorRack: floorRack ?? this.floorRack,
        cell: cell ?? this.cell,
        arrowUp: arrowUp ?? this.arrowUp);
  }

  @override
  List<Object?> get props => [floor, range, rack, floorRack, cell, arrowUp];
}
