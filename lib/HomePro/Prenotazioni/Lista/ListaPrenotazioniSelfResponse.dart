/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di visualizzazione della propria lista delle prenotazioni
 */
class ListaPrenotazioniSelfResponse{
  final String id;
  final String dipendente;
  final String codice_macchina;
  final String inizio;
  final String durata;

  ListaPrenotazioniSelfResponse({
    required this.id,
    required this.dipendente,
    required this.codice_macchina,
    required this.inizio,
    required this.durata,
  });

  factory ListaPrenotazioniSelfResponse.fromJson(Map<String,dynamic> json){
    return ListaPrenotazioniSelfResponse(
        id: json['id'].toString(),
        dipendente: json['dipendente'],
        codice_macchina: json['codice_macchina'],
        inizio: json['inizio'].toString(),
        durata: json['durata'].toString()
    );
  }
}