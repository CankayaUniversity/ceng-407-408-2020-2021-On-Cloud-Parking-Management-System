import 'package:flutter/material.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:flutter_demo/servisler/firestoreservisi.dart';
import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';
import 'profiliduzenle.dart';
import 'plakaduzenle.dart';
import 'otomobilduzenle.dart';

class Profil extends StatefulWidget {
  final String profilSahibiId;

  const Profil({Key key, this.profilSahibiId}) : super(key: key);
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  String _aktifKullaniciId;
  Kullanici _profilSahibi;

  @override
  void initState() {
  
    super.initState();
    _aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Profil", style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.grey[100],
      actions: <Widget>[
        IconButton(icon: Icon(Icons.exit_to_app, color: Colors.black,), onPressed: _logout)
      
      ],
    ),
    body: FutureBuilder<Object>(
      future: FireStoreServisi().getUser(_aktifKullaniciId),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        _profilSahibi =snapshot.data;
        return ListView(
          children: <Widget>[
            _profilDetaylari(snapshot.data)
          ],
        );
      }
    ),
    );
  }
    
    Widget _profilDetaylari(Kullanici profilData){
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: profilData.fotoUrl.isNotEmpty ? NetworkImage(profilData.fotoUrl) : AssetImage("assets/images/hayalet.png"),
              ),
            ),
           SizedBox(height:10.0,), 
           Center(
             child: Text(
               profilData.kullaniciAdi,
               style: TextStyle(
                 fontSize: 15.0,
                 fontWeight: FontWeight.bold
               ),
             ),
           ),
           SizedBox(height:10.0,), 
           Center(child: Text(profilData.hakkinda)),
           SizedBox(height: 25.0,),
           widget.profilSahibiId == _aktifKullaniciId ?  _profiliDuzenleButon() : Text("Error"),
           SizedBox(height:25.0,),
           widget.profilSahibiId == _aktifKullaniciId ?  _kayitliPlakaButon() : Text("Error"),
           SizedBox(height:25.0,),
           widget.profilSahibiId == _aktifKullaniciId ?  _kayitliAraclarimButon() : Text("Error"), 
          ],
        ),
      );
    }

  Widget _profiliDuzenleButon(){
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfiliDuzenle(profil: _profilSahibi,)));
        },
        child: Text("Profili Düzenle"),
      ),
    );
  }
  Widget _kayitliPlakaButon(){
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlakaDuzenle(profil: _profilSahibi,)));
        },
        child: Text("Kayıtlı Plakalarım"),
      ),
    );
  }
  
  Widget _kayitliAraclarimButon(){
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => OtomobilDuzenle(profil: _profilSahibi,)));
        },
        child: Text("Kayıtlı Araçlarım"),
      ),
    );
  }
    void _logout(){
      Provider.of<YetkilendirmeServisi>(context, listen: false).logout();
    }
  }

