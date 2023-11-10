import 'dart:convert';
import 'dart:developer';
import 'package:esame_flutter_pm/HomeCuoco/WelcomeCuoco.dart';
import 'package:esame_flutter_pm/HomePro/Messaggi/ListaMessaggi.dart';
import 'package:esame_flutter_pm/HomePro/Prenotazioni/Inserimento/InserimentoPrenotazione.dart';
import 'package:esame_flutter_pm/HomePro/TrasferimentoLavoro/Inserimento/InserimentoTrasferimento.dart';
import 'package:esame_flutter_pm/HomePro/WelcomePro.dart';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:esame_flutter_pm/Utente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Anagrafiche/AnagraficheDipendente.dart';
import 'HomeCuoco/Magazzino/Inserimento/InserimentoAggiornamento.dart';
import 'HomeCuoco/Magazzino/Lista/ListaMagazzino.dart';
import 'HomeCuoco/Magazzino/ListaRichieste/ListaRichiesteMagazzino.dart';
import 'HomeGen/SuddLavoroGen/Inserimento/InserimentoSuddLavoro.dart';
import 'HomeGen/SuddLavoroGen/Lista/CredenzialiComplete.dart';
import 'HomeGen/SuddLavoroGen/Lista/ListaSuddLavGen.dart';
import 'HomeGen/WelcomeGen.dart';
import 'HomePro/Prenotazioni/Lista/ListaPrenotazioniSelf.dart';
import 'HomePro/Prenotazioni/ListaGen/CredenzialiCompletePro.dart';
import 'HomePro/Prenotazioni/ListaGen/ListaPrenotazioniGen.dart';
import 'HomePro/SuddLavPro/SuddLavSelf.dart';
import 'HomePro/TrasferimentoLavoro/ListaSelf/SelfTrasferimentoLavoro.dart';
import 'package:flutter/services.dart';

void main() {
  /*
  Questa è la schermata iniziale, come prima cosa definisco tutte le rotte per navigare verso le altre schermate
   */
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations( [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    title: 'Progetto del corso',
    initialRoute: 'Welcome',
    routes: {
      'Welcome': (context) => MyApp(),
      'Cuoco': (context) => WelcomeCuoco(),
      'ListaMagazzino': (context) => ListaMagazzino(),
      'InserimentoAggiornamento': (context) => InserimentoAggiornamento(),
      'ListaRichiesteMagazzino': (context) => ListaRichiesteMagazzino(),
      'Anagrafiche': (context) => AnagraficheDip(),
      'Generico': (context) => WelcomeGen(),
      'InserisciSuddivisione': (context) => InserimentoSuddLavoro(),
      'CodiceFiscale': (context) => CredenzialiComplete(),
      'ListaSuddivisioniGen': (context) => ListaSuddLavGen(),
      'Professionale': (context) => WelcomePro(),
      'ListaSuddivisioniLavoroSelf': (context) => ListaSuddLav(),
      'ListaPrenotazioniSelf': (context) => ListaPrenotazioniSelf(),
      'InserimentoPrenotazione': (context) => InserimentoPrenotazione(),
      'InserimentoTrasferimentoLavoro': (context) => InserimentoTrasferimentoLavoro(),
      'CredenzialiCompleteProfessionale': (context) => CredenzialiCompletePro(),
      'ListaPrenotazioniGeneriche': (context) => ListaPrenotazioniGen(),
      'ListaTrasferimentiLavoroSelf': (context) => SelfTrasferimentoLavoro(),
      'Messaggi': (context) => ListaMessaggi()
    },
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
//definisco i controller per i campi TextField, mi serviranno per accedere ai caratteri che vengono inseriti al loro interno
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
//Funzione di controllo per i parametri inseriti
  bool controll(String userName, String pass){
    if(userName == "" || pass == "")return false;
    else return true;
  }
/*
Questa è la funzione che viene chiamata dopo la chiamata al server, in base al risultato verranno eseguite diverse azioni:
- Se la chiamata al server ha restituito un messaggio di errore viene avvisato l'utente che non ha compilato correttamente i campi
- Se l'utente ha compilato correttamente i campi viene spostato nella corrispondente schermata di Home in base al suo ruolo
 */
  success(ResponseLogin valore,BuildContext context){
    print("sono qui 1");
    if(valore.utente.tipo_dipendente == "err"){
      showDialog(context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Errore nel Login'),
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
      );
    }
    if(valore.utente.tipo_dipendente  == "cuoco"){
      print("sono qui 2");
      username.clear();
      password.clear();
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, 'Cuoco', arguments: valore);
    }
    if(valore.utente.tipo_dipendente == "gen"){
      print("sono qui 3");
      username.clear();
      password.clear();
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, 'Generico', arguments: valore);
    }
    if(valore.utente.tipo_dipendente == "pro"){
      print("sono qui 4");
      username.clear();
      password.clear();
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, 'Professionale', arguments: valore);
    }
    //Se l'uente non è autorizzato ad usare l'app viene avvisato, come ad esempio il responsabile
    if(valore.utente.tipo_dipendente != "pro" && valore.utente.tipo_dipendente != "gen" && valore.utente.tipo_dipendente != "cuoco" && valore.utente.tipo_dipendente != "err"){
      showDialog(context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Attenzione'),
            content: const Text("Non sei un utente autorizzato ad usare l'app"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                },
                child: const Text('Ok'),
              )
            ],
          )
      );
    }
  }
