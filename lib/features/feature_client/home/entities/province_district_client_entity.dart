import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProvinceDistrictClientEntity extends Equatable{
  final int districtId;
  final String provinceName;
  final String districtName;

  ProvinceDistrictClientEntity({
    @required this.districtId,
    @required this.provinceName,
    @required this.districtName,
  });

  @override
  List<Object> get props => [districtId, provinceName, districtName];
}