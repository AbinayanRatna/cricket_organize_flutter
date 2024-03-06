import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
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
        // home: AdminSelectTournamentPage(),
        home: AdminScoreChangePage(),
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
              builder: (context) => AdminMatchesConfigurePage(
                  uuid: tournament['id'], tournamentName: tournament['name']),
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
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/add_tournament.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
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
  String uuid = "";

  @override
  void initState() {
    super.initState();
    dbQuery = FirebaseDatabase.instance
        .ref()
        .child('Tournaments/${widget.uuid}/Matches');
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
          (thisMatch['definedOrNot'] != "true")
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminAddTeamToMatches(
                            tId: widget.uuid,
                            mId: thisMatch['id'],
                            tName: widget.tournamentName,
                          )),
                  (route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminTossSelect(
                            tId: widget.uuid,
                            mId: thisMatch['id'],
                          )),
                  (route) => false);
        },
        child: Text(
            (thisMatch['definedOrNot'] != 'true')
                ? "Match - Not configured"
                : "Configured",
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
                        setState(() {
                          uuid = Uuid().v4();
                          referenceMatches = FirebaseDatabase.instance
                              .ref()
                              .child('Tournaments/${widget.uuid}/Matches')
                              .child(uuid);
                        });
                        // this onTap
                        Fluttertoast.showToast(
                            msg: "msg", toastLength: Toast.LENGTH_SHORT);
                        Map<String, String> matches = {
                          "id": uuid,
                          "definedOrNot": "Not",
                          "TeamA-defined": "Not",
                          "TeamB-defined": "Not",
                        };

                        referenceMatches.set(matches);
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

class AdminAddTeamToMatches extends StatefulWidget {
  final String? tId;
  final String? mId;
  final String? tName;

  const AdminAddTeamToMatches(
      {super.key, required this.tId, required this.mId, required this.tName});

  @override
  State<AdminAddTeamToMatches> createState() => _AdminAddTeamToMatches();
}

class _AdminAddTeamToMatches extends State<AdminAddTeamToMatches> {
  late DatabaseReference dbRef1;
  late DatabaseReference dbRef2;
  late DatabaseReference dbRef3;
  Query dbQuery = FirebaseDatabase.instance.ref().child('Teams');
  bool isAddedTeam1 = false;
  bool isAddedTeam2 = false;
  bool isTeam_A_Added = false;
  bool isTeam_B_Added = false;

  @override
  void initState() {
    super.initState();
    updateIsAdded();
  }

  void updateIsAdded() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Teams");

    dbRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> teams =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        teams.forEach((key, value) {
          dbRef.child(key).update({"state as team A": "not"});
          dbRef.child(key).update({"state as team B": "not"});
        });
      }
    });
  }

  Widget listItemTeamA({required Map thisTeam}) {
    String? id = thisTeam['id'];
    //String? name = thisMatch['name'];
    String? teamsAdded = thisTeam['state as team A'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(229, 227, 221, 1.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                    child: Text(
                      thisTeam['name'],
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    ),
                  ))),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {
                    if (teamsAdded == 'true' || isAddedTeam1 == false) {
                      setState(() {
                        dbRef1 = FirebaseDatabase.instance
                            .ref()
                            .child('Tournaments')
                            .child(widget.tId!)
                            .child('Matches')
                            .child(widget.mId!);
                        //dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(widget.tId!).child('Matches').child(widget.mId!).child('Team-A');
                        dbRef2 = FirebaseDatabase.instance
                            .ref()
                            .child('Teams')
                            .child(id!);
                        isAddedTeam1 = (teamsAdded != "true") ? false : true;
                        isAddedTeam1 = !isAddedTeam1;
                      });
                      Map<String, String> updatetThisTeam = {
                        'state as team A': isAddedTeam1.toString()
                      };
                      dbRef2.update(updatetThisTeam);

                      Map<String, String> thisTeamToMatch = {
                        'team name': thisTeam['name']!,
                        'id': thisTeam['id']!,
                      };
                      Map<String, String> updateAddingofTeam = {
                        'TeamA-defined': isAddedTeam1.toString()
                      };

                      dbRef1.update(updateAddingofTeam);
                      isAddedTeam1
                          ? dbRef1.child('Team-A').set(thisTeamToMatch)
                          : null;
                      !isAddedTeam1 ? dbRef1.child('Team-A').remove() : null;
                    } else {
                      Fluttertoast.showToast(
                          msg: "Only one can be selected",
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  },
                  child: Text(
                      thisTeam['state as team A'] != 'true' ? "Add" : "Remove",
                      style: TextStyle(color: Colors.black))),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItemTeamB({required Map thisTeam}) {
    String? id = thisTeam['id'];
    //String? name = thisMatch['name'];
    String? teamsAdded = thisTeam['state as team B'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(229, 227, 221, 1.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: isAddedTeam1 == true
                          ? Color.fromRGBO(201, 169, 101, 1.0)
                          : Color.fromRGBO(222, 217, 206, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                    child: Text(
                      thisTeam['name'],
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    ),
                  ))),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {
                    if (isAddedTeam1 == true &&
                        thisTeam['state as team A'] != 'true') {
                      if (teamsAdded == 'true' || isAddedTeam2 == false) {
                        setState(() {
                          dbRef1 = FirebaseDatabase.instance
                              .ref()
                              .child('Tournaments')
                              .child(widget.tId!)
                              .child('Matches')
                              .child(widget.mId!);
                          //dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(widget.tId!).child('Matches').child(widget.mId!).child('Team-A');
                          dbRef2 = FirebaseDatabase.instance
                              .ref()
                              .child('Teams')
                              .child(id!);
                          isAddedTeam2 = (teamsAdded != "true") ? false : true;
                          isAddedTeam2 = !isAddedTeam2;
                        });
                        Map<String, String> updatetThisTeam = {
                          'state as team B': isAddedTeam2.toString()
                        };
                        dbRef2.update(updatetThisTeam);

                        Map<String, String> thisTeamToMatch = {
                          'team name': thisTeam['name']!,
                          'id': thisTeam['id']!,
                        };
                        Map<String, String> updateAddingofTeam = {
                          'TeamB-defined': isAddedTeam2.toString(),
                          'definedOrNot': isAddedTeam2.toString()
                        };

                        dbRef1.update(updateAddingofTeam);
                        isAddedTeam2
                            ? dbRef1.child('Team-B').set(thisTeamToMatch)
                            : null;
                        !isAddedTeam2 ? dbRef1.child('Team-B').remove() : null;
                      } else {
                        Fluttertoast.showToast(
                            msg: "Only one can be selected",
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    } else {
                      if (isAddedTeam1 != true) {
                        Fluttertoast.showToast(
                            msg: "Please assign team A first",
                            toastLength: Toast.LENGTH_SHORT);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Same team cannot be selected twice",
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    }
                  },
                  child: Text(
                      thisTeam['state as team B'] != 'true' ? "Add" : "Remove",
                      style: TextStyle(color: Colors.black))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure match", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: 20.w, left: 30.w),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Team A",
                      style: TextStyle(
                          fontSize: 15.w,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
          ),
          Expanded(
            flex: 13,
            child: Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map teams = snapshot.value as Map;
                  teams['key'] = snapshot.key;
                  return listItemTeamA(thisTeam: teams);
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Team B",
                    style: TextStyle(
                        fontSize: 15.w,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map teams = snapshot.value as Map;
                  teams['key'] = snapshot.key;
                  return listItemTeamB(thisTeam: teams);
                },
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminAddPlayersToTeamA(
                          tId: widget.tId!,
                          tName: widget.tName!,
                          mId: widget.mId,
                        ),
                        //builder: (context) =>  AdminMatchesConfigurePage(uuid: widget.tId!, tournamentName: widget.tName!),
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
  State<AdminAddTeams> createState() => _AdminAddTeams();
}

class _AdminAddTeams extends State<AdminAddTeams> {
  late DatabaseReference dbRef2;
  bool isTennisBall = false;
  bool isLeatherBall = false;
  int numberOfPlayers = 0;
  TextEditingController teamNameController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();
  String ballType = "";
  String uuid = Uuid().v4();
  late String image_url;

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print("failed to pick image : $e");
    }
    var imageFile = File(image!.path);
    String fileName = Path.basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Team logo" + fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      var url = await ref.getDownloadURL();
      image_url = url.toString();
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    dbRef2 = FirebaseDatabase.instance.ref().child('Teams').child(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Teams", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 15,
            child: Container(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 25.w, left: 30.w),
                        child: Row(
                          children: [
                            SizedBox(
                                child: (image == null)
                                    ? Image.asset(
                                        "assets/add_tournament.jpg",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(image!, fit: BoxFit.cover),
                                height: MediaQuery.of(context).size.height / 5,
                                width: MediaQuery.of(context).size.width / 3),
                            Padding(
                              padding: EdgeInsets.only(left: 30.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  child: Text("Select logo",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.w)),
                                ),
                              ),
                            )
                          ],
                        )),
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
                        controller: teamNameController,
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
                        controller: shortNameController,
                        maxLength: 5,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(194, 173, 129, 1.0)),
                            hintText: "eg:- CSK"),
                        style:
                            (TextStyle(color: Colors.indigo, fontSize: 15.w)),
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
                  Map<String, String> teams = {
                    'id': uuid,
                    'name': teamNameController.text.trim(),
                    'short': shortNameController.text.trim(),
                    'image': image_url,
                    'state as team A': "Not",
                    'state as team B': "Not",
                  };
                  dbRef2.set(teams);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminSelectTournamentPage()),
                      (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Add players",
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
  State<AdminAddPlayers> createState() => _AdminAddPlayers();
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
        decoration: BoxDecoration(color: Color.fromRGBO(229, 227, 221, 1.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                      child: Text(
                        thisPlayer['name'],
                        style: TextStyle(fontSize: 15.w, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.w),
                      child: Text(
                        thisPlayer['contact'],
                        style: TextStyle(fontSize: 15.w, color: Colors.black),
                      ),
                    )
                  ]))),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {},
                  child: Text(
                    "Remove",
                    style: TextStyle(fontSize: 15.w, color: Colors.black),
                  )),
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
                      width: MediaQuery.of(context).size.width,
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
                            padding: EdgeInsets.only(
                                top: 2.w, left: 30.w, right: 30.w),
                            child: TextField(
                              controller: playerNameController,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- M.S.Dhoni"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
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
                            padding: EdgeInsets.only(
                                top: 2.w, left: 30.w, right: 30.w),
                            child: TextField(
                              controller: contactNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(194, 173, 129, 1.0)),
                                  hintText: "eg:- 077XXXXXXX"),
                              style: (TextStyle(
                                  color: Colors.indigo, fontSize: 15.w)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(112, 79, 25, 1.0)),
                              onPressed: () {
                                setState(() {
                                  uuid = Uuid().v4();
                                  dbRef2 = FirebaseDatabase.instance
                                      .ref()
                                      .child('Players')
                                      .child(uuid);
                                });
                                Map<String, String> players = {
                                  'name': playerNameController.text.trim(),
                                  'contact':
                                      contactNumberController.text.toString(),
                                  'id': uuid,
                                  "isAddedToTeamB": "false",
                                  "isAddedToTeamA": "false"
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
                      )),
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

