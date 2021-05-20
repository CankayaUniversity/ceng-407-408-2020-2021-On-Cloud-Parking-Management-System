import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/maps/screens/bottom.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';
import 'package:flutter_demo/views/menu_page.dart';
import 'package:provider/provider.dart';


import 'views/girissayfasi.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator()));

        }
        if(snapshot.hasData){
          Kullanici aktifKullanici = snapshot.data;
          _yetkilendirmeServisi.aktifKullaniciId= aktifKullanici.id;
          return MyStatefulWidget();
         
        } else {
          return GirisSayfasi();
        }
      }
      );
  }
}