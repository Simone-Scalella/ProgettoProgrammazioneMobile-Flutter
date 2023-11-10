import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ListaPrenotazioniSelfResponse.dart';
/*
Questa classe implementa la schermata che contiene la  lista delle proprie prenotazioni
 */
class ListaPrenotazioniSelf extends StatefulWidget {
  const ListaPrenotazioniSelf({Key? key}) : super(key: key);
  @override
  _ListaPrenotazioniSelfState createState() => _ListaPrenotazioniSelfState();
}

class _ListaPrenotazioniSelfState extends State<ListaPrenotazioniSelf> {
//Questa è la funzione che serve per eliminare un elemento selezionato precedentemente dall'utente
  Future<bool> DeleteFunction(String id,String token) async {
    log("va bene 4");
    var response = await http.post(
        Uri.http("10.0.2.2", "progettolaurea/public/api/authed/gen/pro/code/delete"),
        headers: <String, String>{
          'Accept': "application/json",
          'Authorization' : "Bearer "+token,
        },
        body: <String, String>{
          'id': id,
        }
    );
    if(response.statusCode == 201){
      log('va bene 5');
      return true;
    }
    else{
      log(response.statusCode.toString());
      return false;
    }
  }
//Questa è la funzione che effettua la chiamata al server, restituisce una lista di oggetti definiti precedentemente
  Future<List<ListaPrenotazioniSelfResponse>> getUserData(String chiave) async {
    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/pro/code/self"),
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
  static List<ListaPrenotazioniSelfResponse> parsing(String responseBody){
    log("va bene 2");
    var jsonData = jsonDecode(responseBody);
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
          child: Card(child: FutureBuilder<List<ListaPrenotazioniSelfResponse>>(
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
                        title: Text("Cod. Macchina: "+snapshot.data![index].codice_macchina),
                        subtitle: Text("Inizio: "+snapshot.data![index].inizio),
                        trailing: Text("Durata: "+snapshot.data![index].durata),
                          onLongPress: () {
                            //Qui definisco l'Alert da visualizzare nel caso in cui l'utente vuole cancellare un elemento della lista
                            showDialog(context: context,
                              builder: (BuildContext DialogContext) => AlertDialog(
                                title: const Text('Elimina elemento'),
                                content: const Text("Vuoi eliminare l'elemento selezionato ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(DialogContext, 'Ok');
                                      var can = DeleteFunction(snapshot.data![index].id,token.token);
                                      can.then((value) => (value) ? {
                                        log("va bene 1"),
                                        //Se la funzione esegue tutto correttamente l'utente viene avvisato con un messaggio e l'applicazione torna alla
                                        // schermata precedente
                                        Fluttertoast.showToast(msg: "Operazione completata con successo", fontSize: 18,
                                            timeInSecForIosWeb: 18),
                                        Navigator.pop(context),
                                      }
                                          : Fluttertoast.showToast(msg: "Operazione non riuscita, riprova più tardi ", fontSize: 18,
                                          timeInSecForIosWeb: 85),
                                      );
                                    },
                                    child: const Text('Ok'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Annulla');
                                    },
                                    child: const Text('Annulla'),
                                  )
                                ],
                              ),
                            );
                          }
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