class AdminAddPlayersToTeamA extends StatefulWidget {
  final String? tId;
  final String? mId;
  final String? tName;

  const AdminAddPlayersToTeamA(
      {super.key, required this.tId, required this.mId, required this.tName});

  @override
  State<AdminAddPlayersToTeamA> createState() => _AdminAddPlayersToTeamA();
}

class _AdminAddPlayersToTeamA extends State<AdminAddPlayersToTeamA> {
  late DatabaseReference dbRef1;
  late DatabaseReference dbRef2;
  Query dbQuery = FirebaseDatabase.instance.ref().child('Players');
  bool isAddedTeam1 = false;

  @override
  void initState() {
    super.initState();
    updateIsAdded();
  }

  void updateIsAdded() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Players");
    dbRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> players =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        players.forEach((key, value) {
          dbRef.child(key).update({"isAddedToTeamA": "false"});
          dbRef.child(key).update({"isAddedToTeamB": "false"});
        });
      }
    });
  }

  Widget listItemPlayersForTeamA({required Map thisPlayer}) {
    String? id = thisPlayer['id'];
    String? teamsAdded = thisPlayer['isAddedToTeamA'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(229, 227, 221, 1.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                    child: Text(
                      thisPlayer['name'],
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    ),
                  ))),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                  onPressed: () {
                    //  if (teamsAdded == 'true' || isAddedTeam1 == false) {
                    setState(() {
                      dbRef1 = FirebaseDatabase.instance
                          .ref()
                          .child('Tournaments')
                          .child(widget.tId!)
                          .child('Matches')
                          .child(widget.mId!);
                      //dbRef2 = FirebaseDatabase.instance.ref().child('Tournaments').child(widget.tId!).child('Matches').child(widget.mId!).child('Team-A');
                      dbRef2 = FirebaseDatabase.instance
                          .ref()
                          .child('Players')
                          .child(id!);
                      isAddedTeam1 = (teamsAdded != "true") ? false : true;
                      isAddedTeam1 = !isAddedTeam1;
                    });
                    Map<String, String> updatetThisTeam = {
                      'isAddedToTeamA': isAddedTeam1.toString()
                    };
                    dbRef2.update(updatetThisTeam);

                    Map<String, String> thisTeamToMatch = {
                      'name': thisPlayer['name']!,
                      'id': thisPlayer['id']!,
                    };

                    isAddedTeam1
                        ? dbRef1
                            .child('Team-A')
                            .child('Players')
                            .child(thisPlayer['id'])
                            .set(thisTeamToMatch)
                        : null;
                    !isAddedTeam1
                        ? dbRef1
                            .child('Team-A')
                            .child('Players')
                            .child(thisPlayer['id'])
                            .remove()
                        : null;
                    // } else {
                    //   Fluttertoast.showToast(msg: "Only one can be selected", toastLength: Toast.LENGTH_SHORT);
                    // }
                  },
                  child: Text(
                      thisPlayer['isAddedToTeamA'] != 'true' ? "Add" : "Remove",
                      style: TextStyle(color: Colors.black))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure match", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: 20.w, left: 30.w),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Team A",
                      style: TextStyle(
                          fontSize: 15.w,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
          ),
          Expanded(
            flex: 13,
            child: Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map players = snapshot.value as Map;
                  players['key'] = snapshot.key;
                  return listItemPlayersForTeamA(thisPlayer: players);
                },
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminAddPlayersToTeamB(
                            tId: widget.tId!,
                            tName: widget.tName!,
                            mId: widget.mId),
                        //builder: (context) =>  Admin(uuid: widget.tId!, tournamentName: widget.tName!),
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

