class CattleBatch {
  static const String TableName = "cattle_batches";

  String batchName;
  String? description;

  CattleBatch ({
    required this.batchName,
    this.description
  });

  static CattleBatch fromJson(Map<String, Object?> json) => CattleBatch(
    batchName: json['batchName'] as String,
    description: json['description'] as String
  );

  Map<String, Object?> toJson() => {
    'batchName': this.batchName,
    'description': this.description
  };
}