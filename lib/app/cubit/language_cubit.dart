import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gendered/model/language.dart';

class LanguageCubit extends Cubit<Language> {
  LanguageCubit() : super(German());

  final FlutterTts flutterTts = FlutterTts();
  bool _init = false;

  Future<void> textToSpeech({required String text}) async {
    if (!_init) {
      await _initTts();
    }

    await flutterTts.speak(text);
  }

  Future<void> _initTts() async {
    _init = true;
    if (Platform.isIOS) {
      await flutterTts.setSharedInstance(true);
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions
              .interruptSpokenAudioAndMixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }
    await flutterTts.setLanguage(state.locale.toLanguageTag());
  }
}
