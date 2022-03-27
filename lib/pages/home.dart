import 'package:flutter/material.dart';
import 'package:flutter_dapp_election/pages/electionInfo.dart';
import 'package:flutter_dapp_election/services/functions.dart';
import 'package:flutter_dapp_election/utils/constant.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client web3client;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(BASE_URL, httpClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Start Election'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter Election Name',
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (textEditingController.text.isNotEmpty) {
                    await startElection(textEditingController.text, web3client);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionInfo(
                          web3client: web3client,
                          electionName: textEditingController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Start Election'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
