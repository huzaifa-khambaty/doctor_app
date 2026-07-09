extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (trim().isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalize every word
  String capitalizeEachWord() {
    if (trim().isEmpty) return this;

    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Convert to title case
  String toTitleCase() {
    return capitalizeEachWord();
  }

  /// Mask an email's local part, e.g. "dr.martinez@gmail.com" -> "dr.m***@gmail.com"
  String maskEmail() {
    final atIndex = indexOf('@');
    if (atIndex <= 0) return this;

    final local = substring(0, atIndex);
    final domain = substring(atIndex);
    final visible = local.length <= 4 ? local : local.substring(0, 4);
    return '$visible***$domain';
  }
}
