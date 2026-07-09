class PreferencesRequest {
  final String seatPreference;
  final String mealType;
  final String genderPreference;
  final bool accessibilityNeeds;
  final String specialRequirements;

  PreferencesRequest({
    required this.seatPreference,
    required this.mealType,
    required this.genderPreference,
    required this.accessibilityNeeds,
    required this.specialRequirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'seat_preference': seatPreference,
      'meal_type': mealType,
      'roommate_gender_preference': genderPreference,
      'accessibility_needs': accessibilityNeeds,
      'special_requirements': specialRequirements,
    };
  }
}
