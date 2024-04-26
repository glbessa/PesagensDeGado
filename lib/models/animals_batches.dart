class AnimalsBatches {
  int? id;
  DateTime entryDate;
  DateTime departureDate;
  String idAnimal;
  String batchName;

  AnimalsBatches({
    this.id,
    required this.entryDate,
    required this.departureDate,
    required this.idAnimal,
    required this.batchName
  });

  static AnimalsBatches fromJson(Map<String, Object?> json) => AnimalsBatches(
      id: json['id'] as int?,
      entryDate: json['entryDate'] as DateTime,
      departureDate: json['departureDate'] as DateTime,
      idAnimal: json['idAnimal'] as String,
      batchName: json['batchName'] as String
  );

  Map<String, Object?> toJson() => {
    'id': this.id,
    'entryDate': this.entryDate,
    'departureDate': this.departureDate,
    'idAnimal': this.idAnimal,
    'batchName': this.batchName
  };

}