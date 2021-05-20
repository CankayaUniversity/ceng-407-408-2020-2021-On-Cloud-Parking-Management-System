import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/modeller/kullanici.dart';


class FireStoreServisi{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime time = DateTime.now();


  Future<void> createUser({id, email, kullaniciAdi, fotoUrl="", gsm}) async {
    await _firestore.collection("Users").doc(id).set({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "fotoUrl": fotoUrl,
      "hakkinda": "",
      "olusturulmaZamani": time,
      "gsm": gsm,
      "plaka" : "",
      "otomobil":""
    });
  }
    Future<Kullanici> getUser (id) async {
    DocumentSnapshot doc = await _firestore.collection("Users").doc(id).get();
    if(doc.exists){
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }
    return null;
 }
 void kullaniciGuncelle({String kullaniciId, String kullaniciAdi, String fotoUrl = "", String hakkinda, String plaka, String otomobil}){
       _firestore.collection("Users").doc(kullaniciId).update({
         "kullaniciAdi": kullaniciAdi,
         "hakkinda": hakkinda,
         "fotoUrl": fotoUrl,
         "otomobil": otomobil

        });

 }
 void plakaGuncelle({String kullaniciId,String plaka}){
       _firestore.collection("Users").doc(kullaniciId).update({

         "plaka" : plaka,
        });

 }

 void otomobilGuncelle({String kullaniciId,String otomobil}){
       _firestore.collection("Users").doc(kullaniciId).update({

         "otomobil" : otomobil,
        });

 }
}