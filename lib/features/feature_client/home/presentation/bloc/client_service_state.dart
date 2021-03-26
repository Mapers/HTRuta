part of 'client_service_bloc.dart';

abstract class ClientServiceState extends Equatable{
  ClientServiceState();
  @override
  List<Object> get props => [];
}
class DataClientServiceState extends ClientServiceState {
  final TypeServiceEnum typeService;
  DataClientServiceState({@required this.typeService});

  factory DataClientServiceState.initial(){
    return DataClientServiceState(
      typeService: TypeServiceEnum.taxi
    );
  }

  DataClientServiceState copyWith({TypeServiceEnum typeService}){
    return DataClientServiceState(
      typeService: typeService ?? this.typeService
    );
  }

  @override
  List<Object> get props => [typeService];
}