/*
Questa è la funzione che effettua la chiamata al server, in caso di esito negativo viene restituito un oggetto che serve alla funzione precedente
 per segnalare l'errore all'utente
 */
  Future<ResponseLogin> getUserData() async {
    var response = await http.post(
      Uri.http("10.0.2.2", "progettolaurea/public/api/login"),
      headers: <String, String>{
        'Accept': "application/json"
      },
      body: <String, String>{
        'username': username.text,
        'password': password.text,
      }
    );
    if(response.statusCode == 200)
      log("va bene 1");
    else
      log(response.body);
    return compute(parsing, response.body);
  }
//Questa è la funzione che effettua il parsing della risposta, viene richiamata dalla funzione precedente e lanciata su un background thread
// usando il concetto di Isolate
  static ResponseLogin parsing(String responseBody){
    log("va bene 2");
    try {
      var jsonData = jsonDecode(responseBody);
      ResponseLogin user_info = ResponseLogin.fromJson(jsonData);
      return user_info;
    } catch(e){
      User errUser = User(CF: 'err', nome_cognome: 'err', tipo_dipendente: 'err', importo_orario_feriale: 'err',
          importo_orario_regolare: 'err', importo_orario_straordinario: 'err', IBAN: 'err', username: 'err', data_di_nascita: 'err');
      ResponseLogin errLogin = ResponseLogin(utente: errUser, token: 'err');
      return errLogin;
    }
  }
// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text(
                'Welcome',
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.account_box,
              color: Colors.blueAccent,
              size: 80,),
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
                      labelText: 'UserName'
                  ),
                controller: username,
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
                    labelText: 'Password'
                ),
                controller: password,
                obscureText: true,
              ),
            ),
            Flexible(child:
              Padding(
              padding: EdgeInsets.all(16.0),
               child: ElevatedButton(
                child: Text('Login'),
                onPressed: (){
                  //Viene effettuato un controllo sui dati di input e successivamente vengono chiamate tutte le funzioni descritte precedentemente
                  if(controll(username.text,password.text)) {
                    Future<ResponseLogin> login = getUserData();
                    login.then((value) => success(value, context)
                    );
                  }
                  //Se l'utente non compila i campi le funzioni non vengono chiamate e l'errore viene subito segnalato
                  else Fluttertoast.showToast(msg: "Errore, compila i campi per poter effettuare l'accesso", fontSize: 18, timeInSecForIosWeb: 65);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: Size(260, 50),
                 ),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}