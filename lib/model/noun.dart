import 'package:equatable/equatable.dart';
import 'package:gendered/model/gender.dart';

class Noun with EquatableMixin {
  const Noun({
    required this.name,
    required this.gender,
    required this.definitions,
  });

  final String name;
  final Gender gender;
  final List<String> definitions;

  @override
  List<Object> get props => [name, gender, definitions];
}
