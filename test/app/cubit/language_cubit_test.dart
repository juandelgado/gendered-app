import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/model/language.dart';

void main() {
  group('Language Cubit', () {
    test('sets German as default language', () {
      WidgetsFlutterBinding.ensureInitialized();
      expect(LanguageCubit().state, German());
    });
  });
}
