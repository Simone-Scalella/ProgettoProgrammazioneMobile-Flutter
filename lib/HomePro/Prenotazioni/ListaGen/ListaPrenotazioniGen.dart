import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/HomeGen/FullData.dart';
import 'package:esame_flutter_pm/HomePro/Prenotazioni/Lista/ListaPrenotazioniSelfResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
/*
Questa classe implementa la schermata che contiene la  lista generica delle prenotazioni di un macchinario
 */
class ListaPrenotazioniGen extends StatefulWidget {
  const ListaPrenotazioniGen({Key? key}) : super(key: key);
  @override
  _ListaPrenotazioniGenState createState() => _ListaPrenotazioniGenState();
}
//stato del widget
class _ListaPrenotazioniGenState extends State<ListaPrenotazioniGen> {

//Questa è la funzione che effettua la chiamata al server, restituisce una lista di oggetti definiti precedentemente
  Future<List<ListaPrenotazioniSelfResponse>> getUserData(FullData credenziali) async {

//parametro da inserire all'interno della richiesta al server
    final queryParameters = {
      'codice_macchina' : credenziali.Input
    };

    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/pro/macchine_pubbliche/key",queryParameters),
      headers: <String, String>{
        'Accept': "application/json",
        'Authorization' : "Bearer "+credenziali.risposta.token,
      },
    );
    if(response.statusCode == 200) {
      log("va bene 1");
      return compute(parsing, response.body);
    }
    else {
      log(response.body);
      //l'utente viene avvisato se inserisce dei dati che non sono corretti
      Fluttertoast.showToast(msg: "Errore, il codice della macchina non esiste \n Torna indietro e riprova ", fontSize: 18, timeInSecForIosWeb: 100);
      ListaPrenotazioniSelfResponse errResp = ListaPrenotazioniSelfResponse(id: "err", dipendente: "err", codice_macchina: "err", inizio: "err", durata: "err");
      List<ListaPrenotazioniSelfResponse> errCoda = [];
      errCoda.add(errResp);
      return errCoda;
    }
  }
//Questa è la funzione che effettua il parsing della risposta, viene richiamata dalla funzione precedente e lanciata su un background thread
  static List<ListaPrenotazioniSelfResponse> parsing(String responseBody){
    log("va bene 2");
    var jsonData = jsonDecode(responseBody)['coda'];
    List<ListaPrenotazioniSelfResponse> dati = [];

    for(var u in jsonData){
      log("va bene 3");
      ListaPrenotazioniSelfResponse dato = ListaPrenotazioniSelfResponse.fromJson(u);
      dati.add(dato);
    }
    return dati;
  }

  @override
  Widget build(BuildContext context) {
//Recupero le credenziali che vengono passate dalla schermata precedente
    final info = ModalRoute.of(context)!.settings.arguments as FullData;

// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
    return Scaffold(
        appBar: AppBar(
          title: Text(info.risposta.utente.tipo_dipendente+' Home'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Colors.white,Colors.amber]
              )
          ),
          child: Card(child: FutureBuilder<List<ListaPrenotazioniSelfResponse>>(
              future: getUserData(info),
              builder: (context, snapshot){
                if(snapshot.data == null){
                  return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [Colors.white,Colors.amber]
                        )
                    ),
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                }
                else return ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text("Inizio: "+snapshot.data![index].inizio),
                        subtitle: Text("Cod. Macchina: "+snapshot.data![index].codice_macchina),
                        trailing: Text("Durata: "+snapshot.data![index].durata),
                      );
                    }
                );
              }
          ),
          ),
        )
    );
  }
}