class Weighing {
  int? idPesagem;
  int idControle;
  String identAnimais;
  int quantAnimais;
  double pesoAnimais;

  Weighing({
    this.idPesagem,
    required this.idControle,
    required this.identAnimais,
    required this.quantAnimais,
    required this.pesoAnimais
  });

  static Weighing fromJson(Map<String, Object?> json) => Weighing(
      idPesagem: json['idPesagem'] as int?,
      idControle: json['idControle'] as int,
      identAnimais: json['identificacaoAnimais'] as String,
      quantAnimais: json['quantidadeAnimais'] as int,
      pesoAnimais: json['pesoAnimais'] as double
  );

  Map<String, Object?> toJson() => {
    'idPesagem': idPesagem,
    'idControle': idControle,
    'identificacaoAnimais': identAnimais,
    'quantidadeAnimais': quantAnimais,
    'pesoAnimais': pesoAnimais
  };
}