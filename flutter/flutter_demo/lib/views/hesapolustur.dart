import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:flutter_demo/servisler/firestoreservisi.dart';
import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool loading = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  

  String kullaniciAdi, email, sifre, gsm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: ListView(
        children: <Widget>[
          loading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formAnahtari,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autocorrect: true,
                      decoration: InputDecoration(
                      hintText: "Kullanıcı adınızı girin",
                      labelText: "Kullanıcı Adı:",
                      errorStyle: TextStyle(fontSize: 16.0),
                      prefixIcon: Icon(Icons.person),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Username field will can not empty";
                        } else if (girilenDeger.trim().length < 4 ||
                            girilenDeger.trim().length > 10) {
                          return "At least 4, most 10 character.";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      autocorrect: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your mail address",
                        labelText: "Mail:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.mail),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "E-mail field will can not empty";
                        } else if (!girilenDeger.contains("@")) {
                          return "Input must be e-mail formatted";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => email = girilenDeger,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        labelText: "Password:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Password field will can not empty";
                        } else if (girilenDeger.trim().length < 4) {
                          return "Password must at least 4 character";
                        }
                        return null;
                      },
                     onSaved: (girilenDeger) => sifre = girilenDeger,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                     TextFormField(
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        labelText: "Gsm:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.isEmpty) {
                          return "Password field will can not empty";
                        } else if (girilenDeger.trim().length < 4) {
                          return "Password must at least 4 character";
                        }
                        return null;
                      },
                     onSaved: (girilenDeger) => gsm = girilenDeger,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: _kullaniciOlustur,
                        child: Text(
                          "Hesap Oluştur",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _kullaniciOlustur() async{

    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState =  _formAnahtari.currentState;

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        loading = true;
      });
    try{
    Kullanici user = await _yetkilendirmeServisi.mailRegister(email, sifre);
    if(user != null){
      FireStoreServisi().createUser(id: user.id, email: email, kullaniciAdi: kullaniciAdi, gsm: gsm);
    }
    Navigator.pop(context);
    } catch(error){
      setState(() {
        loading = false;
      });
      showWarning(errorCode: error.code);
    }
    
    }
  }
  showWarning({errorCode}){
    String errorMsg;

    if(errorCode == "invalid-email:"){
      errorMsg = "Invalid mail address.";
    } else if(errorCode == "email-already-in-use"){
      errorMsg = "Given mail already in use.";
    } else if(errorCode == "weak-password:"){
      errorMsg = "Password is weak.";
    }

  var snackBar = SnackBar(content: Text(errorMsg));
  _scaffoldAnahtari.currentState.showSnackBar(snackBar);

  }

  
}
