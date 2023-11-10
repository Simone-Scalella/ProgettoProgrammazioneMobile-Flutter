import 'package:esame_flutter_pm/HomePro/TrasferimentoLavoro/ListaSelf/SelfUserTrasferimentoResp.dart';
/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di visualizzare la lista delle proprie richieste di trasferimento lavoro
 */
class SelfTrasferimentoResponse{
  final String id;
  final String codice_trasf;
  final String commessa;
  final SelfUserTrasferimento dipendente;
  final String data_trasferimento;
  final String valore_trasferito;
  final String quantita_trasferita;
  final String confermato;

  SelfTrasferimentoResponse({
    required this.id,
    required this.codice_trasf,
    required this.commessa,
    required this.dipendente,
    required this.data_trasferimento,
    required this.valore_trasferito,
    required this.quantita_trasferita,
    required this.confermato
  });

  factory SelfTrasferimentoResponse.fromJson(Map<String,dynamic> json){
    return SelfTrasferimentoResponse(
        id: json['id'].toString(),
        codice_trasf: json['codice_trasf'].toString(),
        commessa: json['commessa'].toString(),
        dipendente: SelfUserTrasferimento.fromJson(json['dipendente']),
        data_trasferimento: json['data_trasferimento'].toString(),
        valore_trasferito: json['valore_trasferito'].toString(),
        quantita_trasferita: json['quantita_trasferita'].toString(),
        confermato: json['confermato'].toString(),
    );
  }
}