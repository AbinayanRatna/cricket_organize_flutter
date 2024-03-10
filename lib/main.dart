import 'dart:async';
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
  late String Status;
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
        .child('Tournaments/${widget.uuid}/Matches')
        .orderByChild("Status");
  }

  Future<String> textStatus({required String mId}) async {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.uuid}/Matches/$mId/Status");
    String teamAName = 'Team-A';
    String teamBName = 'Team-B';
    DatabaseReference dbRef2 = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.uuid}/Matches/$mId/Team-A/team name");
    DatabaseReference dbRef3 = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.uuid}/Matches/$mId/Team-B/team name");
    DatabaseEvent event2 = await dbRef2.once();
    DatabaseEvent event3 = await dbRef3.once();
    DataSnapshot snapshot2 = event2.snapshot;
    DataSnapshot snapshot3 = event3.snapshot;
    if ((snapshot2.value != null) && (snapshot3.value != null)) {
      teamAName = snapshot2.value.toString();
      teamBName = snapshot3.value.toString();
    }

    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      print("newnew : " + snapshot.value.toString());
      switch (snapshot.value.toString()) {
        case 'Tossed':
          {
            return ('$teamAName vs $teamBName - Configure');
          }

        case 'Initialized':
          {
            return ('Match -Add teams');
          }

        case 'Players-initialized':
          {
            return ('$teamAName vs $teamBName -Toss select');
          }

        case 'Finished':
          {
            return ('$teamAName vs $teamBName -Finished');
          }

        case 'settingsUpdated':
          {
            return ('$teamAName vs $teamBName -Start');
          }
        default:
          {
            return ('Match -Configure');
          }
      }
    } else {
      return ('$teamAName vs $teamBName -Resume');
    }
  }

  Widget listItem({required Map thisMatch}) {
    Future<String> matchStatus = textStatus(mId: thisMatch['id']);
    String matchStatusRetireve = thisMatch['Status'];
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
            elevation: (0),
            padding: (EdgeInsets.only(top: 20.w, bottom: 20.w))),
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
                            tName: widget.tournamentName,
                            tId: widget.uuid,
                            mId: thisMatch['id'],
                          )),
                  (route) => false);

          if (matchStatusRetireve == 'Initialized') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminAddTeamToMatches(
                          tId: widget.uuid,
                          mId: thisMatch['id'],
                          tName: widget.tournamentName,
                        )),
                (route) => false);
          } else if (matchStatusRetireve == 'Players-initialized') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminTossSelect(
                          tName: widget.tournamentName,
                          tId: widget.uuid,
                          mId: thisMatch['id'],
                        )),
                (route) => false);
          } else if (matchStatusRetireve == 'Tossed') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminMatchSettingsChange(
                        tName: widget.tournamentName,
                        tId: widget.uuid,
                        mId: thisMatch['id'])),
                (route) => false);
          } else if (matchStatusRetireve == 'settingsUpdated') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminScoreChangePage(
                          mId: thisMatch['id'],
                          tId: widget.uuid,
                        )),
                (route) => false);
          }
        },
        child: FutureBuilder<String>(
          future: matchStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                child: Text(snapshot.data ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 12.w)),
              );
            }
          },
        ),
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

                        Map<String, String> matches = {
                          "id": uuid,
                          "definedOrNot": "Not",
                          "TeamA-defined": "Not",
                          "TeamB-defined": "Not",
                          "Status": "Initialized",
                          "Settings": 'not-updated',
                          "Now Batting": "Not",
                          "Now Bowling": "Not",
                          "First innings finished": "Not",
                          "Second innings finished": "Not",
                        };

                        Map<String, int> statisctics = {
                          "Runs": 0,
                          "Wickets_given": 0,
                        };

                        referenceMatches.set(matches);

                        referenceMatches
                            .child('Statistics/Team-A')
                            .update(statisctics);
                        referenceMatches
                            .child('Statistics/Team-B')
                            .update(statisctics);
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
                    return Column(children: [listItem(thisMatch: matches)]);
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
                  Map<String, String> playersInitialized = {
                    "Status": "Players-initialized",
                  };
                  dbRef1 = FirebaseDatabase.instance
                      .ref()
                      .child('Tournaments/${widget.tId}/Matches/${widget.mId}');
                  dbRef1.update(playersInitialized);
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
  final String? tName;

  const AdminTossSelect(
      {super.key, required this.tId, required this.mId, required this.tName});

  @override
  State<StatefulWidget> createState() => _AdminTossSelect();
}

