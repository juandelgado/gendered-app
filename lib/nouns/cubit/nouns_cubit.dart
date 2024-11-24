import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/german_dictionary.dart';
import 'package:gendered/repository/dictionary.dart';
import 'package:meta/meta.dart';

part 'nouns_state.dart';

class NounsCubit extends Cubit<NounsState> {
  NounsCubit({Dictionary? dictionary}) : super(NounsInitial()) {
    _dictionary = dictionary ?? GermanDictionary(); // factory based on language
  }

  late final Dictionary _dictionary;
  final List<Noun> sessionNouns = [];

  Future<void> load() async {
    emit(NounsLoading());

    try {
      final noun = await _dictionary.loadRandomNoun();
      sessionNouns.add(noun);
      emit(NounsLoaded(noun: noun));
    } catch (e) {
      log(e.toString());
      emit(NounsLoadingError());
    }
  }

  Future<void> previous() async {
    if (sessionNouns.isEmpty) return;

    emit(NounsLoading());

    Noun noun;
    if (sessionNouns.length == 1) {
      noun = sessionNouns.first;
    } else {
      noun = sessionNouns.removeLast();
    }

    emit(NounsLoaded(noun: noun));
  }

  Future<void> validate({required Noun noun, required Gender answer}) async {
    if (noun.gender == answer) {
      emit(NounsCorrect(noun: noun));
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      unawaited(load());
    } else {
      emit(NounsIncorrect(noun: noun));
    }
  }
}
