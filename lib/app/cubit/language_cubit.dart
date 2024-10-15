import 'package:bloc/bloc.dart';
import 'package:gendered/model/language.dart';

class LanguageCubit extends Cubit<Language> {
  LanguageCubit() : super(German());
}
