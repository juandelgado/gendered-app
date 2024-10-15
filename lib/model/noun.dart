import 'package:equatable/equatable.dart';
import 'package:gendered/model/genre.dart';

class Noun with EquatableMixin {
  const Noun({required this.name, required this.genre});

  final String name;
  final Genre genre;

  @override
  List<Object> get props => [name, genre];
}
