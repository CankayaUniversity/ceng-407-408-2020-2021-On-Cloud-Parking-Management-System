
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:flutter_demo/servisler/firestoreservisi.dart';
import 'package:flutter_demo/servisler/storageservisi.dart';
import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';

import 'package:provider/provider.dart';


class PlakaDuzenle extends StatefulWidget {
  final Kullanici profil;

  const PlakaDuzenle({Key key, this.profil}) : super(key: key);
  @override
  _PlakaDuzenleState createState() => _PlakaDuzenleState();
}

class _PlakaDuzenleState extends State<PlakaDuzenle> {
  var _formKey = GlobalKey<FormState>();
  String _plaka;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Plaka Düzenle", style: TextStyle(color: Colors.black),) ,
        leading: IconButton(icon: Icon(Icons.close, color: Colors.black,), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed: _kaydet),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _loading ? LinearProgressIndicator() : SizedBox (height: 0.0,),
         _plakaBilgileri()
        ],
      ),
    );
  }

  _kaydet() async{
    if(_formKey.currentState.validate()){
      setState(() {
        _loading = true;
      });
      _formKey.currentState.save();
      
      String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
      FireStoreServisi().plakaGuncelle(
        kullaniciId: aktifKullaniciId,
        plaka: _plaka
      );
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
    }
  }


 

  _plakaBilgileri(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _formKey,
              child: Column(
          children: <Widget>[
            SizedBox(height: 20.0 ,),
            TextFormField(
              initialValue: widget.profil.plaka,
              decoration: InputDecoration(
                labelText: "Plaka Bilgileri"
              ),
               validator: (girilenDeger){
                  return girilenDeger.trim().length <= 3 ? "Kullanıcı adı en az 4 karakter olmalı" : null;
                },
                onSaved: (girilenDeger){
                  _plaka = girilenDeger;
                },
            ),
            

          ],
        ),
      ),
    );
  }
}