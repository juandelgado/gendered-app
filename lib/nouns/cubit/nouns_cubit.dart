import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/nouns_repository.dart';
import 'package:meta/meta.dart';

part 'nouns_state.dart';

class NounsCubit extends Cubit<NounsState> {
  NounsCubit({NounsRepository? repository}) : super(NounsInitial()) {
    _repository = repository ??= NounsRepository();
  }

  late final NounsRepository _repository;
  final List<Noun> sessionNouns = [];

  Future<void> load() async {
    emit(NounsLoading());

    try {
      final noun = await _repository.load();
      sessionNouns.add(noun);
      emit(NounsLoaded(noun: noun));
    } catch (e) {
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
