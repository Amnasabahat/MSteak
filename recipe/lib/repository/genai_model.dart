import 'package:google_generative_ai/google_generative_ai.dart';

class GenAiModel {
  late final GenerativeModel _model;

  GenAiModel() {
    const apiKey = String.fromEnvironment('AIzaSyD2cZS5xDfKe4kHxr8YUNH1B_NpUfZhrb4');

    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: 'AIzaSyD2cZS5xDfKe4kHxr8YUNH1B_NpUfZhrb4');
  }

  Future<GenerateContentResponse> sendMessage(List<Content> content) =>
      _model.generateContent(content);
}
