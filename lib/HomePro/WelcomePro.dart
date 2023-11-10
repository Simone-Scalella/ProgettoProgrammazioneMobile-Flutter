import 'dart:async';
import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
/*
Questa è la Home del dipendente professionale
 */
class WelcomePro extends StatefulWidget {

  const WelcomePro({Key? key}) : super(key: key);
  @override
  _WelcomeProState createState() => _WelcomeProState();

}
//stato del widget
class _WelcomeProState extends State<WelcomePro> {
  bool _verifica = true;

  @override
  Widget build(BuildContext context) {
    //Recupero le credenziali passate dalla schermata precedente
    final credenziali = ModalRoute.of(context)!.settings.arguments as ResponseLogin;
    //definisco una variabile di tipo Timer
    Timer? crono;

    //Questa è la funzione che effettua la chiamata al server
    getUserData(String chiave) async {
      var response = await http.get(Uri.http("10.0.2.2","progettolaurea/public/api/authed/gen/pro/messaggi/self/NoEliminazione"),
        headers: <String, String>{
          'Accept': "application/json",
          'Authorization' : "Bearer "+chiave,
        },
      );
      /*
      Ogni 10 secondi viene fatta una richiesta al server per verificare se ci sono messaggi da leggere, se la risposta è positiva viene modificato il
      valore della variabile _verifica che viene usata per assegnare il colore al bottone dei messaggi, viene richiamato il metodo setState che aggiorna
      lo stato del widget e fa ripartire il timer dei 10 secondi
       */
      crono = Timer.periodic(Duration(seconds: 10), (_) {
        crono?.cancel();
        if(response.statusCode == 200){
          print("Ci sono messaggi");
          setState(() {
            _verifica = false;
          });
        }
        else {
          print("non ci sono messaggi");
          setState(() {
            _verifica = true;
          });
        }
      });
    }
//qui viene chiamata la funzione per fare la richiesta al server
    getUserData(credenziali.token);

//Questa è la funzione personalizzata del tasto back, quando viene premuto viene visualizzato un AlertDialog
    Future<bool> _onWillPop() async {
      return(await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Vuoi uscire ? '),
            content: const Text("Premi il tasto Logout per uscire dall'app"),
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
      ) ?? false;
    }
// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente,
// premendo su uno dei bottoni ci si sposta in un'altra schermata e vengono passate le credenziali come argomento
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: ScrollPhysics(),
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ListaMagazzino', arguments: credenziali);
                },
                child: Text('Lista oggetti del magazzino'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'InserimentoAggiornamento', arguments: credenziali);
                },
                child: Text('Richiesta oggetti del magazzino'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ListaRichiesteMagazzino', arguments: credenziali);
                },
                child: Text('Lista delle richieste fatte'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ListaSuddivisioniLavoroSelf', arguments: credenziali);
                },
                child: Text('Visualizza le tue suddivisione lavoro'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'CredenzialiCompleteProfessionale', arguments: credenziali);
                },
                child: Text('Visualizza le prenotazioni generiche di un macchinario'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ListaPrenotazioniSelf', arguments: credenziali);
                },
                child: Text('Visualizza le tue prenotazioni'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'InserimentoPrenotazione', arguments: credenziali);
                },
                child: Text('Inserisci una prenotazione'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'InserimentoTrasferimentoLavoro', arguments: credenziali);
                },
                child: Text('Inserisci un trasferimento del tuo lavoro'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ListaTrasferimentiLavoroSelf', arguments: credenziali);
                },
                child: Text('Visualizza i tuoi trasferimenti di lavoro'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: (_verifica ? Colors.blueAccent : Colors.redAccent)
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'Messaggi', arguments: credenziali);
                },
                child: Text('Messaggi'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'Anagrafiche', arguments: credenziali);
                },
                child: Text('Dati personali'),
              ),
              ElevatedButton(
                onPressed: () {
                  crono?.cancel();
                  Navigator.pop(context);
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
