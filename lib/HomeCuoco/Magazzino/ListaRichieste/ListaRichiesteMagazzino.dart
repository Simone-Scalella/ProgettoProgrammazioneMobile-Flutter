import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ListaRichiesteMagazzinoResp.dart';

/*
Questa classe implementa la schermata che contiene la  lista delle richieste di utilizzo degli articoli del magazzino
 */
class ListaRichiesteMagazzino extends StatefulWidget {
  const ListaRichiesteMagazzino({Key? key}) : super(key: key);
  @override
  _ListaRichiesteMagazzinoState createState() => _ListaRichiesteMagazzinoState();
}
//Questo è lo stato del widget
class _ListaRichiesteMagazzinoState extends State<ListaRichiesteMagazzino> {

//Questa è la funzione che effettua la chiamata al server, restituisce una lista di oggetti definiti precedentemente
  Future<List<RichiesteMagazzinoResponse>> getUserData(String chiave) async {
    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/aggiornamento/self"),
      headers: <String, String>{
        'Accept': "application/json",
        'Authorization' : "Bearer "+chiave,
      },
    );
    if(response.statusCode == 200)
      log('va bene 1');
    else
      log(response.body);
    return compute(parsing,response.body);
  }
//Questa è la funzione che effettua il parsing della risposta, viene richiamata dalla funzione precedente e lanciata su un background thread
  static List<RichiesteMagazzinoResponse> parsing(String responseBody){
    log("va bene 2");
    var jsonData = jsonDecode(responseBody);
    List<RichiesteMagazzinoResponse> dati = [];

    for(var u in jsonData){
      print('va bene 3');
      RichiesteMagazzinoResponse dato = RichiesteMagazzinoResponse.fromJson(u);
      dati.add(dato);
    }
    return dati;
  }

  @override
  Widget build(BuildContext context) {
//Recupero le credenziali che vengono passate dalla schermata precedente
    final token = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
    return Scaffold(
        appBar: AppBar(
          title: Text(token.utente.tipo_dipendente+' Home'),
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
          child: Card(child: FutureBuilder<List<RichiesteMagazzinoResponse>>(
              future: getUserData(token.token),
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
                        title: Text(snapshot.data![index].magazzino),
                        subtitle: Text(snapshot.data![index].data),
                        trailing: Text("Qta' : "+snapshot.data![index].quantita),
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