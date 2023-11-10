import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
Questa è la Home del cuoco
 */
class WelcomeCuoco extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Recupero le credenziali passate dalla schermata precedente
    final credenziali = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

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
                  Navigator.pushNamed(context, 'Anagrafiche', arguments: credenziali);
                },
                child: Text('Dati personali'),
              ),
              ElevatedButton(
                onPressed: () {
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