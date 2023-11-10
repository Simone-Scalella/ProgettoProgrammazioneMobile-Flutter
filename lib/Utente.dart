/*
Questa classe rappresenta una parte della risposta che viene data dal server dopo aver accettato la richiesta di login
 */
class User {
  final String CF;
  final String nome_cognome;
  final String tipo_dipendente;
  final String importo_orario_feriale;
  final String importo_orario_regolare;
  final String importo_orario_straordinario;
  final String IBAN;
  final String username;
  final String data_di_nascita;

  User({
    required this.CF,
    required this.nome_cognome,
    required this.tipo_dipendente,
    required this.importo_orario_feriale,
    required this.importo_orario_regolare,
    required this.importo_orario_straordinario,
    required this.IBAN,
    required this.username,
    required this.data_di_nascita,
});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      CF: json['CF'],
      nome_cognome: json['nome_cognome'],
      tipo_dipendente: json['tipo_dipendente'],
      importo_orario_feriale: json['importo_orario_feriale'],
      importo_orario_regolare: json['importo_orario_regolare'],
      importo_orario_straordinario: json['importo_orario_straordinario'],
      IBAN: json['IBAN'],
      username: json['username'],
      data_di_nascita: json['data_di_nascita'],
    );
  }
}