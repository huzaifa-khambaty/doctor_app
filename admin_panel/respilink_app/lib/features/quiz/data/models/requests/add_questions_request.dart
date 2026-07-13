import 'dart:typed_data';

class AddQuestionsRequest {
  final List<QuestionRequest> questions;

  const AddQuestionsRequest(this.questions);

  // Used for the JSON-only path (no images). Image bytes are sent via
  // multipart FormData in the data source when present.
  Map<String, dynamic> toJson() => {
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}

class QuestionRequest {
  final int? id; // existing question ID required by backend on update
  final String questionText;
  final Uint8List? imageBytes;
  final String? imageName;
  final String? existingImagePath; // server-side path to preserve on update
  final bool isMultiple;
  final int order;
  final List<OptionRequest> options;

  const QuestionRequest({
    this.id,
    required this.questionText,
    this.imageBytes,
    this.imageName,
    this.existingImagePath,
    required this.isMultiple,
    required this.order,
    required this.options,
  });

  // imageBytes intentionally excluded — handled by multipart in data source.
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'question_text': questionText,
    'is_multiple': isMultiple,
    'order': order,
    'options': options.map((o) => o.toJson()).toList(),
  };
}

class OptionRequest {
  final String optionText;
  final bool isCorrect;
  final String? explanation;
  final int order;

  const OptionRequest({
    required this.optionText,
    required this.isCorrect,
    this.explanation,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
    'option_text': optionText,
    'is_correct': isCorrect,
    if (explanation != null && explanation!.isNotEmpty)
      'explanation': explanation,
    'order': order,
  };
}
