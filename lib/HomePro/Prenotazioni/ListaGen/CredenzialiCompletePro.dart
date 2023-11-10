import 'package:esame_flutter_pm/HomeGen/FullData.dart';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
/*
Questa classe definisce la schermata che serve per far inserire all'utente un'informazione necessaria per poter fare successivamente la richiesta al server
 */
class CredenzialiCompletePro extends StatelessWidget {
//Qui vengono definiti i controller per i TextField, per poter usare il testo che viene inserito dall'utente
  TextEditingController cod_macchina = TextEditingController();

  //Funzione di controllo per il parametro inserito
  bool controllCod(String Cod){
    if(Cod == "") return false;
    else return true;
  }

  @override
  Widget build(BuildContext context) {
    //Recupero le credenziali che vengono passate dalla schermata precedente
    final credenziali = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

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
                      labelText: 'Codice Macchina'
                  ),
                  controller: cod_macchina,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(controllCod(cod_macchina.text)) {
                        FullData info = FullData(
                            risposta: credenziali, Input: cod_macchina.text);
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(
                            context, 'ListaPrenotazioniGeneriche',
                            arguments: info);
                      }
                      //l'utente viene avvisato se inserisce dei dati non corretti
                      else Fluttertoast.showToast(msg: "Errore, compila correttamente il campo per poter proseguire", fontSize: 18, timeInSecForIosWeb: 65);
                    },
                    child: Text('Invio'),
                  )
              ),
            ],
          )
      ),
    );
  }
}