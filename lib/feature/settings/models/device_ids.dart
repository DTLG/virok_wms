import 'package:equatable/equatable.dart';

class DeviceIds extends Equatable {
  final List<DeviceId> ids;

  const DeviceIds({required this.ids});

  factory DeviceIds.fromJson(Map<String, dynamic> json) => DeviceIds(
      ids: ((json['Devices'] ?? []) as List<dynamic>)
          .map((e) => DeviceId.fromJson(e))
          .toList());

  static const empty = DeviceIds(ids: []);

  @override
  List<Object?> get props => [ids];
}

class DeviceId extends Equatable {
  final String id;

  const DeviceId({required this.id});

  factory DeviceId.fromJson(Map<String, dynamic> json) =>
      DeviceId(id: json['DeviceID'] ?? '');

  static const empty = DeviceId(id: '');
  @override
  List<Object?> get props => [id];
}
