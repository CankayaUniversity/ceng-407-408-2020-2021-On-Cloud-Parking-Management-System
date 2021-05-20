  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kullanici {
  
  final String id;
  final String kullaniciAdi;
  final String fotoUrl;
  final String email;
  final String hakkinda;
  final String gsm;
  final String plaka;
  final String otomobil;

  Kullanici({@required this.id, this.kullaniciAdi, this.fotoUrl, this.email,  this.hakkinda, this.gsm, this.plaka, this.otomobil});


  factory Kullanici.firebasedenUret(User kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotoUrl: kullanici.photoURL,
      email: kullanici.email,
      gsm: kullanici.phoneNumber
      
    );
  }


  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data();
    return Kullanici(
      id : doc.id,
      kullaniciAdi: docData['kullaniciAdi'],
      email: docData['email'],
      fotoUrl: docData['fotoUrl'],
      hakkinda: docData['hakkinda'],
      gsm: docData['gsm'],
      plaka: docData['plaka'],
      otomobil: docData['otomobil']
    );
  }


}