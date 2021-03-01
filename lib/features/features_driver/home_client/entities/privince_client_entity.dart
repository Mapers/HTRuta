import 'package:equatable/equatable.dart';
class ProvincesClientEntity extends Equatable{
  final int id;
  final String nameProvince;

  ProvincesClientEntity({
    this.id,
    this.nameProvince,
  });

  @override
  List<Object> get props => [id, nameProvince];
}