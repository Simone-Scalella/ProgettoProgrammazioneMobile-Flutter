/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di visualizzazione degli articoli presenti nel magazzino
 */
class ListaResponseMagazzino{
  final String tipo_scorta;

  ListaResponseMagazzino({
    required this.tipo_scorta,
});

  factory ListaResponseMagazzino.fromJson(Map<String,dynamic> json){
    return ListaResponseMagazzino(
        tipo_scorta: json['tipo_scorta']
    );
  }
}