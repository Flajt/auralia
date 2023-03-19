import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../logic/services/BehaviourUploadService.dart';

class UserBehaviourPage extends StatefulWidget {
  const UserBehaviourPage({Key? key}) : super(key: key);

  @override
  State<UserBehaviourPage> createState() => _UserBehaviourPageState();
}

class _UserBehaviourPageState extends State<UserBehaviourPage> {
  final DBServiceA dbService = IsarDBService();
  final columns2 = const [
    DataColumn2(label: Text("Id"), fixedWidth: 40),
    DataColumn2(label: Text("Activity")),
    DataColumn(label: Text("DateTimeInMs")),
    DataColumn2(label: Text("Artists")),
    DataColumn2(label: Text("Genres")),
    DataColumn2(label: Text("Location"))
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final behaviourUploadService =
        BehaviourUploadService(jwt: "", getIt: GetIt.I);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            body: SizedBox.fromSize(
                size: size,
                child: FutureBuilder(
                    future: dbService.getAll(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final data = snapshot.data!;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Your Listening Behaviour",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                  future:
                                      behaviourUploadService.recentUploadTime,
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return Text(
                                          "Latest upload date: ${DateTime.fromMillisecondsSinceEpoch(snapshot.data!)}");
                                    }
                                    return const Text(
                                        "Latest upload data: Unknown");
                                  }),
                            ),
                            Expanded(
                              flex: 2,
                              child: DataTable2(
                                  minWidth: 50,
                                  dataRowHeight: 100,
                                  columns: columns2,
                                  rows: convertBehaviourToRowEntry(data)),
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator.adaptive();
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                              "You didn't seem to have listened to musics"),
                        );
                      }
                      return const Center(child: Text("This is odd...."));
                    }))));
  }

  List<DataRow> convertBehaviourToRowEntry(List<ListeningBehaviourModel> data) {
    return List.generate(
        data.length,
        (index) => DataRow2(cells: [
              DataCell(Text(data[index].id.toString())),
              DataCell(Text(data[index].activity)),
              DataCell(Text(
                  DateTime.fromMillisecondsSinceEpoch(data[index].dateTimeInMis)
                      .toString())),
              DataCell(Text(data[index].artists.join(","))),
              DataCell(Text(data[index].genres.join(","))),
              DataCell(Text(data[index].latitude.toString() +
                  data[index].longitude.toString())),
            ]));
  }
}
