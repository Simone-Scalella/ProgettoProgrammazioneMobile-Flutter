import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/HomeGen/SuddLavoroGen/Lista/SuddGenResponse.dart';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
/*
Questa classe implementa la schermata che contiene la  lista delle proprie suddivisioni lavoro
 */
class ListaSuddLav extends StatefulWidget {
  const ListaSuddLav({Key? key}) : super(key: key);
  @override
  _ListaSuddLavState createState() => _ListaSuddLavState();
}

class _ListaSuddLavState extends State<ListaSuddLav> {
//Questa è la funzione che effettua la chiamata al server, restituisce una lista di oggetti definiti precedentemente
  Future<List<SuddGenResponse>> getUserData(String chiave) async {
    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/suddivisione_lavoro/self"),
      headers: <String, String>{
        'Accept': "application/json",
        'Authorization' : "Bearer "+chiave,
      },
    );
    if(response.statusCode == 200)
      log("va bene 1");
    else
      log(response.body);
    return compute(parsing,response.body);
  }
//Questa è la funzione che effettua il parsing della risposta, viene richiamata dalla funzione precedente e lanciata su un background thread
  static List<SuddGenResponse> parsing(String responseBody){
    log("va bene 2");
    var jsonData = jsonDecode(responseBody);
    List<SuddGenResponse> dati = [];

    for(var u in jsonData){
      log("va bene 3");
      SuddGenResponse dato = SuddGenResponse.fromJson(u);
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
          child: Card(child: FutureBuilder<List<SuddGenResponse>>(
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
                        title: Text("Comm. "+snapshot.data![index].commessa.codice_merce+"   Qtà. "+snapshot.data![index].quantita_assegnata),
                        subtitle: Text("Data conclusione: "+snapshot.data![index].data_conclusione),
                        trailing: Text("Valore. "+snapshot.data![index].valore_lavoro),
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