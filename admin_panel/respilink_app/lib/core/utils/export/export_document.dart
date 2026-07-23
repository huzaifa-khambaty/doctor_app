/// Generic, format-agnostic export model.
/// Build one of these and hand it to [AppExporter] — the format-specific
/// service handles serialisation.
library;

class ExportSheet {
  final String name;
  final List<String> headers;
  final List<List<dynamic>> rows;

  const ExportSheet({
    required this.name,
    required this.headers,
    required this.rows,
  });
}

class ExportDocument {
  final String fileName; // without extension
  final List<ExportSheet> sheets;

  const ExportDocument({required this.fileName, required this.sheets});
}
