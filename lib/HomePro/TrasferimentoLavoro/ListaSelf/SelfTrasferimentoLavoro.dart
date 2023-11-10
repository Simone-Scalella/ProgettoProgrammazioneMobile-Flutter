import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/HomePro/TrasferimentoLavoro/ListaSelf/SelfUserTrasferimentoResp.dart';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'SelfTrasferimentoResponse.dart';
/*
Questa classe implementa la schermata che contiene la  lista delle proprie richieste di trasferimento lavoro
 */
class SelfTrasferimentoLavoro extends StatefulWidget {
  const SelfTrasferimentoLavoro({Key? key}) : super(key: key);
  @override
  _SelfTrasferimentoLavoroState createState() => _SelfTrasferimentoLavoroState();
}
//stato del widget
class _SelfTrasferimentoLavoroState extends State<SelfTrasferimentoLavoro> {

//Questa è la funzione che serve per eliminare un elemento selezionato precedentemente dall'utente
  Future<bool> DeleteFunction(String codice,String controll,String token) async {
    log('va bene 4');
    if (controll == '0') {
      var response = await http.post(
          Uri.http("10.0.2.2",
              "progettolaurea/public/api/authed/gen/pro/trasferimento_lavoro/delete"),
          headers: <String, String>{
            'Accept': "application/json",
            'Authorization': "Bearer " + token,
          },
          //corpo della Post
          body: <String, String>{
            'codice_trasf': codice,
          }
      );
      if (response.statusCode == 200) {
        log('va bene 5');
        return true;
      }
      else {
        log(response.statusCode.toString());
        return false;
      }
    }
    else
      return false;
  }

//Questa è la funzione che effettua la chiamata al server, restituisce una lista di oggetti definiti precedentemente
  Future<List<SelfTrasferimentoResponse>> getUserData(ResponseLogin credenziali) async {
    var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/pro/trasferimento_lavoro/self"),
      headers: <String, String>{
        'Accept': "application/json",
        'Authorization' : "Bearer "+credenziali.token,
      },
    );
    if(response.statusCode == 200) {
      log("va bene 1");
      return compute(parsing, response.body);
    }
    else {
      log(response.body);
      Fluttertoast.showToast(msg: "Operazione non riuscita, riprova più tardi ", fontSize: 18, timeInSecForIosWeb: 100);
      List<SelfTrasferimentoResponse> ErrDati = [];
      SelfUserTrasferimento errUser = SelfUserTrasferimento(CF: "err", nome_cognome: "err");
      SelfTrasferimentoResponse errResponse = SelfTrasferimentoResponse(id: "err", codice_trasf: "err", commessa: "err", dipendente: errUser, data_trasferimento: "err", valore_trasferito: "err", quantita_trasferita: "err", confermato: "err");
      ErrDati.add(errResponse);
      return ErrDati;
    }
  }
//Questa è la funzione che effettua il parsing della risposta, viene richiamata dalla funzione precedente e lanciata su un background thread
  static List<SelfTrasferimentoResponse> parsing(String responseBody){
    log("va bene 2");
    var jsonData = jsonDecode(responseBody);
    List<SelfTrasferimentoResponse> dati = [];

    for(var u in jsonData){
      log("va bene 3");
      SelfTrasferimentoResponse dato = SelfTrasferimentoResponse.fromJson(u);
      dati.add(dato);
    }
    return dati;
  }

  String confermato(String esito){
    if(esito == '1')return "confermato";
    else return "non confermato";
  }

  @override
  Widget build(BuildContext context) {
//Recupero le credenziali che vengono passate dalla schermata precedente
    final info = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
    return Scaffold(
        appBar: AppBar(
          title: Text(info.utente.tipo_dipendente+' Home'),
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
          child: Card(child: FutureBuilder<List<SelfTrasferimentoResponse>>(
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
                          title: Text("Val. "+snapshot.data![index].valore_trasferito+"  Qtà. "+snapshot.data![index].quantita_trasferita+"  "+"Comm. "+snapshot.data![index].commessa),
                          subtitle: Text("Data: "+snapshot.data![index].data_trasferimento),
                              trailing: Text(confermato(snapshot.data![index].confermato)),
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
                                      var can = DeleteFunction(snapshot.data![index].codice_trasf,snapshot.data![index].confermato,info.token);
                                      can.then((value) => (value) ? {
                                        log("va bene 1"),
                                        //Se la funzione esegue tutto correttamente l'utente viene avvisato con un messaggio e l'applicazione torna alla
                                        // schermata precedente
                                        Fluttertoast.showToast(msg: "Operazione completata con successo", fontSize: 18,
                                            timeInSecForIosWeb: 18),
                                        Navigator.pop(context),
                                      }
                                          : Fluttertoast.showToast(msg: "Operazione non riuscita, non puoi eliminare un elemento confermato ", fontSize: 18,
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