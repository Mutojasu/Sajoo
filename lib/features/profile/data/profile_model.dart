class Profile {
  String nickname; String gender; DateTime birthDate;
  bool birthTimeUnknown; String? birthTime; String birthPlace;
  String intro; List<String> interests; String? photoPath;
  Profile({
    required this.nickname, required this.gender, required this.birthDate,
    this.birthTimeUnknown=false, this.birthTime, required this.birthPlace,
    this.intro='', this.interests=const [], this.photoPath,
  });
}
