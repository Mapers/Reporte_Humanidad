import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable{
  final String model;
  final String imei;
  final String type;

  DeviceInfoEntity({
    @required this.model,
    @required this.imei,
    @required this.type,
  });
  dynamic get toJson => {
    'model': model,
    'imei': imei,
    'type': type,
  };

  factory DeviceInfoEntity.fromJson(Map<String, dynamic> dataJson){
    return DeviceInfoEntity(
      model: dataJson['model'],
      imei: dataJson['imei'],
      type: dataJson['type'],
    );
  }
  // dynamic get toStringEntity => jsonEncode(this.toJson);

  @override
  List<Object> get props => [model, imei, type];

}