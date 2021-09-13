import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
//import 'package:flutter_listtile_demo/model/listtilemodel.dart';

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
  var username = "adam ol";
  var uuid = Uuid();
  final Map<String, Marker> _markers = {};
  bool value = false;

  get actions => null;
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrele'),
          content: SingleChildScrollView(
            child: ListBody(
              //   children: const <Widget>[
              //     //Text('This is a demo alert dialog.'),
              //     Expanded(child: Text("F1")),
              //     // Checkbox(
              //     //   value: false,
              //     // ),
              children: [
                CheckboxListTile(
                  title: const Text('Fiyata Göre'),
                  //subtitle: const Text('A computer science portal for geeks.'),
                  //secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: value,
                  value: value,
                  onChanged: (bool value) {
                    setState(() {
                      value = value;
                    });
                  },

                  //Text('Would you like to approve of this message?'),
                  //],*******
                  // actions: <Widget>[
                  //   TextButton(
                  //     child: const Text('Filtrele'),
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       //Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ],
                ),
                CheckboxListTile(
                  title: const Text('Mesafeye Göre'),
                  //subtitle: const Text('A computer science portal for geeks.'),
                  //secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: value,
                  value: value,
                  onChanged: (bool value) {
                    setState(() {
                      value = value;
                    });
                  },

                  //Text('Would you like to approve of this message?'),
                  //],*******
                  // actions: <Widget>[
                  //   TextButton(
                  //     child: const Text('Filtrele'),
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       //Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ],
                ),
                CheckboxListTile(
                  title: const Text('Boş Park Sayısına Göre'),
                  //subtitle: const Text('A computer science portal for geeks.'),
                  //secondary: const Icon(Icons.code),
                  autofocus: false,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  selected: value,
                  value: value,
                  onChanged: (bool value) {
                    setState(() {
                      value = value;
                    });
                  },

                  //Text('Would you like to approve of this message?'),
                  //],*******
                  // actions: <Widget>[
                  //   TextButton(
                  //     child: const Text('Filtrele'),
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       //Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ],
                ),
                FlutterSwitch(
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: false,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  //onToggle: (val) {
                  //setState(() {
                  //  status = val;
                  // });
                  //},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //       actions:
  //       <Widget>[
  //         TextButton(
  //           child: const Text('Filtrele'),
  //           onPressed: () {
  //             Navigator.pop(context);
  //             //Navigator.of(context).pop();
  //           },
  //         ),
  //       ];
  //       //);
  //     },
  //   );
  // }

  void _setMarker() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      final marker = Marker(
        markerId: MarkerId("Limon Otopark"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: "Limon Otopark",
          snippet: "Sa2",
        ),
      );
      _markers["sa"] = marker;
    });
  }

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      _pos = LatLng(position.latitude, position.longitude);
      debugPrint("sa");
      // var firebaseUser = FirebaseAuth.instance.currentUser;

      // FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(firebaseUser.uid)
      //     .get()
      //     .then((value) {
      //   print("BAK");
      //   print(value.data());
      //   username = value.data()["username"];
      // });
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _markers.clear();
      FirebaseFirestore.instance.collection("parks").get().then((value) {
        print("BAK");

        final allData = value.docs.map((doc) => doc.data()).toList();
        print(allData);
        for (var data in allData) {
          var uid = uuid.v1();
          print(uid);
          _markers[uid] = Marker(
            markerId: MarkerId(uid),
            position:
                LatLng(double.parse(data["lat"]), double.parse(data["long"])),
            infoWindow: InfoWindow(
              title: "Limon Otopark",
              snippet: "Sa",
            ),
          );
        }
      });

      // _pos = LatLng(position.latitude, position.longitude);
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
        floatingActionButton: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            new FloatingActionButton(
              onPressed: () {
                _showMyDialog();
              },
              child: Icon(Icons.filter_alt_outlined),
              backgroundColor: Colors.green,
            ),
            new FloatingActionButton(
              onPressed: () {
                //KİŞİ GİRİŞİ
                _setMarker();
              },
              child: Icon(Icons.add_circle_outline_outlined),
              backgroundColor: Colors.redAccent[700],
            )
          ],
        ),

        //  body: GoogleMap(
        //     onMapCreated: _onMapCreated,
        //     initialCameraPosition: CameraPosition(
        //       target: _pos,
        //       zoom: 20.0,
        //     ),
        //     markers: _markers.values.toSet(),
        //  ),
        //DEĞİŞTİRİLMEZ

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
                        username,
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
                leading: Icon(Icons.trending_up_outlined),
                title: Text('Seviye'),
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
                    MaterialPageRoute(builder: (context) => Authentication()),
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

  void onChanged(bool newValue) {}
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
                Text('Bilgilerinizi kontrol ediniz !'),
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
      resizeToAvoidBottomInset: false, //sarı-siyah hatası
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
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20)),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MyApp(),
                  //   ),
                  // );
                  //TODO değiştir
                },
                child: const Text('Giriş'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: const Text('Kayıt Ol'),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 25),
            //   child: ElevatedButton.icon(
            //     icon: ImageIcon(
            //       AssetImage(
            //           "assets/images/btn_google_light_focus_xxxhdpi.9.png"),
            //       color: Color(0xff4285F4),
            //       size: 24,
            //     ),
            //     label: Text('Sign in with Google'),
            //     onPressed: () {
            //       signInWithGoogle();
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 20.0, bottom: 0.0),
              child: new RaisedButton(
                color: Color(0xff4285F4),
                elevation: 0.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(1.0)),
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, right: 30.0, left: 5.0),
                onPressed: () {
                  signInWithGoogle();
                },
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Image.asset(
                        'assets/images/btn_google_light_focus_xxxhdpi.9.png',
                        height: 40.0,
                        width: 40.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: new Text(
                          "Sign in with Google ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  static final String title = 'Dropdown Button';
  @override
  _RegisterState createState() => _RegisterState();
}

class NewObject {
  final String title;
  final IconData icon;

  NewObject(this.title, this.icon);
}

class _RegisterState extends State<Register> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _cityField = TextEditingController();
  TextEditingController _usernameField = TextEditingController();
  TextEditingController _telField = TextEditingController();
  @override
  static final List<NewObject> items = <NewObject>[
    NewObject('İstanbul', Icons.home_work_outlined),
    NewObject('Ankara', Icons.home_work_outlined),
    NewObject('İzmir', Icons.home_work_outlined),
    NewObject('Antalya', Icons.home_work_outlined),
  ];

  NewObject value = items.first;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: TextField(
                  controller: _usernameField,
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
              child: Container(
                child: TextField(
                  controller: _telField,
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
              child: buildDropdown(),
              // child: Container(
              //   child: TextField(
              //     controller: _cityField,
              //     decoration: InputDecoration(
              //         border: OutlineInputBorder(
              //             borderRadius:
              //                 BorderRadius.all(Radius.circular(15.0))),
              //         //labelText: 'Email',
              //         hintText: 'Şehir:'),
              //   ),
              //   width: 320,
              // ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool shouldNavigate = await register(
                    _emailField.text,
                    _passwordField.text,
                    _telField.text,
                    value.title,
                    _usernameField.text);
                if (shouldNavigate) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                }
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown() => Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
              color: Color(0xffb9b9b9), width: 1), //color: Color(0xff4285F4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<NewObject>(
            value: value, // currently selected item
            items: items
                .map((item) => DropdownMenuItem<NewObject>(
                      child: Row(
                        children: [
                          Icon(item.icon),
                          const SizedBox(width: 8),
                          Text(
                            item.title,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      value: item,
                    ))
                .toList(),
            onChanged: (value) => setState(() {
              this.value = value;
            }),
          ),
        ),
      );
}
// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Kayıt Ol"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(bottom: 25),
//               child: Container(
//                 child: TextField(
//                   controller: _emailField,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       //labelText: 'Email',
//                       hintText: 'Email:'),
//                 ),
//                 width: 320,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 25),
//               child: Container(
//                 child: TextField(
//                   controller: _usernameField,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       //labelText: 'Email',
//                       hintText: 'Kullanıcı Adı:'),
//                 ),
//                 width: 320,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 25),
//               child: Container(
//                 child: TextField(
//                   controller: _passwordField,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       //labelText: 'Email',
//                       hintText: 'Şifre:'),
//                 ),
//                 width: 320,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 25),
//               child: Container(
//                 child: TextField(
//                   controller: _telField,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       //labelText: 'Email',
//                       hintText: 'Telefon Numarası:'),
//                 ),
//                 width: 320,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 25),
//               child: Container(
//                 child: TextField(
//                   controller: _cityField,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       //labelText: 'Email',
//                       hintText: 'Şehir:'),
//                 ),
//                 width: 320,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 bool shouldNavigate = await register(
//                     _emailField.text,
//                     _passwordField.text,
//                     _telField.text,
//                     _cityField.text,
//                     _usernameField.text);
//                 if (shouldNavigate) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FirstRoute(),
//                     ),
//                   );
//                 }
//               },
//               child: Text('Adam Ol'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                    MaterialPageRoute(builder: (context) => Authentication()),
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
                title: Text('Otopark Listesi'),
              ),
              ListTile(
                leading: Icon(Icons.trending_up_outlined),
                title: Text('Seviye'),
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
                padding: EdgeInsets.only(top: 255),
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
                    MaterialPageRoute(builder: (context) => Authentication()),
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
              title: Text('Otopark Listesi'),
            ),
            ListTile(
              leading: Icon(Icons.trending_up_outlined),
              title: Text('Seviye'),
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
                  MaterialPageRoute(builder: (context) => Authentication()),
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
