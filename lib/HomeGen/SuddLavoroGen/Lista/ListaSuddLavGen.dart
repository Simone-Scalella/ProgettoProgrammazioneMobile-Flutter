import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/HomeGen/FullData.dart';
import 'package:esame_flutter_pm/HomeGen/SuddLavoroGen/Lista/Commessa.dart';
import 'package:esame_flutter_pm/HomeGen/SuddLavoroGen/Lista/SuddGenResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
/*
Questa classe implementa la schermata che contiene la  lista delle suddivisioni lavoro di un dipendente
 */
class ListaSuddLavGen extends StatefulWidget {
  const ListaSuddLavGen({Key? key}) : super(key: key);
  @override
  _ListaSuddLavGenState createState() => _ListaSuddLavGenState();
}
//stato del widget
class _ListaSuddLavGenState extends State<ListaSuddLavGen> {

//Questa è la funzione che serve per eliminare un elemento selezionato precedentemente dall'utente
   Future<bool> DeleteFunction(String CF,String commessa,String token) async {
     log('va bene 4');
    var response = await http.post(
        Uri.http("10.0.2.2", "progettolaurea/public/api/authed/gen/suddivisione_lavoro/delete"),
        headers: <String, String>{
          'Accept': "application/json",
          'Authorization' : "Bearer "+token,
        },
        //corpo della Post
        body: <String, String>{
          'commessa': commessa,
          'dipendente': CF,
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
  Future<List<SuddGenResponse>> getUserData(FullData credenziali) async {
    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/suddivisione_lavoro/key/"+credenziali.Input),
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
      //Se l'utente ha precedentemente inserito delle informazioni non corrette viene avvisato con un messaggio d'errore
      Fluttertoast.showToast(msg: "Errore, il codice fiscale non esiste \n Torna indietro e riprova ", fontSize: 18, timeInSecForIosWeb: 100);
      List<SuddGenResponse> ErrDati = [];
      Commessa errCommessa = Commessa(codice_merce: "err");
      SuddGenResponse err = SuddGenResponse(commessa: errCommessa,
          dipendente: "err",
          valore_lavoro: "err",
          quantita_assegnata: "err",
          data_conclusione: "err");
      ErrDati.add(err);
      return ErrDati;
    }
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
          child: Card(child: FutureBuilder<List<SuddGenResponse>>(
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
                        title: Text("Comm. "+snapshot.data![index].commessa.codice_merce+"   Qtà. "+snapshot.data![index].quantita_assegnata),
                        subtitle: Text("Data conclusione: "+snapshot.data![index].data_conclusione),
                        trailing: Text("Valore. "+snapshot.data![index].valore_lavoro),
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
                                      var can = DeleteFunction(snapshot.data![index].dipendente,snapshot.data![index].commessa.codice_merce,info.risposta.token);
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