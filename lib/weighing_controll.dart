class WeighingControll {
  int? idControle;
  String lote;
  DateTime data;
  String detalhes;

  WeighingControll({
    this.idControle,
    required this.lote,
    required this.data,
    required this.detalhes
  });
  
  static WeighingControll fromJson(Map<String, Object?> json) => WeighingControll(
      idControle: json['idControle'] as int?,
      lote: json['lote'] as String,
      data: DateTime.parse(json['data'] as String),
      detalhes: json['detalhes'] as String
  );

  Map<String, Object?> toJson() => {
    'idControle': idControle,
    'lote': lote,
    'data': data.toIso8601String(),
    'detalhes': detalhes
  };
}