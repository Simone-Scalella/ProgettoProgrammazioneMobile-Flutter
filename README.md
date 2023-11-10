# ProgettoProgrammazioneMobile-Flutter

## Introduzione
L’applicazione sviluppata per questo progetto rappresenta una parte di un intero sistema, composto da server, database, applicazioni mobile e desktop; l'applicazione sviluppata serve per migliorare il lavoro dei dipendenti dell’azienda d’interesse, permette loro di svolgere con ulteriore semplicità operazioni quotidiane e permette di raccogliere le informazioni utili per il responsabile dell’azienda.

## Analisi degli obiettivi
L'applicazione ha come target i tre tipi di dipendenti dell’azienda, che sono i dipendenti professionali, quelli generici e i cuochi. I dipendenti non devono effettuare nessuna registrazione, esistono già all’interno del sistema, quindi ogni utente deve effettuare il login, così accederà ad una home corrispondente alla tipologia di appartenenza. Nel caso in cui le credenziali inserite siano sbagliate l’utente verrà avvisato, inoltre, l’applicazione riconosce altri tipi di utenti non autorizzati ad usare l’applicazione, come ad esempio il responsabile che esiste nel sistema ma non può usare l’applicazione. Una volta effettuato il Login l’utente si trova nella sua home: 

1. Il cuoco può interagire con il magazzino, l’applicazione gli permette di visualizzare gli oggetti disponibili nel magazzino, all’interno di una lista. Il dipendente può compilare una form all’interno della quale inserisce le informazioni necessarie per poter utilizzare un determinato oggetto, in caso di errore nella compilazione l’utente deve essere avvisato, ad esempio se l’oggetto richiesto non esiste nel magazzino, inoltre, l’applicazione permette all’utente di visualizzare una lista contente tutte le proprie richieste fatte per utilizzare oggetti del magazzino. Il dipendente per tornare indietro deve necessariamente cliccare sul tasto Logout, in caso contrario viene avvisato della necessità di compiere quest’azione, e infine, può accedere ad una schermata dove vengono visualizzati tutti i suoi dati anagrafici.
   
2. Il dipendente generico possiede tutte le funzionalità del dipendente cuoco, in più questo dipendente può visualizzare le suddivisioni lavoro di un particolare dipendente all’interno di una lista, sempre dentro questa lista può anche eliminare una suddivisione lavoro di un dipendente dopo aver confermato di voler compiere tale azione, se il dipendente cercato non esiste l’utente viene avvisato dell’errore,riceve conferma se l’operazione di eliminazione è andata a buon fine. Infine il dipendente può compilare una form per inserire una suddivisione lavoro ad un dipendente professionale.

