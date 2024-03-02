import 'dart:ffi';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

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
        home: AdminSelectPlayersToTeam(),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdminMatchesConfigurePage(
                      uuid: tournament['id'],
                      tournamentName: tournament['name']),
            ),
          );
        },
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
                        // this onTap
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
  TextEditingController tournamentNameController = TextEditingController();
  TextEditingController playersAmountController = TextEditingController();
  TextEditingController oversAmountController = TextEditingController();
  TextEditingController oversForOneBowlerController = TextEditingController();
  TextEditingController ballsInOneOverController = TextEditingController();
  TextEditingController matchesAmountController = TextEditingController();
  String ballType = "";
  String uuid = Uuid().v4();

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create tournament", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset(
                "assets/add_tournament.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width),
              height: (MediaQuery
                  .of(context)
                  .size
                  .height),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 30.w),
                      child: Text(
                        "Tournament name:",
                        style: TextStyle(color: Colors.black, fontSize: 15.w),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                      child: TextField(
                        controller: tournamentNameController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(194, 173, 129, 1.0)),
                            hintText: "eg:- Indian Premier League"),
                        style:
                        (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Players in a team: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Overs per team: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: playersAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 11"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: oversAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 20"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Overs for a bowler: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Balls in a over: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: oversForOneBowlerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 4"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: ballsInOneOverController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 6"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.w, left: 30.w),
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
                                  (isTennisBall) ? Colors.red : Colors.blue,
                                  // onPrimary: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isTennisBall = true;
                                    isLeatherBall = false;
                                  });
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  child: Text(
                                    "Tennis",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.w),
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
                                  backgroundColor: (isLeatherBall)
                                      ? Colors.red
                                      : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLeatherBall = true;
                                    isTennisBall = false;
                                  });
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  child: Text(
                                    "Leather",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  backgroundColor: const Color.fromRGBO(117, 90, 41, 1.0),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: const Color.fromRGBO(23, 64, 124, 1.0),
                  backgroundColor: const Color.fromRGBO(107, 75, 3, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () {
                  ballType = (isTennisBall) ? "Tennis ball" : "Leather Ball";
                  Map<String, String> tournament = {
                    'id': uuid,
                    'name': tournamentNameController.text.trim(),
                    'Players': playersAmountController.text.trim(),
                    'Overs': oversAmountController.text.trim(),
                    'overs per bowler': oversForOneBowlerController.text.trim(),
                    'balls in an over': ballsInOneOverController.text.trim(),
                    'ball type': ballType,
                  };
                  dbRef2.set(tournament);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminMatchesConfigurePage extends StatefulWidget {
  final String uuid;
  final String tournamentName;

  const AdminMatchesConfigurePage(
      {super.key, required this.uuid, required this.tournamentName});

  @override
  State<StatefulWidget> createState() => _AdminMatchesConfigurePage();
}

class _AdminMatchesConfigurePage extends State<AdminMatchesConfigurePage> {
  late Query dbQuery;
  DatabaseReference referenceTournament =
  FirebaseDatabase.instance.ref().child('Tournaments');
  late DatabaseReference referenceMatches;

  @override
  void initState() {
    super.initState();
    dbQuery = FirebaseDatabase.instance.ref().child('Matches/${widget.uuid}');
    referenceMatches =
        FirebaseDatabase.instance.ref().child('Matches/${widget.uuid}');
  }

  Widget listItem({required Map thisMatch}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            padding: MaterialStatePropertyAll(
                EdgeInsets.only(top: 20.w, bottom: 20.w))),
        onPressed: () {
          (thisMatch['definedOrNot'] == "Not") ? Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(
              builder: (context) => const AdminConfigureMatches()), (
              route) => false) : Null;
        },
        child: Text(
            (thisMatch['definedOrNot'] == "Not")
                ? "Match - Undefined"
                : thisMatch['name'],
            style: TextStyle(fontSize: 15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tournamentName)),
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
                        // this onTap
                        Fluttertoast.showToast(
                            msg: "msg", toastLength: Toast.LENGTH_SHORT);
                        Map<String, String> matches = {"definedOrNot": "Not"};
                        referenceMatches.push().set(matches);
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
                  query: dbQuery,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map matches = snapshot.value as Map;
                    matches['key'] = snapshot.key;
                    return listItem(thisMatch: matches);
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

class AdminConfigureMatches extends StatefulWidget {
  const AdminConfigureMatches({super.key});

  @override
  State<AdminConfigureMatches> createState() =>
      _AdminConfigureMatches();
}

class _AdminConfigureMatches extends State<AdminConfigureMatches> {
  late DatabaseReference dbRef2;
  bool isTennisBall = false;
  bool isLeatherBall = false;
  TextEditingController tournamentNameController = TextEditingController();
  TextEditingController playersAmountController = TextEditingController();
  TextEditingController oversAmountController = TextEditingController();
  TextEditingController oversForOneBowlerController = TextEditingController();
  TextEditingController ballsInOneOverController = TextEditingController();
  TextEditingController matchesAmountController = TextEditingController();
  String ballType = "";
  String uuid = Uuid().v4();

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create tournament", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset(
                "assets/add_tournament.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width),
              height: (MediaQuery
                  .of(context)
                  .size
                  .height),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 30.w),
                      child: Text(
                        "Tournament name:",
                        style: TextStyle(color: Colors.black, fontSize: 15.w),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                      child: TextField(
                        controller: tournamentNameController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(194, 173, 129, 1.0)),
                            hintText: "eg:- Indian Premier League"),
                        style:
                        (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Players in a team: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Overs per team: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: playersAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 11"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: oversAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 20"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 25.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Overs for a bowler: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Balls in a over: ",
                            style:
                            TextStyle(color: Colors.black, fontSize: 15.w),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30.w, top: 2.w, right: 30.w),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: oversForOneBowlerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 4"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: TextField(
                              controller: ballsInOneOverController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                      Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 6"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.w, left: 30.w),
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
                                  (isTennisBall) ? Colors.red : Colors.blue,
                                  // onPrimary: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isTennisBall = true;
                                    isLeatherBall = false;
                                  });
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  child: Text(
                                    "Tennis",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.w),
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
                                  backgroundColor: (isLeatherBall)
                                      ? Colors.red
                                      : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLeatherBall = true;
                                    isTennisBall = false;
                                  });
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  child: Text(
                                    "Leather",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.w),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  backgroundColor: const Color.fromRGBO(117, 90, 41, 1.0),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: const Color.fromRGBO(23, 64, 124, 1.0),
                  backgroundColor: const Color.fromRGBO(107, 75, 3, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () {
                  ballType = (isTennisBall) ? "Tennis ball" : "Leather Ball";
                  Map<String, String> tournament = {
                    'id': uuid,
                    'name': tournamentNameController.text.trim(),
                    'Players': playersAmountController.text.trim(),
                    'Overs': oversAmountController.text.trim(),
                    'overs per bowler': oversForOneBowlerController.text.trim(),
                    'balls in an over': ballsInOneOverController.text.trim(),
                    'ball type': ballType,
                  };
                  dbRef2.set(tournament);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminAddTeams extends StatefulWidget {
  const AdminAddTeams({super.key});

  @override
  State<AdminAddTeams> createState() =>
      _AdminAddTeams();
}

class _AdminAddTeams extends State<AdminAddTeams> {
  late DatabaseReference dbRef2;
  bool isTennisBall = false;
  bool isLeatherBall = false;
  int numberOfPlayers = 0;
  TextEditingController tournamentNameController = TextEditingController();
  TextEditingController playersAmountController = TextEditingController();
  TextEditingController oversAmountController = TextEditingController();
  TextEditingController oversForOneBowlerController = TextEditingController();
  TextEditingController ballsInOneOverController = TextEditingController();
  TextEditingController matchesAmountController = TextEditingController();
  String ballType = "";
  String uuid = Uuid().v4();

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create tournament", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset(
                "assets/add_tournament.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width),
              height: (MediaQuery
                  .of(context)
                  .size
                  .height),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 30.w),
                      child: Text(
                        "Team name:",
                        style: TextStyle(color: Colors.black, fontSize: 15.w),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                      child: TextField(
                        controller: tournamentNameController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(194, 173, 129, 1.0)),
                            hintText: "eg:- Chennai Super Kings"),
                        style:
                        (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 30.w),
                      child: Text(
                        "Team name(Short form - max 5 letters):",
                        style: TextStyle(color: Colors.black, fontSize: 15.w),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                      child: TextField(
                        maxLength: 5,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(194, 173, 129, 1.0)),
                            hintText: "eg:- CSK"),
                        style:
                        (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 30.w),
                      child: Text(
                        "Add players:",
                        style: TextStyle(color: Colors.black, fontSize: 15.w),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  backgroundColor: const Color.fromRGBO(117, 90, 41, 1.0),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: const Color.fromRGBO(23, 64, 124, 1.0),
                  backgroundColor: const Color.fromRGBO(107, 75, 3, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () {
                  ballType = (isTennisBall) ? "Tennis ball" : "Leather Ball";
                  Map<String, String> tournament = {
                    'id': uuid,
                    'name': tournamentNameController.text.trim(),
                    'Players': playersAmountController.text.trim(),
                    'Overs': oversAmountController.text.trim(),
                    'overs per bowler': oversForOneBowlerController.text.trim(),
                    'balls in an over': ballsInOneOverController.text.trim(),
                    'ball type': ballType,
                  };
                  dbRef2.set(tournament);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 15.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminAddPlayers extends StatefulWidget {
  const AdminAddPlayers({super.key});

  @override
  State<AdminAddPlayers> createState() =>
      _AdminAddPlayers();
}

class _AdminAddPlayers extends State<AdminAddPlayers> {
  late DatabaseReference dbRef2;
  late Query dbQuery;
  TextEditingController playerNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  late String uuid;

  @override
  void initState() {
    super.initState();
    dbQuery = FirebaseDatabase.instance.ref().child('Players');
  }


  Widget listItem({required Map thisPlayer}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 227, 221, 1.0)
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (
                          EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(
                          201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                          child: Text(thisPlayer['name'], style: TextStyle(
                              fontSize: 15.w, color: Colors.black),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.w),
                          child: Text(thisPlayer['contact'], style: TextStyle(
                              fontSize: 15.w, color: Colors.black),),
                        )
                      ])
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (
                          EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {},
                  child: Text("Remove",
                    style: TextStyle(fontSize: 15.w, color: Colors.black),)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add player details", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 20.w, bottom: 20.w),
              child: Container(
                color: const Color.fromRGBO(213, 210, 210, 1.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Text(
                              "Player name:",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.w),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                            child: TextField(
                              controller: playerNameController,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(
                                          194, 173, 129, 1.0)),
                                  hintText: "eg:- M.S.Dhoni"),
                              style:
                              (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.w, left: 30.w),
                            child: Text(
                              "Contact Number:",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.w),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(top: 2.w, left: 30.w, right: 30.w),
                            child: TextField(
                              controller: contactNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(
                                          194, 173, 129, 1.0)),
                                  hintText: "eg:- 077XXXXXXX"),
                              style:
                              (TextStyle(color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(
                                      112, 79, 25, 1.0)
                              ),
                              onPressed: () {
                                setState(() {
                                  uuid = Uuid().v4();
                                  dbRef2 =
                                      FirebaseDatabase.instance.ref().child(
                                          'Players').child(uuid);
                                });
                                Map<String, String> players = {
                                  'name': playerNameController.text.trim(),
                                  'contact': contactNumberController.text
                                      .toString(),
                                  'id': uuid,
                                  'isAdded':""
                                };
                                dbRef2.set(players);
                              },
                              child: Text(
                                "Add players",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.w),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map players = snapshot.value as Map;
                  players['key'] = snapshot.key;
                  return listItem(thisPlayer: players);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSelectPlayersToTeam extends StatefulWidget {
  const AdminSelectPlayersToTeam({super.key});

  @override
  State<AdminSelectPlayersToTeam> createState() =>
      _AdminSelectPlayersToTeam();
}

class _AdminSelectPlayersToTeam extends State<AdminSelectPlayersToTeam> {
  late DatabaseReference dbRef2;
  late Query dbQuery;
  bool isAdded=false;

  @override
  void initState() {
    super.initState();
    dbQuery = FirebaseDatabase.instance.ref().child('Players');
  }


  Widget listItem({required Map thisPlayer}) {
    String? id=thisPlayer['id'];
    String? playerAdded=thisPlayer['isAdded'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 227, 221, 1.0)
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (
                          EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(
                          201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                          child: Text(thisPlayer['name'], style: TextStyle(
                              fontSize: 15.w, color: Colors.black),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.w),
                          child: Text(thisPlayer['contact'], style: TextStyle(
                              fontSize: 15.w, color: Colors.black),),
                        )
                      ])
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (
                          EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {
                    setState(() {
                      dbRef2 =
                          FirebaseDatabase.instance.ref().child(
                              'Players').child(id.toString());
                      isAdded= (playerAdded !="true")? false:true;
                      isAdded=!isAdded;
                    });
                    Map<String, String> thisPlayer = {
                      'isAdded':isAdded.toString()
                    };
                    dbRef2.update(thisPlayer);
                  },
                  child: Text((thisPlayer['isAdded']=="true")?"Remove":"Add", style: TextStyle(fontSize: 15.w, color: Colors.black),)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Players", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.w,top:25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map players = snapshot.value as Map;
                  players['key'] = snapshot.key;
                  return listItem(thisPlayer: players);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}