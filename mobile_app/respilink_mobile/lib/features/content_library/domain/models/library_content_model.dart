import 'package:flutter/material.dart';

/// Mirrors the backend's `type_id`: 1 = pdf, 2 = article, 3 = webinar, 4 = quiz.
enum LibraryContentType { pdf, article, webinar, quiz }

class LibraryContentModel {
  final int id;
  final LibraryContentType type;
  final String category;
  final Color categoryColor;
  final String title;

  /// Assessment-only body copy.
  final String? description;

  /// video / diagnostic thumbnail image (assets/images/...).
  final String? image;

  /// Video-only duration overlay, e.g. "12:45".
  final String? duration;

  /// Guideline-only file size shown inside the document icon box, e.g. "8.4 MB".
  final String? fileSize;

  final String? metaLeft;
  final IconData? metaLeftIcon;
  final String? metaRight;
  final IconData? metaRightIcon;

  /// Assessment/diagnostic call-to-action, e.g. "Start Quiz Now" / "Daily Quiz".
  final String? ctaLabel;

  final bool isBookmarked;

  /// Quiz-only — the quiz to launch when the CTA is tapped.
  final int? quizId;

  /// Pdf-only — the file to download and open when tapped.
  final String? pdfUrl;

  const LibraryContentModel({
    required this.id,
    required this.type,
    required this.category,
    required this.categoryColor,
    required this.title,
    this.description,
    this.image,
    this.duration,
    this.fileSize,
    this.metaLeft,
    this.metaLeftIcon,
    this.metaRight,
    this.metaRightIcon,
    this.ctaLabel,
    this.isBookmarked = false,
    this.quizId,
    this.pdfUrl,
  });
}
