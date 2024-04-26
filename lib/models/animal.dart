class Animal {
  static const String TableName = "animals";

  String id;
  String? coat;
  DateTime? birthDate;

  Animal ({
    required this.id,
    this.coat,
    this.birthDate
  });

  static Animal fromJson(Map<String, Object?> json) => Animal(
      id: json['id'] as String,
      coat: json['coat'] as String,
      birthDate: json['birthDate'] as DateTime
  );

  Map<String, Object?> toJson() => {
    'id': this.id,
    'coat': this.coat,
    'birthDate': this.birthDate
  };
}