class _AdminTossSelect extends State<AdminTossSelect> {
  String team_A_Name = 'Team A';
  String team_B_Name = 'Team B';
  bool isTeamATossWin = false;
  bool isTeamBTossWin = false;
  bool isBattingSelected = false;
  bool isBowlingSelected = false;
  late DatabaseReference dbRef1;
  late StreamSubscription teamANameSubscription;
  late StreamSubscription teamBNameSubscription;

  @override
  void initState() {
    super.initState();
    DatabaseReference teamARef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/Team-A/id");
    teamARef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        DatabaseReference teamNameRef = FirebaseDatabase.instance
            .ref()
            .child("Teams/${snapshot.value}/short");
        teamANameSubscription = teamNameRef.onValue.listen((event2) {
          DataSnapshot snapshot2 = event2.snapshot;
          if (snapshot2.value != null) {
            setState(() {
              team_A_Name = snapshot2.value.toString();
            });
          }
        });
      }
    });

    // Set up the database subscription for Team-B name
    DatabaseReference teamBRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/Team-B/id");
    teamBRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        DatabaseReference teamNameRef = FirebaseDatabase.instance
            .ref()
            .child("Teams/${snapshot.value}/short");
        teamBNameSubscription = teamNameRef.onValue.listen((event3) {
          DataSnapshot snapshot3 = event3.snapshot;
          if (snapshot3.value != null) {
            setState(() {
              team_B_Name = snapshot3.value.toString();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the database subscriptions when the widget is disposed
    teamANameSubscription.cancel();
    teamBNameSubscription.cancel();
    super.dispose();
  }

  Future<String> getTeamName(String team) async {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/$team/id");

    Completer<String> completer = Completer<String>();

    dbRef.onValue.listen((event) async {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        DatabaseReference dbRef2 = FirebaseDatabase.instance
            .ref()
            .child("Teams/${snapshot.value}/short");
        dbRef2.onValue.listen((event2) async {
          DataSnapshot snapshot2 = event2.snapshot;
          if (snapshot2.value != null) {
            completer.complete(snapshot2.value.toString());
          } else {
            completer.complete("");
          }
        });
      } else {
        completer.complete("");
      }
    });

    return completer.future;
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
                          elevation: 0,
                          fixedSize: Size.fromWidth(100.h),
                          backgroundColor: (isTeamATossWin && !isTeamBTossWin)
                              ? const Color.fromRGBO(197, 139, 48, 1.0)
                              : const Color.fromRGBO(30, 75, 199, 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isTeamATossWin = true;
                            isTeamBTossWin = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                          child: Text(team_A_Name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.w)),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 15.w),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: Size.fromWidth(100.h),
                          backgroundColor: (!isTeamATossWin && isTeamBTossWin)
                              ? const Color.fromRGBO(197, 139, 48, 1.0)
                              : const Color.fromRGBO(30, 75, 199, 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isTeamATossWin = false;
                            isTeamBTossWin = true;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                          child: Text(team_B_Name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.w)),
                        )),
                  ),
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
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              (!isBowlingSelected && isBattingSelected)
                                  ? const Color.fromRGBO(197, 139, 48, 1.0)
                                  : const Color.fromRGBO(30, 75, 199, 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isBattingSelected = true;
                            isBowlingSelected = false;
                          });
                        },
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
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              (isBowlingSelected && !isBattingSelected)
                                  ? const Color.fromRGBO(197, 139, 48, 1.0)
                                  : const Color.fromRGBO(30, 75, 199, 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isBattingSelected = false;
                            isBowlingSelected = true;
                          });
                        },
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
                  Map<String, String> tossWinTeam = {
                    "Toss_win": "Not selected",
                  };

                  String winTeamName = 'No defined';
                  String lossTeamName = 'No defined';
                  setState(() {
                    dbRef1 = FirebaseDatabase.instance.ref().child(
                        "Tournaments/${widget.tId}/Matches/${widget.mId}");
                    if ((!isTeamBTossWin && !isTeamATossWin) ||
                        (!isBattingSelected && !isBowlingSelected)) {
                      null;
                    } else if (!isTeamBTossWin && isTeamATossWin) {
                      winTeamName = 'Team-A';
                      lossTeamName = 'Team-B';
                      if (isBattingSelected) {
                        tossWinTeam = {
                          "Toss_win": "Team-A",
                          "Status": "Tossed",
                          "Now Batting": "Team-A",
                          "Now Bowling": "Team-B",
                        };
                      } else if (isBowlingSelected) {
                        tossWinTeam = {
                          "Toss_win": "Team-A",
                          "Status": "Tossed",
                          "Now Batting": "Team-B",
                          "Now Bowling": "Team-A",
                        };
                      }
                    } else {
                      lossTeamName = 'Team-A';
                      winTeamName = 'Team-B';
                      if (isBattingSelected) {
                        tossWinTeam = {
                          "Toss_win": "Team-B",
                          "Status": "Tossed",
                          "Now Batting": "Team-B",
                          "Now Bowling": "Team-A",
                        };
                      } else if (isBowlingSelected) {
                        tossWinTeam = {
                          "Toss_win": "Team-B",
                          "Status": "Tossed",
                          "Now Batting": "Team-A",
                          "Now Bowling": "Team-B",
                        };
                      }
                    }
                    dbRef1.update(tossWinTeam);
                  });

                  if ((!isTeamBTossWin && !isTeamATossWin) ||
                      (!isBattingSelected && !isBowlingSelected)) {
                    null;
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminMatchesConfigurePage(
                              uuid: widget.tId!, tournamentName: widget.tName!),
                        ),
                        (route) => false);
                  }
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
  final tId, mId;

  const AdminScoreChangePage({super.key, required this.mId, required this.tId});

  @override
  State<StatefulWidget> createState() => _AdminScoreChange();
}

