/*
Questa classe rappresenta una parte della risposta che viene data dal server dopo aver accettato la richiesta
 */
class SelfUserTrasferimento{
  final String CF;
  final String nome_cognome;

  SelfUserTrasferimento({
    required this.CF,
    required this.nome_cognome,
  });

  factory SelfUserTrasferimento.fromJson(Map<String,dynamic> json){
    return SelfUserTrasferimento(
      CF: json['CF'],
      nome_cognome: json['nome_cognome'],
    );
  }
}