import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gendered/model/genre.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/nouns_repository.dart';
import 'package:meta/meta.dart';

part 'nouns_state.dart';

class NounsCubit extends Cubit<NounsState> {
  NounsCubit({NounsRepository? repository}) : super(NounsInitial()) {
    _repository = repository ??= NounsRepository();
  }

  late final NounsRepository _repository;

  Future<void> load() async {
    emit(NounsLoading());

    try {
      final noun = await _repository.load();
      emit(NounsLoaded(noun: noun));
    } catch (e) {
      emit(NounsLoadingError());
    }
  }

  Future<void> validate({required Noun noun, required Genre answer}) async {
    if (noun.genre == answer) {
      emit(NounsCorrect(noun: noun));
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      unawaited(load());
    } else {
      emit(NounsIncorrect(noun: noun));
    }
  }
}
