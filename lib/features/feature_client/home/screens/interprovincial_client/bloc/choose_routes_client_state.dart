part of 'choose_routes_client_bloc.dart';

abstract class ChooseRoutesClientState extends Equatable {
  const ChooseRoutesClientState();
  @override
  List<Object> get props => [];
}

class LoadingChooseRoutesClient extends ChooseRoutesClientState {}

class DataChooseRoutesClient extends ChooseRoutesClientState {
  final List<ProvincesClientEntity> provinces;
  DataChooseRoutesClient({this.provinces});
  @override
  List<Object> get props => [];
}
