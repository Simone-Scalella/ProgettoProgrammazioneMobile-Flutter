/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di visualizzazione dei messaggi di un dipendente
 */
class ListaMessaggiResponse{
  final String id;
  final String dipendente;
  final String messaggio;

  ListaMessaggiResponse({
    required this.id,
    required this.dipendente,
    required this.messaggio,
  });

  factory ListaMessaggiResponse.fromJson(Map<String,dynamic> json){
    return ListaMessaggiResponse(
        id: json['id'].toString(),
        dipendente: json['dipendente'],
      messaggio: json['messaggio'],
    );
  }
}