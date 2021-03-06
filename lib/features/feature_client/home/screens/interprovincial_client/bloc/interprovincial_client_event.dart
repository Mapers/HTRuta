part of 'interprovincial_client_bloc.dart';

abstract class InterprovincialClientEvent extends Equatable {
  const InterprovincialClientEvent();

  @override
  List<Object> get props => [];
}

class LoadInterprovincialClientEvent extends InterprovincialClientEvent {}
