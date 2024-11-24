// ignore_for_file: one_member_abstracts
import 'package:gendered/model/noun.dart';

abstract class DictionaryRepository {
  Future<Noun?> load({required String search});
}
