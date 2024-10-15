import 'package:equatable/equatable.dart';
import 'package:gendered/model/gender.dart';

class Noun with EquatableMixin {
  const Noun({required this.name, required this.gender});

  final String name;
  final Gender gender;

  @override
  List<Object> get props => [name, gender];
}