3. Il dipendente professionale possiede tutte le funzionalità del dipendente cuoco, in più questo dipendente può visualizzare in una lista tutte le sue prenotazioni per utilizzare una macchina pubblica,può eliminare una prenotazione e in una schermata specificando il nome del macchinario d’interesse, può visualizzare tutte le prenotazioni fatte dagli altri dipendenti. Quando un dipendente cancella una prenotazione il server genera dei messaggi per tutti i dipendenti professionali, questi messaggi servono per avvisarli. Nella home del dipendente professionale esiste un cronometro che ogni 10 secondi fa una richiesta al server, se la richiesta `e positiva lui cambia il colore del bottone ”messaggi”, in questo modo l’utente è avvisato dei cambiamenti, quando l’utente entra nella schermata dei messaggi, visualizza una lista con tutti i messaggi che gli sono stati assegnati, successivamente dopo aver visualizzato i messaggi il server li cancella. Inoltre il dipendente può compilare una form che gli permette di inserire una prenotazione per una macchina pubblica. Il dipendente può visualizzare una lista con tutte le suddivisioni lavoro a lui assegnate, può visualizzare in una lista tutti i trasferimenti di lavoro fatti e il loro stato ( confermato o non confermato ), all’interno di questa lista se l’elemento non è stato confermato è possibile eliminarlo dopo aver confermato l’intenzione di voler compiere tale azione. Possiede una schermata per inserire un nuovo trasferimento di lavoro.

## Approccio allo sviluppo

La realizzazione dell’applicazione parte con la raccolta dei requisiti, fondamentali per lo sviluppo. Inoltre, bisognava sviluppare l’applicazione considerando che il server e il relativo database erano già stati implementati, quindi, si è partito con lo sviluppo delle singole schermate che avrebbero costituito l’applicazione, dividendo ogni componente in un sottoproblema.
Sono stati implementati i layout e le funzionalità richieste. A seguire le varie componenti sono state unificate secondo la logica dei requisiti.
Per la realizzazione dell’applicazione sono state utilizzate le documentazioni Flutter e Dart, più altre informazioni reperite su siti di terzi (ad esempio stackoverflow etc...), in questo modo è stato possibile superare le varie problematiche che si sono verificate in fase di sviluppo.

## Analisi dei requisiti

### Requisiti funzionali

Dopo aver dato una breve introduzione alle funzionalità della nostra applicazione, passiamo ora all’analisi funzionale nel dettaglio.
Partiamo descrivendo la schermata iniziale, quella di Login. A questo punto l’utente deve inserire le credenziali, cioè, username e password, i casi possono essere:
* L’utente esiste all’interno del server ma non rientra in una delle categorie specificate (’pro’,’gen’,’cuoco’) quindi si avvisa questa persona che non può proseguire nell’utilizzo dell’applicazione. 
* L’utente esiste all’interno del server e rientra in una delle categorie specificate, quindi, l’applicazione prosegue visualizzando la corrispondente home. 
* L’utente inserisce delle credenziali sbagliate quindi viene avvisato dell’errore. Se ci sono altri tipi di errori l’utente viene comunque avvisato.
* L’operazione di login ha avuto successo e otteniamo dal server una risposta, che contiene delle informazioni sull’utente e un token ( una stringa ) che sarà necessario per fare tutte le successive richieste al server.

**Inserimento:** sono tutte le schermate che permettono all’utente di inserire dei dati, i quali tramite una POST vengono inviati al server, validati ed inseriti all’interno del DB; ci sono diverse schermate per l’inserimento, quelle per inserire una richiesta per l’utilizzo di un oggetto del magazzino, quella per inserire una suddivisione lavoro, quella per inserire la prenotazione di un macchinario e quella per inserire un trasferimento di lavoro, alcune di queste schermate sono accessibili da tutti, altre solo da specifici dipendenti. Se l’inserimento è andato a buon fine l’applicazione ritorna alla schermata iniziale e l’utente viene avvisato.

**Segnalazione Errori:** gli errori all’interno dell'applicazione vengono gestiti soprattutto con messaggi che richiedono interazioni. Quindi se durante la compilazione di una form vengono inseriti campi che non sono corretti come ad esempio un oggetto nel magazzino che non esiste, il server risponde alla richiesta con un codice di errore e l’applicazione lo gestisce. Per alcuni tipi di errori come ad esempio il codice fiscale, avendo una lunghezza fissa, se tale lunghezza non è rispettata non viene neanche fatta una richiesta al server, viene direttamente avvisato l’utente. I controlli vengono fatti anche sul Login e sui campi da compilare per visualizzare delle liste specifiche.

**Liste specifiche:** queste schermate contengono il risultato di particolari chiamate GET a cui vengono passati dei parametri inseriti dall’utente. Sono realizzate mediante l’utilizzo di una List view, un esempio di tali schermate sono appunto quella che visualizza le suddivisioni lavoro del dip. generico e quella che visualizza le prenotazioni di un macchinario del dip. professionale.

**Liste generiche:** queste schermate invece contengono il risultato di chiamate GET fatte al server a cui non vengono passati parametri,sono realizzate mediante l’utilizzo di una List view, come ad esempio la lista degli oggetti contenuti nel magazzino.

**Eliminazione:** E’ un messaggio  che viene generato in seguito ad un LongClick da parte dell’utente sugli elementi di alcune liste, sia generiche,che specifiche. In seguito dopo aver confermato l’intenzione di voler eliminare l’elemento viene fatta una richiesta di tipo POST al server, in questo caso l’esito è necessariamente positivo in quanto nella post ci sono informazioni prese direttamente dal server, quindi viene avvisato l’utente e l’elemento cancellato viene segnato.

**Anagrafiche:** questa è una semplice schermata utile per visualizzare le informazioni personali del dipendente.

**LogOut:** il pulsante di Logout è l’unico che l’utente ha per tornare nella schermata di Login, la funzione del tasto Back è stata sovrascritta per ottenere questo risultato, infatti, se l’utente nella home preme il tasto Back viene sempre visualizzato un messaggio che lo avvisa della necessità di premere il tasto Logout se si intende effettuare la disconnessione. Questa scelta è stata fatta per evitare che l’utente si disconnetta premendo accidentalmente o ripetutamente il tasto Back, che invece, mantiene la sua funzione nelle altre schermate.

**Messaggi:** per implementare una primitiva della notifica, cioè, per avvisare l’utente quando sono state modificate delle prenotazioni, è stato implementato un cronometro che, all’interno della home del dip. professionale effettua ogni 10 secondi una richiesta al server, se l’esito è positivo significa che ci sono dei messaggi per questo utente, altrimenti significa che l’utente non ha ricevuto dei messaggi, in base a questo risultato viene cambiato il colore del tasto messaggi, che diventa rosso per esito positivo, altrimenti blu.

### Requisiti non funzionali

I requisiti non funzionali sono:

**Server:** sviluppato con il framework laravel 8, usando il linguaggio PHP,
questo è lo strumento utilizzato per implementare il lato server del nostro sistema, quindi, per poter usare l’applicazione si rende necessario installare xamp per ottenere sulla propria macchina l’ambiente PHP necessario. Successivamente, bisogna copiare nella cartella HTDOCS il progetto del server.
Attualmente, il server gira in locale, su localhost, una volta spostato su un server dedicato bisogna cambiare un’istruzione tra le dipendenze necessarie per fare le richieste HTTP.

**Database:** sviluppato usando mysql e sql, il database è stato implementato da zero,abbiamo costruito tutte le tabelle, le loro relazioni e i vari vincoli.
Il database attualmente è popolato con informazioni di prova, cioè, le caratteristiche sono reali ma il contenuto è inventato, ad esempio i nomi o le date di
nascita sono inventate. Il server è l’unica applicazione che si interfaccia direttamente con il DB, tutte le richieste di lettura, scrittura, eliminazione e login
fatte per il DB vengono gestite prima dal server, così come anche le risposte che contengono le informazioni del DB.

## Architettura

Ci sono quattro cartelle principali:

1. **Anagrafiche:** all’interno di questa cartella c'è la classe che implementa la schermata per la visualizzazione delle anagrafiche di un dipendente.

2. **HomeCuoco:** all’interno di questa cartella ci sono tutte le classi per la gestione del magazzino e la sua home.

3. **HomeGen:** all’interno di questa cartella ci sono tutte le classi per la gestione delle suddivisioni lavoro e la sua home.

4. **HomePro:** all’interno di questa cartella ci sono tutte le classi per la gestione dei messaggi, prenotazione di un macchinario, gestire i trasferimenti lavoro, la lista delle suddivisioni lavoro e la sua home.

## UI
Riporto di seguito il diagramma dei casi d’uso e le schermate che verranno visualizzate durante l’utilizzo dell’applicazione, considerando tutte le operazioni che possono essere svolte.

### Diagramma dei casi d’uso
![Casi d'uso](https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Kotlin/blob/main/KotlinFoto/CasiUsoMobile.png)

### Login, errori di autenticazione, Log Success
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Login/Log.png" width="175" alt="Immagine 1">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Login/LogErr1.png" width="175" alt="Immagine 2">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Login/LogErr2.png" width="175" alt="Immagine 3">
</p>

### Home del cuoco, logout e anagrafiche
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeCuoco/HomeCuoco.png" width="175" alt="Immagine 4">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/onBackPressed.png" width="175" alt="Immagine 5">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Anagrafiche.png" width="175" alt="Immagine 6">
</p>

### Liste del magazzino, inserimento ed errore nell'inserimento
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Magazzino/ListaRichieste.png" width="175" alt="Immagine 7">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Magazzino/ListaMagazzino.png" width="175" alt="Immagine 8">
</p>
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Magazzino/InserimentoMagazzino.png" width="175" alt="Immagine 9">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/Magazzino/ErrInserimento.png" width="175" alt="Immagine 10">
</p>

### Home del dipendente generico, inserimento di una suddivisione lavoro ed errore
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/HomeGen.png" width="175" alt="Immagine 11">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/Inserimento/InserimentoSudd.png" width="175" alt="Immagine 12">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/Inserimento/InsErr.png" width="175" alt="Immagine 13">
</p>

### Lista delle suddivisione lavoro, eliminazione di un elemento
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/CFSudd.png" width="175" alt="Immagine 14">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/ListaSudd.png" width="175" alt="Immagine 15">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/EliminaSudd.png" width="175" alt="Immagine 16">
</p>
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/EliminazioneOk.png" width="175" alt="Immagine 17">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/ErrCF.png" width="175" alt="Immagine 18">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomeGen/SuddLavoro/Screenshot_1630706731.png" width="175" alt="Immagine 19">
</p>

### Home del dipendente professionale e lista delle suddivisioni lavoro
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/HomeMess.png" width="175" alt="Immagine 20">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/HomeNoMess.png" width="175" alt="Immagine 21">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/ListeSuddPro.png" width="175" alt="Immagine 22">
</p>

### Inserimento di un trasferimento di lavoro, liste dei trasferimenti ed eliminazione e lista dei messaggi.
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/TrasferimentoLavoro/ListaTrasf.png" width="175" alt="Immagine 23">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/TrasferimentoLavoro/InsTrasf.png" width="175" alt="Immagine 24">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/TrasferimentoLavoro/EliminaTrasf.png" width="175" alt="Immagine 25">
</p>
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/TrasferimentoLavoro/ElimErr.png" width="175" alt="Immagine 26">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/ListaMessaggi.png" width="175" alt="Immagine 27">
</p>

### Inserimento prenotazione di un macchinario ed errore
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/InsPreno.png" width="175" alt="Immagine 26">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/InserimentoOKPreno.png" width="175" alt="Immagine 27">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/ErrInsPreno.png" width="175" alt="Immagine 28">
</p>

### Liste prenotazioni, generiche e personali
<p align="center">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/CodMacchina.png" width="175" alt="Immagine 29">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/ListaPrenotazioneGen.png" width="175" alt="Immagine 30">
</p>
<p align="center">
   <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/MyPrenotazioni.png" width="175" alt="Immagine 31">
  <img src="https://github.com/Simone-Scalella/ProgettoProgrammazioneMobile-Flutter/blob/main/FlatterFoto/HomePro/Prenotazioni/ListaPrenErr.png" width="175" alt="Immagine 32">
</p>

## Sviluppo

In questa sezione descriverò brevemente gli aspetti più interessanti dello sviluppo dell'applicazione:

* **Programmazione asincrona:** all’interno dell’applicazione per ogni richiesta fatta al server sono stati usati i Future, una sorta di promessa di una funzione di ritornare un valore in un momento futuro, fornito dalla libreria dart:async. Per gestire i future ho usato le keyword async che usato subito dopo l’intestazione di una funzione, serve per dichiarare che ritornerà un Future e l’altra keyword è await che subito prima della chiamata di una funzione, serve a mettere l’esecuzione in pausa, in attesa che il risultato sia disponibile. L’esecuzione riprenderà da quel punto.

* **HTTP:** ho utilizzato il package http, che fornisce le principali funzionalità per il networking, con supporto per Android, iOS ed il web. Per poter effettuare le chiamate al server ho aggiunto http alle dependencies di pubspec.yaml ed ho importato il package nel file dart.

* **Parsing in background:** quando faccio il parsing delle risposte del server, per evitare che task computazionalmente pesanti rallentino la UI dell’applicazione, ho usato il concetto di ”Isolate” per eseguire i task su un background thread. Per chiamare la funzione di parsing nell’applicazione ho usato “compute”,in questo modo viene utilizzato un isolate separato che verrà eseguito in background.

* **List view:** è un widget che consente di visualizzare un elenco scrollabile di elementi. Può essere utilizzato per mostrare un elenco di elementi in modo efficiente, permettendo all'utente di scorrere l'elenco verticalmente o orizzontalmente, a seconda della configurazione. Inoltre, offre la possibilità di costruire dinamicamente gli elementi della lista.

## Testing

### Unit test

La cartella che contiene i test si chiama welcome.
Percorso /app/src/test/java/welcome

* Verifica che il campo username e password non sia vuoto.
* Verifica sulla lunghezza del codice fiscale inserito.
* Verifica sulla lunghezza del codice macchina inserito.