class AdminAddPlayersToTeamB extends StatefulWidget {
  final String? tId;
  final String? mId;
  final String? tName;

  const AdminAddPlayersToTeamB(
      {super.key, required this.tId, required this.mId, required this.tName});

  @override
  State<AdminAddPlayersToTeamB> createState() => _AdminAddPlayersToTeamB();
}

class _AdminAddPlayersToTeamB extends State<AdminAddPlayersToTeamB> {
  late DatabaseReference dbRef1;
  late DatabaseReference dbRef2;
  Query dbQuery = FirebaseDatabase.instance.ref().child('Players');
  bool isAddedTeam2 = false;

  @override
  void initState() {
    super.initState();
  }

  Widget listItemPlayersForTeamB({required Map thisPlayer}) {
    String? id = thisPlayer['id'];
    String? teamsAddedA = thisPlayer['isAddedToTeamA'];
    String? teamsAdded = thisPlayer['isAddedToTeamB'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(229, 227, 221, 1.0)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: Color.fromRGBO(201, 169, 101, 1.0)),
                  onPressed: () {},
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                    child: Text(
                      thisPlayer['name'],
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    ),
                  ))),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: (0),
                    padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                    backgroundColor: Color.fromRGBO(229, 227, 221, 1.0)),
                onPressed: () {
                  if (teamsAddedA != 'true' || teamsAdded == 'true') {
                    setState(() {
                      dbRef1 = FirebaseDatabase.instance
                          .ref()
                          .child('Tournaments')
                          .child(widget.tId!)
                          .child('Matches')
                          .child(widget.mId!);
                      dbRef2 = FirebaseDatabase.instance
                          .ref()
                          .child('Players')
                          .child(id!);
                      isAddedTeam2 = (teamsAdded != "true") ? false : true;
                      isAddedTeam2 = !isAddedTeam2;
                    });
                    Map<String, String> updatetThisTeam = {
                      'isAddedToTeamB': isAddedTeam2.toString()
                    };
                    dbRef2.update(updatetThisTeam);

                    Map<String, String> thisTeamToMatch = {
                      'name': thisPlayer['name']!,
                      'id': thisPlayer['id']!,
                    };

                    isAddedTeam2
                        ? dbRef1
                            .child('Team-B')
                            .child('Players')
                            .child(thisPlayer['id'])
                            .set(thisTeamToMatch)
                        : null;
                    !isAddedTeam2
                        ? dbRef1
                            .child('Team-B')
                            .child('Players')
                            .child(thisPlayer['id'])
                            .remove()
                        : null;
                  } else {
                    Fluttertoast.showToast(
                        msg: "Already added to team A",
                        toastLength: Toast.LENGTH_SHORT);
                  }
                },
                child: _buildChild(thisPlayer: thisPlayer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChild({required Map thisPlayer}) {
    if (thisPlayer['isAddedToTeamA'] == 'true') {
      return Text(
        "Added",
        style: TextStyle(fontSize: 15.w, color: Colors.black),
      );
    } else if (thisPlayer['isAddedToTeamB'] == 'true') {
      return Text(
        "Remove",
        style: TextStyle(fontSize: 15.w, color: Colors.black),
      );
    } else {
      return Text(
        "Add",
        style: TextStyle(fontSize: 15.w, color: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure match", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: 20.w, left: 30.w),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Team B",
                      style: TextStyle(
                          fontSize: 15.w,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
          ),
          Expanded(
            flex: 13,
            child: Padding(
              padding: EdgeInsets.only(top: 10.w, bottom: 25.w),
              child: FirebaseAnimatedList(
                query: dbQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map players = snapshot.value as Map;
                  players['key'] = snapshot.key;
                  return listItemPlayersForTeamB(thisPlayer: players);
                },
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminMatchesConfigurePage(
                            uuid: widget.tId!, tournamentName: widget.tName!),
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

class AdminTossSelect extends StatefulWidget {
  final String? tId;
  final String? mId;

  const AdminTossSelect({super.key, required this.tId, required this.mId});

  @override
  State<StatefulWidget> createState() => _AdminTossSelect();
}

class _AdminTossSelect extends State<AdminTossSelect> {
  late Future<String> team_A_Name;
  late Future<String> team_B_Name;

  @override
  void initState() {
    super.initState();
    team_A_Name = getTeamName('Team-A');
    team_B_Name = getTeamName('Team-B');
  }

  Future<String> getTeamName(String team) async {
    //DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Tournaments/${widget.tId}/Matches/${widget.mId}/$team/team name");
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/$team/id");
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      DatabaseReference dbRef2 = FirebaseDatabase.instance
          .ref()
          .child("Teams/${snapshot.value}/short");
      DatabaseEvent event2 = await dbRef2.once();
      DataSnapshot snapshot2 = event2.snapshot;
      if (snapshot2.value != null) {
        return snapshot2.value.toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Toss", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/add_tournament.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(top: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: Text(
                      "Which team won the toss ?",
                      style: TextStyle(color: Colors.black, fontSize: 20.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, fixedSize: Size.fromWidth(100.h)),
                      onPressed: () {},
                      child: FutureBuilder<String>(
                        future: team_A_Name,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                              child: Text(snapshot.data ?? '',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.w)),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.w),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, fixedSize: Size.fromWidth(100.h)),
                      onPressed: () {},
                      child: FutureBuilder<String>(
                        future: team_B_Name,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                              child: Text(snapshot.data ?? '',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.w)),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.only(top: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: Text(
                      "What they choose ?",
                      style: TextStyle(color: Colors.black, fontSize: 20.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.w),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.w, bottom: 10.w, right: 10.w, left: 10.w),
                          child: Text("Batting",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.w)),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.w, bottom: 10.w, right: 10.w, left: 10.w),
                          child: Text("Bowling",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.w)),
                        )),
                  )
                ],
              ),
            ),
          )
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
                  /*
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSelectTournamentPage(),
                      ),
                          (route) => false);

                   */
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
                  /*
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminMatchesConfigurePage(
                            uuid: widget.tId!, tournamentName: widget.tName!),
                      ),
                          (route) => false);

                   */
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Start Match",
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

