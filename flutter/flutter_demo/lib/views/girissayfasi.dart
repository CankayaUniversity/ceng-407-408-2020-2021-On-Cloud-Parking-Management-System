import 'package:flutter/material.dart';
import 'package:flutter_demo/modeller/kullanici.dart';
import 'package:flutter_demo/servisler/firestoreservisi.dart';
import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';
import 'package:flutter_demo/views/hesapolustur.dart';
import 'package:provider/provider.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool loading = false;
  String email, password;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        body: Stack(
          children: [
            _sayfaElemanlari(),
            _loadingAnimator(),
          ],
        ));
  }

  Widget _loadingAnimator() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: <Widget>[
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/mainlogo.png"))
            ),
              
          ),
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your mail address",
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
            onSaved: (inputValue) => email = inputValue,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
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
            onSaved: (inputValue) => password = inputValue,
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },
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
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: _girisYap,
                  child: Text(
                    "Enter Your Account",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColorDark,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("Or")),
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: InkWell(
            onTap: _googleLogin,
            child: Text(
              "Sign with Google",
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("Forgot password")),
        ],
      ),
    );
  }

  void _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        loading = true;
      });
      try {
        await _yetkilendirmeServisi.mailLogin(email, password);
      } catch (error) {
        setState(() {
        loading = false;
      });
        showWarning(errorCode: error.code);
      }
    }
  }

  void _googleLogin() async{
    var _yekilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      loading = true;
    });

    try {
     Kullanici user = await  _yekilendirmeServisi.googleLogin();
     if(user != null){
       Kullanici firestoreUser = await FireStoreServisi().getUser(user.id);
       if(firestoreUser == null){
          FireStoreServisi().createUser(
         id: user.id,
         email:user.email,
         kullaniciAdi: user.kullaniciAdi,
         fotoUrl: user.fotoUrl

       );
       print("oluştu");
       }
     }
    } catch (error) {
      setState(() {
        loading = false;
      });
      showWarning(errorCode: error.code);
    }
  }
  

  showWarning({errorCode}) {
    String errorMsg;

    if (errorCode == "invalid-email") {
      errorMsg = "The email address is not valid.";
    } else if (errorCode == "user-not-found") {
      errorMsg = "The user corresponding to the given email has been disabled.";
    } else if (errorCode == "user-disabled") {
      errorMsg = "There is no user corresponding to the given email.";
    } else if (errorCode == "wrong-password") {
      errorMsg =
          "The password is invalid for the given email, or the account corresponding to the email does not have a password set.";
    } else {
      errorMsg = "Unknown Error. $errorCode";
    }

    var snackBar = SnackBar(content: Text(errorMsg));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
