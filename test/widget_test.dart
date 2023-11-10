import 'package:esame_flutter_pm/HomeGen/SuddLavoroGen/Lista/CredenzialiComplete.dart';
import 'package:esame_flutter_pm/HomePro/Prenotazioni/ListaGen/CredenzialiCompletePro.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esame_flutter_pm/main.dart';

void main() {
  test('Test di controllo per il Login', () {
    String user = "";
    String pass = "";
    final main = MyApp();
    expect(main.controll(user, pass),false);
  });
 test("Test di controllo sull'inserimento del codice fiscale", () {
   String CF = "123456789123456789";
   final Credenziali = CredenzialiComplete();
   expect(Credenziali.controllCF(CF),false);
 });
 test("Test per il controllo sull'inserimento del codice di un macchinario", () {
   String Cod = "";
   final CredenzialiPro = CredenzialiCompletePro();
   expect(CredenzialiPro.controllCod(Cod), false);
 });
}
