enum QueryCategory {
  clinical('Clinical'),
  technical('Technical'),
  billing('Billing'),
  other('Other');

  final String label;

  const QueryCategory(this.label);
}
