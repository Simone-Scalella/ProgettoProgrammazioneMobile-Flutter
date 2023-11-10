import 'dart:developer';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
/*
Questa è la schermata per l'inserimento di una prenotazione per usare un macchinario
 */
class InserimentoPrenotazione extends StatelessWidget {
//Qui vengono definiti i controller per i TextField, per poter usare il testo che viene inserito dall'utente
  TextEditingController codice_macchina = TextEditingController();
  TextEditingController inizio = TextEditingController();
  TextEditingController durata = TextEditingController();
  TextEditingController ora = TextEditingController();

  @override
  Widget build(BuildContext context) {
//Recupero le credenziali che vengono passate dalla schermata precedente
    final credenziali = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

//Questa è la funziona che esegue la chiamata al server
    Future<bool> getUserData() async {
      var response = await http.post(
          Uri.http("10.0.2.2", "progettolaurea/public/api/authed/gen/pro/code/insert"),
          headers: <String, String>{
            'Accept': "application/json",
            'Authorization' : "Bearer "+credenziali.token,
          },
          //questo è il corpo della Post
          body: <String, String>{
            'codice_macchina': codice_macchina.text,
            'inizio': inizio.text+" "+ora.text,
            'durata': durata.text,
            'dipendente': credenziali.utente.CF
          }
      );
      if(response.statusCode == 201)
        return true;

      else {
        log(response.statusCode.toString());
        return false;
      }
    }
// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
    return Scaffold(
        appBar: AppBar(
          title: Text(credenziali.utente.tipo_dipendente+' Home'),
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
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration:
                          InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)
                                ),
                              ),
                              labelText: 'Codice macchina'
                          ),
                          controller: codice_macchina,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration:
                          InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)
                                ),
                              ),
                              labelText: 'Inizio (aaaa/mm/gg)'
                          ),
                          controller: inizio,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration:
                          InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)
                                ),
                              ),
                              labelText: 'Ora (hh:mm)'
                          ),
                          controller: ora,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration:
                          InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)
                                ),
                              ),
                              labelText: 'Durata (ore)'
                          ),
                          controller: durata,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //Qui, in base al risultato ottenuto dalla chiamata al server, vengono compiute due azioni:
                              //- Se l'esito è postivo viene avvisato l'utente e si torna nella schermata precedente
                              //- Se l'esito è negativo viene avvisato l'utente che ha inserito dei dati non corretti
                              FocusScope.of(context).unfocus();
                              Future<bool> risultato = getUserData();
                              risultato.then((value) => (value) ? {
                                log("va bene 1"),
                                Fluttertoast.showToast(msg: "Operazione completata con successo", fontSize: 18,
                                    timeInSecForIosWeb: 18),
                                Navigator.pop(context),
                              }
                                  : showDialog(context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Errore nell' inserimento"),
                                    content: const Text('Hai compilato male dei campi'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Ok');
                                        },
                                        child: const Text('Ok'),
                                      )
                                    ],
                                  )
                              )
                              );
                            },
                            child: Text('Invia richiesta'),
                          )
                      ),
                    ],
                  ),
                ),
              )
          ),
    );
  }
}