import 'package:esame_flutter_pm/ResponseLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
Questa classe serve per creare una schermata dove vengono visualizzati i dati personali del dipendente
 */
class AnagraficheDip extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
//Recupero le credenziali che vengono passate dalla schermata precedente
    final dati = ModalRoute.of(context)!.settings.arguments as ResponseLogin;

// Qui vengono definiti tutti i widget che compongono la schermata e che vengono visualizzati dall'utente
   return Scaffold(
     appBar: AppBar(
       title: Text(dati.utente.tipo_dipendente+' Home'),
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
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("username: "+"\n"+
                   dati.utente.username,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("nome e cognome: "+"\n"+
                   dati.utente.nome_cognome,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("data di nascita: "+"\n"+
                   dati.utente.data_di_nascita,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("CF: "+"\n"+
                   dati.utente.CF,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("Categoria di dipendente: "+"\n"+
                   dati.utente.tipo_dipendente,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("Iban: "+"\n"+
                   dati.utente.IBAN,
                   style: TextStyle(fontSize: 17),
                 ),
               ),
             ],
           ),
          ),
         );
  }


}