class _AdminScoreChange extends State<AdminScoreChangePage> {
  String battingTeam = 'teamA';
  String bowlingTeam = 'teamB';
  String battingTeamRuns = '0';
  String wicketsNow = '0';
  String oversFinished = '0';
  String totalBallsFinished = '0';
  String ballsInAnOver = '0';
  String totalOvers = '0';
  String nowBattingName = '0';
  String nowBattingId = '0';
  String nowBattingRuns = '0';
  String nowBattingBalls = '0';
  String nowBattingSix = '0';
  String nowBattingFour = '0';
  String nextBattingName = '0';
  String nextBattingId = '0';
  String nextBattingRuns = '0';
  String nextBattingBalls = '0';
  String nextBattingSix = '0';
  String nextBattingFours = '0';
  String bowlingPlayerName = '0';
  String bowlingPlayerId = '0';
  String bowlingPlayerWickets = '0';
  String bowlingPlayerRuns = '0';
  String bowlingPlayerBalls = '0';
  String currentRunRate = '0';
  String runsForWide = '0';
  String runsForNB = '0';
  bool isFirstInningsFinished = false;
  bool isSecondInningsFinished = false;
  final TextEditingController controller = TextEditingController(text: '0');
  late StreamSubscription battingTeamNameSubscription;
  late StreamSubscription bowlingTeamNameSubscription;
  late StreamSubscription ballsInAnOverSubscription;
  late StreamSubscription totalOverSubscription;
  late StreamSubscription wicketsNowSubscription;
  late StreamSubscription firstInningsFinishedSubscription;
  late StreamSubscription secondInningsFinishedSubscription;

