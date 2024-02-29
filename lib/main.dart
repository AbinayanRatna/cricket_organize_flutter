import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA_S5hITxt49RbV_NsI4rNu065QPEoyRIQ",
      appId: "1:290008525635:android:3e463ff0237fd264c6ddf6",
      messagingSenderId: "290008525635",
      projectId: "cricket-flutter",
      storageBucket: "cricket-flutter.appspot.com",
    ),
  )
      : await Firebase.initializeApp(); //need to add firebase for ios
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (_, child) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminSelectTournamentPage(),
      );
    });
  }
}

class AdminSelectTournamentPage extends StatefulWidget {
  const AdminSelectTournamentPage({super.key});

  @override
  State<AdminSelectTournamentPage> createState() =>
      _AdminSelectTournamentPage();
}

class _AdminSelectTournamentPage extends State<AdminSelectTournamentPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Tournaments');
  DatabaseReference reference =
  FirebaseDatabase.instance.ref().child('Tournaments');
  late DatabaseReference dbRef2;

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments');
  }

  Widget listItem({required Map tournament}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            padding: MaterialStatePropertyAll(
                EdgeInsets.only(top: 20.w, bottom: 20.w))),
        onPressed: () {},
        child: Text(tournament['name'], style: TextStyle(fontSize: 15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select tournament")),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: Padding(
                    padding: EdgeInsets.all(28.w),
                    child: InkWell(
                      onTap: () {
                        //  Map<String, String> tournament = {
                        //     'name': "Indian premeier league",
                        //   };
                        //  dbRef2.push().set(tournament);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminCreateTournamentPage(),
                            ),
                                (route) => false);
                        Fluttertoast.showToast(
                            msg: "msg", toastLength: Toast.LENGTH_SHORT);
                      },
                      child: Container(
                          child: Icon(Icons.add_circle,
                              color: Colors.indigo, size: 90.w)),
                    ),
                  )),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.w),
                child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map tournament = snapshot.value as Map;
                    tournament['key'] = snapshot.key;
                    return listItem(tournament: tournament);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminCreateTournamentPage extends StatefulWidget {
  const AdminCreateTournamentPage({super.key});

  @override
  State<AdminCreateTournamentPage> createState() =>
      _AdminCreateTournamentPage();
}

class _AdminCreateTournamentPage extends State<AdminCreateTournamentPage> {
  late DatabaseReference dbRef2;
  bool isTennisBall = false;
  bool isLeatherBall = false;

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create tournament")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex:1,
            child:Padding(
            padding:  EdgeInsets.only(top:10.w),
            child: Center(child: SvgPicture.asset("assets/add_tournament.svg",height: 120.w,)),
          ),),
          Expanded(flex:9,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25.w, left: 30.w),
                    child: Text(
                      "Tournament name:",
                      style: TextStyle(color: Colors.black, fontSize: 15.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                    child: TextField(
                      decoration: const InputDecoration(
                          hintStyle:
                          TextStyle(color: Color.fromRGBO(149, 179, 231, 1.0)),
                          hintText: "eg:- Indian Premier League"),
                      style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Players in a team: ",
                          style: TextStyle(color: Colors.black, fontSize: 15.w),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Overs per team: ",
                          style: TextStyle(color: Colors.black, fontSize: 15.w),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(149, 179, 231, 1.0)),
                                hintText: "eg:- 11"),
                            style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(149, 179, 231, 1.0)),
                                hintText: "eg:- 20"),
                            style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Overs for a bowler: ",
                          style: TextStyle(color: Colors.black, fontSize: 15.w),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Balls in a over: ",
                          style: TextStyle(color: Colors.black, fontSize: 15.w),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(149, 179, 231, 1.0)),
                                hintText: "eg:- 4"),
                            style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(149, 179, 231, 1.0)),
                                hintText: "eg:- 6"),
                            style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.w, left: 30.w),
                    child: Text(
                      "Matches in the tournament:",
                      style: TextStyle(color: Colors.black, fontSize: 15.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only( left: 30.w, right: 30.w),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintStyle:
                          TextStyle(color: Color.fromRGBO(149, 179, 231, 1.0)),
                          hintText: "eg:- 10"),
                      style: (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.w, left: 30.w),
                    child: Text(
                      "Ball type:",
                      style: TextStyle(color: Colors.black, fontSize: 15.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.w),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.w, right: 15.w),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                (isTennisBall ) ?Colors.red: Colors.blue,
                                // onPrimary: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isTennisBall = true;
                                  isLeatherBall = false;
                                });

                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                                child: Text(
                                  "Tennis",
                                  style: TextStyle(color: Colors.white, fontSize: 15.w),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 30.w, left: 15.w),
                            child: ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                ( isLeatherBall) ? Colors.red:Colors.blue,
                                onPrimary: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLeatherBall = true;
                                  isTennisBall = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                                child: Text(
                                  "Leather",
                                  style: TextStyle(color: Colors.white, fontSize: 15.w),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(top: 28.w,bottom:25.w),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.w, right: 15.w),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () { },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white, fontSize: 15.w),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 30.w, left: 15.w),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () { },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white, fontSize: 15.w),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),


        ],
      ),
    );
  }
}
