import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ParkApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _locationMessage = "";
  LatLng _pos;

  Future<LatLng> _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      _pos = LatLng(position.latitude, position.longitude);
      debugPrint("sa");
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); //running initialisation code; getting prefs etc.
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("Limon Otopark"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: "Limon Otopark",
          snippet: "Sa",
        ),
      );
      _markers["sa"] = marker;
      _pos = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps '),
          backgroundColor: Colors.red[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _pos,
            zoom: 20.0,
          ),
          markers: _markers.values.toSet(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Onur Sertgil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Image.asset(
                        "assets/images/pp.jpg",
                        height: 100,
                        width: 100,
                      ),
                    ],
                  )

                  // Text(
                  //   'Onur Sertgil',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //   ),
                  // ),

                  // child: Image.asset(
                  //   "assets/images/pp.jpg",
                  //   height: 130,
                  //   width: 130,
                  // ),
                  ),
              ListTile(
                leading: Icon(Icons.local_parking_outlined),
                title: Text('Park Yeri Bul'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car_outlined),
                title: Text('Otopark Listesi'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Ayarlar()),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 295),
                child: Text(
                  "",
                  style: new TextStyle(
                    fontSize: 30.0,
                    //color: Colors.yellow,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstRoute()),
                  );
                },
                child: Text('Çıkış'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParkApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Colors.white,
        ),
        home: Authentication());
  }
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("ParKap", textAlign: TextAlign.center),
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Center(
            //       child: Image.asset(
            //         "assets/images/logo.png",
            //         height: 130,
            //         width: 130,
            //       )),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 160,
                  width: 160,
                )),

            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 25),
              child: Text(
                "Parkap'a Hoşgeldiniz",
                style: new TextStyle(
                  fontSize: 30.0,
                  //color: Colors.yellow,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 25),
              child: Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Email:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: const Text('Giriş'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
                child: const Text('Kayıt Ol'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Authentication extends StatefulWidget {
  Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Lütfen Bilgilerinizi Kontrol Edin'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("ParKap", textAlign: TextAlign.center),
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Center(
            //       child: Image.asset(
            //         "assets/images/logo.png",
            //         height: 130,
            //         width: 130,
            //       )),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 160,
                  width: 160,
                )),

            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 25),
              child: Text(
                "Parkap'a Hoşgeldiniz",
                style: new TextStyle(
                  fontSize: 30.0,
                  //color: Colors.yellow,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 25),
              child: Container(
                child: TextFormField(
                  controller: _emailField,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Email:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextFormField(
                  controller: _passwordField,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () async {
                  bool shouldNavigate =
                      await signIn(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  } else {
                    _showMyDialog();
                  }
                },
                child: const Text('Giriş'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
                child: const Text('Kayıt Ol'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  signInWithGoogle();
                },
                child: const Text('Google'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Email:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Kullanıcı Adı:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Telefon Numarası:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Şehir:'),
                ),
                width: 320,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FirstRoute()),
                );
              },
              child: Text('Adam Ol'),
            ),
          ],
        ),
      ),
    );
  }
}

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ana Sayfa"),
        ),
        body: Center(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 255),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstRoute()),
                  );
                },
                child: const Text('HARİTA EKLENECEK'),
              ),
            ),
          ],
        )),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Onur Sertgil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Image.asset(
                        "assets/images/pp.jpg",
                        height: 100,
                        width: 100,
                      ),
                    ],
                  )

                  // Text(
                  //   'Onur Sertgil',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //   ),
                  // ),

                  // child: Image.asset(
                  //   "assets/images/pp.jpg",
                  //   height: 130,
                  //   width: 130,
                  // ),
                  ),
              ListTile(
                leading: Icon(Icons.local_parking_outlined),
                title: Text('Park Yeri Bul'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car_outlined),
                title: Text('Otopark'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Ayarlar()),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 295),
                child: Text(
                  "",
                  style: new TextStyle(
                    fontSize: 30.0,
                    //color: Colors.yellow,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstRoute()),
                  );
                },
                child: Text('Çıkış'),
              ),
            ],
          ),
        ));
  }
}

class Ayarlar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Onur Sertgil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Image.asset(
                      "assets/images/pp.jpg",
                      height: 100,
                      width: 100,
                    ),
                  ],
                )

                // Text(
                //   'Onur Sertgil',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 24,
                //   ),
                // ),

                // child: Image.asset(
                //   "assets/images/pp.jpg",
                //   height: 130,
                //   width: 130,
                // ),
                ),
            ListTile(
              leading: Icon(Icons.local_parking_outlined),
              title: Text('Park Yeri Bul'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car_outlined),
              title: Text('Otopark'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ayarlar'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Ayarlar()),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 295),
              child: Text(
                "",
                style: new TextStyle(
                  fontSize: 30.0,
                  //color: Colors.yellow,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FirstRoute()),
                );
              },
              child: Text('Çıkış'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.lock_open_outlined),
              title: Text('Şifre Değiştirme'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sifre()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Profil Fotoğrafı Değiştirme'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Foto()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outlined),
              title: Text('Destek'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Destek()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.nightlight_round_outlined),
              title: Text('Dark Mod'),
            ),
          ],
        ),
      ),
    );
  }
}

class Destek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destek'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Gizlilik Politikası'),
            ),
            ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Hizmet Şartları'),
            ),
          ],
        ),
      ),
    );
  }
}

class Sifre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şifre Değiştirme'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 25, top: 10),
              child: Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Eski Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Yeni Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      //labelText: 'Email',
                      hintText: 'Yeni Şifre:'),
                ),
                width: 320,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ayarlar()),
                  );
                },
                child: const Text('Tamam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Foto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Fotoğrafı Değiştirme'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: 15),
                child: Image.asset(
                  "assets/images/pp.jpg",
                  height: 130,
                  width: 130,
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.photo_camera_front_rounded),
                title: Text('Resmi Gör'),
                onTap: () async {
                  await showDialog(
                      context: context, builder: (_) => ImageDialog());
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.camera_roll_rounded),
                title: Text(
                  'Resim Seç ',
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  await showDialog(context: context, builder: (_) => MyPage());
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('Resim Çek'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Sifre()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/pp.jpg'),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  /// Variables
  File _image;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Fotoğrafı Değiştirme'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: 15),
                child: Image.asset(
                  "assets/images/pp.jpg",
                  height: 130,
                  width: 130,
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.photo_camera_front_rounded),
                title: Text('Resmi Gör'),
                onTap: () async {
                  await showDialog(
                      context: context, builder: (_) => ImageDialog());
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.camera_roll_rounded),
                title: Text(
                  'Resim Seç ',
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: _imgFromGallery,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text(
                  'Resim Çek 2',
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: _imgFromCamera,
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.camera_alt_rounded),
            //   title: Text('Resim Çek'),
            //   onTap: _imgFromCamera,
            // ),
          ],
        ),
      ),
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