  @override
  void initState() {
    super.initState();

    DatabaseReference firstInningsFinishedRef = FirebaseDatabase.instance
        .ref()
        .child(
            "Tournaments/${widget.tId}/Matches/${widget.mId}/First innings finished");
    firstInningsFinishedSubscription =
        firstInningsFinishedRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          (snapshot.value.toString() == 'true')
              ? isFirstInningsFinished = true
              : isFirstInningsFinished = false;
        });
      }
    });

    DatabaseReference secondInningsFinishedRef = FirebaseDatabase.instance
        .ref()
        .child(
            "Tournaments/${widget.tId}/Matches/${widget.mId}/Second innings finished");
    secondInningsFinishedSubscription =
        secondInningsFinishedRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          (snapshot.value.toString() == 'true')
              ? isSecondInningsFinished = true
              : isSecondInningsFinished = false;
        });
      }
    });

    DatabaseReference battingTeamRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/Now Batting");
    battingTeamNameSubscription = battingTeamRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          DatabaseReference batingTeamRef2 = FirebaseDatabase.instance.ref().child(
              "Tournaments/${widget.tId}/Matches/${widget.mId}/${snapshot.value.toString()}/team name");
          batingTeamRef2.onValue.listen((event) {
            DataSnapshot snapshot = event.snapshot;
            if (snapshot.value != null) {
              setState(() {
                battingTeam = snapshot.value.toString();
              });
            }
          });
        });
      }
    });

    DatabaseReference bowlingTeamRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Matches/${widget.mId}/Now Bowling");
    bowlingTeamNameSubscription = bowlingTeamRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          DatabaseReference bowlingTeamRef2 = FirebaseDatabase.instance.ref().child(
              "Tournaments/${widget.tId}/Matches/${widget.mId}/${snapshot.value.toString()}/team name");
          bowlingTeamRef2.onValue.listen((event) {
            DataSnapshot snapshot = event.snapshot;
            if (snapshot.value != null) {
              setState(() {
                bowlingTeam = snapshot.value.toString();
              });
            }
          });
        });
      }
    });

    DatabaseReference ballsInAnOverRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/balls in an over");
    ballsInAnOverSubscription = ballsInAnOverRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          ballsInAnOver = snapshot.value.toString();
        });
      }
    });

    DatabaseReference totalOverRef = FirebaseDatabase.instance
        .ref()
        .child("Tournaments/${widget.tId}/Overs");
    totalOverSubscription = totalOverRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          totalOvers = snapshot.value.toString();
        });
      }
    });

    obtainDetails('innings_runs');
    obtainDetails('innings_overs');
    obtainDetails('innings_wicket');
    obtainDetails('bowler_wickets');
    obtainDetails('bowler_runs');
    obtainDetails('bowler_balls');
    obtainDetails('bowler_name');
    obtainDetails('bowler_id');
    obtainDetails('now_batsman_six');
    obtainDetails('now_batsman_four');
    obtainDetails('now_batsman_balls');
    obtainDetails('now_batsman_runs');
    obtainDetails('next_batsman_six');
    obtainDetails('next_batsman_four');
    obtainDetails('next_batsman_balls');
    obtainDetails('next_batsman_runs');
    obtainDetails('now_batting_name');
    obtainDetails('now_batting_id');
    obtainDetails('next_batting_name');
    obtainDetails('next_batting_id');
    obtainDetails('innings_balls');
    obtainDetails('Current_run_rate');
    obtainDetails('runsForWide');
    obtainDetails('runsForNB');
  }

  void runsAdd(String runs, bool isWicket, bool isSwap,
      {bool isFour = false, bool isSix = false}) {
    print("newnew :wide nb " + '$runsForWide $runsForNB');
    String newRuns = (int.parse(runs) + int.parse(battingTeamRuns)).toString();
    print("newnew : " + '2');
    String nowBatsmenRuns =
        (int.parse(runs) + int.parse(nowBattingRuns)).toString();
    print("newnew : " + '3');
    String nowBatsmenBalls = (1 + int.parse(nowBattingBalls)).toString();
    print("newnew : " + '4');
    String nowBowlerRuns =
        (int.parse(runs) + int.parse(bowlingPlayerRuns)).toString();
    print("newnew : " + '5');
    String BowlerBalls = (1 + int.parse(bowlingPlayerBalls)).toString();
    print("newnew : " + '6');
    String newInningsBalls = (1 + int.parse(totalBallsFinished)).toString();
    print("newnew : " + '7');
    int oversWholeNumberNow =
        int.parse(newInningsBalls) ~/ int.parse(ballsInAnOver);
    print("newnew : " + '8');
    int remainingBallsNow =
        int.parse(newInningsBalls) % int.parse(ballsInAnOver);
    print("newnew : " + '9');
    String newInningsOvers =
        (oversWholeNumberNow + (remainingBallsNow / 10)).toString();
    print("newnew : " + '10');

    if (runs == '4' && isFour == true) {
      nowBattingFour = (int.parse(nowBattingFour) + 1).toString();
    }

    if (runs == '6' && isSix == true) {
      nowBattingSix = (int.parse(nowBattingSix) + 1).toString();
    }

    currentRunRate = double.parse(
            (double.parse(newRuns) / double.parse(newInningsOvers))
                .toStringAsFixed(2))
        .toString();

    if (isSwap == true) {
      print("newnew : " + '11');
      String tempName = nowBattingName;
      String tempRuns = nowBatsmenRuns;
      String tempBalls = nowBatsmenBalls;
      String tempFour = nowBattingFour;
      String tempSix = nowBattingSix;
      String tempId = nowBattingId;
      print('newnewnew : $tempId + $tempBalls + $tempRuns +$tempName');
      print("newnew : " + '12');
      nowBattingName = nextBattingName;
      nowBattingId = nextBattingId;
      nowBatsmenBalls = nextBattingBalls;
      nowBatsmenRuns = nextBattingRuns;
      nowBattingFour = nextBattingFours;
      print(
          'newnewnew : $nowBattingId + $nowBattingBalls + $nowBattingRuns +$nowBattingName');
      print("newnew : " + '13');
      nowBattingSix = nextBattingSix;
      nextBattingName = tempName;
      nextBattingId = tempId;
      nextBattingBalls = tempBalls;
      nextBattingRuns = tempRuns;
      nextBattingFours = tempFour;
      nextBattingSix = tempSix;
      print(
          'newnewnew : $nextBattingId + $nextBattingName+ $nextBattingBalls + $nextBattingRuns ');
      print("newnew : " + '14');
    }
    print("newnew : " + '15');
    DatabaseReference battingRunsRef = FirebaseDatabase.instance.ref().child(
        "Tournaments/${widget.tId}/Matches/${widget.mId}/Statistics/firstInnings");
    Map<String, String> statisticsForBall = {
      "innings_runs": newRuns,
      "innings_wicket": wicketsNow,
      "innings_overs": newInningsOvers,
      'bowler_name': bowlingPlayerName,
      'innings_balls': newInningsBalls,
      'bowler_id': bowlingPlayerId,
      'now_batting_name': nowBattingName,
      'now_batting_id': nowBattingId,
      'next_batting_name': nextBattingName,
      'next_batting_id': nextBattingId,
      'bowler_balls': BowlerBalls,
      'bowler_runs': nowBowlerRuns,
      'bowler_wicket': bowlingPlayerWickets,
      'now_batsman_runs': nowBatsmenRuns,
      'now_batsman_balls': nowBatsmenBalls,
      'now_batsman_four': nowBattingFour,
      'now_batsman_six': nowBattingSix,
      'next_batsman_runs': nextBattingRuns,
      'next_batsman_balls': nextBattingBalls,
      'next_batsman_four': nextBattingFours,
      'next_batsman_six': nextBattingSix,
      'Current_run_rate': currentRunRate,
      'runsForNB': runsForNB,
      'runsForWide': runsForWide
    };
    print("newnew : " + '16');
    battingRunsRef.push().update(statisticsForBall);
    print("newnew : " + '17');
  }

  void obtainDetails(String reference) {
    DatabaseReference battingRunsRef = FirebaseDatabase.instance.ref().child(
        "Tournaments/${widget.tId}/Matches/${widget.mId}/Statistics/firstInnings");
    wicketsNowSubscription =
        battingRunsRef.orderByKey().limitToLast(1).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && data.isNotEmpty) {
          String lastKey = data.keys.first;
          Map<dynamic, dynamic>? lastNode =
              data[lastKey] as Map<dynamic, dynamic>?; // Explicit casting

          // Check if the last node contains the 'bowler_name' key
          if (lastNode != null && lastNode.containsKey(reference)) {
            dynamic nowRetrieved = lastNode[reference];

            if (nowRetrieved != null) {
              setState(() {
                switch (reference) {
                  case 'innings_runs':
                    {
                      battingTeamRuns = nowRetrieved.toString();
                    }
                  case 'innings_overs':
                    {
                      oversFinished = nowRetrieved.toString();
                    }
                  case 'innings_wicket':
                    {
                      wicketsNow = nowRetrieved.toString();
                    }
                  case 'now_batting_name':
                    {
                      nowBattingName = nowRetrieved.toString();
                    }
                  case 'innings_balls':
                    {
                      totalBallsFinished = nowRetrieved.toString();
                    }
                  case 'now_batting_id':
                    {
                      nowBattingId = nowRetrieved.toString();
                    }
                  case 'runsForWide':
                    {
                      runsForWide = nowRetrieved.toString();
                    }
                  case 'runsForNB':
                    {
                      runsForNB = nowRetrieved.toString();
                    }
                    print('newnewnew nnowww : $runsForNB , $runsForWide');
                  case 'next_batting_id':
                    {
                      nextBattingId = nowRetrieved.toString();
                    }
                  case 'next_batting_name':
                    {
                      nextBattingName = nowRetrieved.toString();
                    }
                  case 'next_batsman_runs':
                    {
                      nextBattingRuns = nowRetrieved.toString();
                    }
                  case 'Current_run_rate':
                    {
                      currentRunRate = nowRetrieved.toString();
                    }
                  case 'next_batsman_balls':
                    {
                      nextBattingBalls = nowRetrieved.toString();
                    }
                  case 'next_batsman_four':
                    {
                      nextBattingFours = nowRetrieved.toString();
                    }
                  case 'next_batsman_six':
                    {
                      nextBattingSix = nowRetrieved.toString();
                    }
                  case 'now_batsman_runs':
                    {
                      nowBattingRuns = nowRetrieved.toString();
                    }
                  case 'now_batsman_balls':
                    {
                      nowBattingBalls = nowRetrieved.toString();
                    }
                  case 'now_batsman_four':
                    {
                      nowBattingFour = nowRetrieved.toString();
                    }
                  case 'now_batsman_six':
                    {
                      nowBattingSix = nowRetrieved.toString();
                    }
                  case 'bowler_name':
                    {
                      bowlingPlayerName = nowRetrieved.toString();
                    }
                  case 'bowler_id':
                    {
                      bowlingPlayerId = nowRetrieved.toString();
                    }
                  case 'bowler_balls':
                    {
                      bowlingPlayerBalls = nowRetrieved.toString();
                    }
                  case 'bowler_runs':
                    {
                      bowlingPlayerRuns = nowRetrieved.toString();
                    }
                  case 'bowler_wicket':
                    {
                      bowlingPlayerWickets = nowRetrieved.toString();
                    }
                }
              });
            }
          }
        } else {
          print("No data available at the specified path.");
        }
      } else {
        print("Snapshot 34is null or empty.");
      }
    }, onError: (Object error) {
      print("Error: $error");
    });
  }

  String bowlerOverReturn(String ballsInAnOver, String bowlerBalls) {
    int overs = int.parse(bowlerBalls) ~/ int.parse(ballsInAnOver);
    int remainingBalls = int.parse(bowlerBalls) % int.parse(ballsInAnOver);
    // "$bowlingPlayerName : $bowlingPlayerRuns/$bowlingPlayerWickets (${(int.parse(bowlingPlayerBalls)/int.parse(totalOvers)).toString()}) ",

    return ((overs + (remainingBalls / 10)).toString());
    //return (('int.parse(bowlerBalls) ~/ int.parse(ballsInAnOver)'+('int.parse(bowlerBalls) % int.parse(ballsInAnOver)'/10)).toString());
  }

  Widget textTool() {
    int x = int.parse(bowlingPlayerBalls);
    if (x > 0) {
      return Text(
          style: TextStyle(fontSize: 15.w),
          '$bowlingPlayerName : $bowlingPlayerRuns/$bowlingPlayerWickets (' +
              (((int.parse(bowlingPlayerBalls) ~/ int.parse(ballsInAnOver) +
                          (int.parse(bowlingPlayerBalls) %
                              int.parse(ballsInAnOver) /
                              10))
                      .toString()) +
                  ')'));
    } else {
      return Text(
        '$bowlingPlayerName : $bowlingPlayerRuns/$bowlingPlayerWickets (0)',
        style: TextStyle(fontSize: 15.w),
      );
    }
  }

  @override
  void dispose() {
    // Cancel the database subscriptions when the widget is disposed
    battingTeamNameSubscription.cancel();
    firstInningsFinishedSubscription.cancel();
    secondInningsFinishedSubscription.cancel();
    bowlingTeamNameSubscription.cancel();
    wicketsNowSubscription.cancel();
    totalOverSubscription.cancel();
    ballsInAnOverSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text("Scoring", style: TextStyle(fontSize: 20.sp)),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        ],
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
                        battingTeamRuns + "/",
                        style: TextStyle(fontSize: 25.w),
                      ),
                      Text(
                        wicketsNow,
                        style: TextStyle(fontSize: 25.w),
                      ),
                      Text(
                        '  ($oversFinished/$totalOvers)',
                        style: TextStyle(fontSize: 15.w),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.w,
                    ),
                    child: Text(
                      "$bowlingTeam is Bowling now",
                      style: TextStyle(fontSize: 15.w),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.w,
                    ),
                    child: Text(
                      "CRR : $currentRunRate",
                      style: TextStyle(fontSize: 15.w),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.w),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$nowBattingName : $nowBattingRuns ($nowBattingBalls) *",
                                style: TextStyle(fontSize: 15.w),
                              )),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.w),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "$nextBattingName : $nextBattingRuns ($nextBattingBalls) ",
                                  style: TextStyle(fontSize: 15.w))),
                        ))
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                  color: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.w),
                    child: Align(
                        alignment: Alignment.centerLeft, child: textTool()),
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
                                onTap: () {
                                  runsAdd('0', false, false);
                                },
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
                                  onTap: () {
                                    runsAdd('1', false, true);
                                  },
                                  splashColor: Colors.black87,
                                  child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
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
                                    onTap: () {
                                      runsAdd('2', false, false);
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("2",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {
                                      runsAdd('3', false, true);
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("3",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
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
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("4 runs taken by"),
                                              actions: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w,
                                                                right: 10.w),
                                                        child: ElevatedButton(
                                                          child: const Text(
                                                              'Boundary Hit'),
                                                          onPressed: () {
                                                            runsAdd('4', false,
                                                                false,
                                                                isFour: true);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w,
                                                                right: 10.w),
                                                        child: ElevatedButton(
                                                          child: const Text(
                                                              'By running'),
                                                          onPressed: () {
                                                            runsAdd('4', false,
                                                                false,
                                                                isFour: false);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("4",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {
                                      runsAdd('5', false, true);
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("5",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Select option"),
                                              actions: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextButton(
                                                        child: const Text(
                                                            'Boundary Hit'),
                                                        onPressed: () {
                                                          runsAdd(
                                                              '6', false, false,
                                                              isSix: true);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextButton(
                                                        child: const Text(
                                                            'By running'),
                                                        onPressed: () {
                                                          runsAdd(
                                                              '6', false, false,
                                                              isSix: false);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("6",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {
                                      runsAdd('7', false, true);
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("7",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
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
                                    onTap: () {
                                      {

                                      }
                                    },
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("WD",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("NB",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("BYE",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("LB",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
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
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("OUT",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
                        Expanded(
                            flex: 1,
                            child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Colors.black87,
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text("UNDO",
                                                style: TextStyle(
                                                    fontSize: 25.w))))))),
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

class AdminMatchSettingsChange extends StatefulWidget {
  final String tId, mId, tName;

  AdminMatchSettingsChange(
      {super.key, required this.tId, required this.tName, required this.mId});

  @override
  State<StatefulWidget> createState() => _AdminMatchSettingsChange();
}

class _AdminMatchSettingsChange extends State<AdminMatchSettingsChange> {
  int wideRuns = 1;
  int noBallRuns = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Setting"), actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminScoreChangePage(
                          mId: widget.mId, tId: widget.tId)),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back))
      ]),
      body: Padding(
        padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text("Runs for wide : ",
                        style: TextStyle(fontSize: 20.w))),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          wideRuns++;
                        });
                      },
                      child: Center(
                          child: Text("+", style: TextStyle(fontSize: 25.w)))),
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text("$wideRuns",
                            style: TextStyle(fontSize: 20.w)))),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (wideRuns > 0) {
                            wideRuns--;
                          }
                        });
                      },
                      child: Center(
                          child: Text("-", style: TextStyle(fontSize: 25.w)))),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text("Runs for noball : ",
                          style: TextStyle(fontSize: 20.w))),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            noBallRuns++;
                          });
                        },
                        child: Center(
                            child:
                                Text("+", style: TextStyle(fontSize: 25.w)))),
                  ),
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: Text("$noBallRuns",
                              style: TextStyle(fontSize: 20.w)))),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (noBallRuns > 0) {
                              noBallRuns--;
                            }
                          });
                        },
                        child: Center(
                            child:
                                Text("-", style: TextStyle(fontSize: 25.w)))),
                  )
                ],
              ),
            )
          ],
        ),
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
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () {
                  DatabaseReference referenceMatches = FirebaseDatabase.instance
                      .ref()
                      .child('Tournaments/${widget.tId}/Matches')
                      .child(widget.mId);
                  Map<String, String> statiscticsInitiaizationFirstBall = {
                    "innings_runs": '0',
                    "innings_wicket": '0',
                    "innings_balls": '0',
                    "innings_overs": '0.0',
                    'bowler_name': 'not',
                    'bowler_id': 'not',
                    'now_batting_name': 'not',
                    'now_batting_id': 'not',
                    'next_batting_name': 'not',
                    'next_batting_id': 'not',
                    'bowler_balls': '0',
                    'bowler_runs': '0',
                    'bowler_wicket': '0',
                    'now_batsman_runs': '0',
                    'now_batsman_balls': '0',
                    'now_batsman_four': '0',
                    'now_batsman_six': '0',
                    'next_batsman_runs': '0',
                    'next_batsman_balls': '0',
                    'next_batsman_four': '0',
                    'next_batsman_six': '0',
                    'Current_run_rate': '0',
                    'runsForWide': wideRuns.toString(),
                    'runsForNB': noBallRuns.toString(),
                  };
                  referenceMatches
                      .child('Statistics/firstInnings')
                      .push()
                      .set(statiscticsInitiaizationFirstBall);
                  referenceMatches
                      .child('Statistics/secondInnings')
                      .push()
                      .set(statiscticsInitiaizationFirstBall);
                  Map<String, String> statusUpdate = {
                    "Status": "settingsUpdated",
                  };

                  referenceMatches.update(statusUpdate);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminMatchesConfigurePage(
                            tournamentName: widget.tName, uuid: widget.tId),
                      ),
                      (route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Resume Match",
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
