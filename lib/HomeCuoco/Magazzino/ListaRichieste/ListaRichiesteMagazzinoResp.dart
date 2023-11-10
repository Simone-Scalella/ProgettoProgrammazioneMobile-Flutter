/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di visualizzazione delle richieste di utilizzo di articoli del magazzino
 */
class RichiesteMagazzinoResponse{
  final String id;
  final String dipendente;
  final String data;
  final String quantita;
  final String magazzino;

  RichiesteMagazzinoResponse({
    required this.id,
    required this.dipendente,
    required this.data,
    required this.quantita,
    required this.magazzino,
  });

  factory RichiesteMagazzinoResponse.fromJson(Map<String,dynamic> json){
    return RichiesteMagazzinoResponse(
        id: json['id'].toString(),
        dipendente: json['dipendente'],
        data: json['data'],
        quantita: json['quantita'].toString(),
        magazzino: json['magazzino']
    );
  }
}