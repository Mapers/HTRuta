part of 'choose_routes_client_bloc.dart';

abstract class ChooseRoutesClientState extends Equatable {
  const ChooseRoutesClientState();
  @override
  List<Object> get props => [];
}

class LoadingChooseRoutesClient extends ChooseRoutesClientState {}

class DataChooseRoutesClient extends ChooseRoutesClientState {
  final List<ProvinceDistrictClientEntity> provinceDistricts;
  DataChooseRoutesClient({@required this.provinceDistricts});

  @override
  List<Object> get props => [provinceDistricts];
}