class AdminScoreChangePage extends StatefulWidget {
  const AdminScoreChangePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminScoreChange();
}

class _AdminScoreChange extends State<AdminScoreChangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text("Scoring", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color.fromRGBO(197, 139, 48, 1.0),
        toolbarHeight: 45.w,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '100/',
                        style: TextStyle(fontSize: 25.w),
                      ),
                      Text(
                        '5',
                        style: TextStyle(fontSize: 25.w),
                      ),
                      Text(
                        '  (1.4/10)',
                        style: TextStyle(fontSize: 15.w),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.w,
                    ),
                    child: Text(
                      "CSK is Bowling now",
                      style: TextStyle(fontSize: 15.w),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(flex: 2, child: Container(
            child: Column(
              children: [
                Expanded(flex:1,child: Padding(
                  padding:  EdgeInsets.only(left:40.w),
                  child: Align(alignment: Alignment.centerLeft,child: Text("Rohit sharma (now) : 30 (40) ",style: TextStyle(
                    fontSize: 15.w
                  ),)),
                )),
                Expanded(flex:1,child: Padding(
                  padding: EdgeInsets.only(left:40.w),
                  child: Align(alignment: Alignment.centerLeft,child: Text("Virat kholi (now) : 30 (40) ",style: TextStyle(
                      fontSize: 15.w
                  ))),
                ))
              ],
            ),
          )),
          Expanded(flex: 2, child: Container(color:Colors.amber,child:Padding(
            padding:  EdgeInsets.only(left:40.w),
            child: Align(alignment: Alignment.centerLeft,child: Text("Harbajan singh : 30/4 (3.5) ",style: TextStyle(
                fontSize: 15.w
            ),)),
          ))),
          Expanded(flex: 2, child: Container(color: Colors.deepOrange)),
          Expanded(
            flex: 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.indigoAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Material(
                              child: InkWell(
                                onTap: () {},
                                splashColor: Colors.black87,
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 25.w),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Material(
                              child: InkWell(
                                  onTap: () {},
                                  splashColor: Colors.black87,
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white54,
                                          shape: BoxShape.rectangle,
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                          child: Text("1",
                                              style:
                                                  TextStyle(fontSize: 25.w))))),
                            )),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("2",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("3",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("4",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("5",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("6",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("7",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("WD",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("NB",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("BYE",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("LB",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("Cancel",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("OUT",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Text("UNDO",
                                            style:
                                                TextStyle(fontSize: 25.w))))))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
