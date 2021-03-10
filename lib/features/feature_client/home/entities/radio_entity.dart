import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RadioEntity extends Equatable{
  final int quantity;
  RadioEntity({
    @required this.quantity,
  });

  @override
  List<Object> get props => [quantity];
}