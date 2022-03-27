import 'package:flutter/material.dart';
import 'package:flutter_dapp_election/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client web3client;
  final String electionName;

  const ElectionInfo(
      {Key? key, required this.web3client, required this.electionName})
      : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  final TextEditingController _addCandidateTextEditingController =
      TextEditingController();
  final TextEditingController _authVoterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getCandidatesCount(widget.web3client),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            snapshot.data![0].toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    const Text('Total Candidates')
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getTotalVotes(widget.web3client),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const Text('Total Votes')
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addCandidateTextEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Candidate Name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addCandidate(_addCandidateTextEditingController.text,
                        widget.web3client);
                  },
                  child: const Text('Add Candidate'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _authVoterController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Voter Address',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    authVoter(_authVoterController.text, widget.web3client);
                  },
                  child: const Text('Add Voter'),
                ),
              ],
            ),
            const Divider(),
            FutureBuilder<List>(
              future: getCandidatesCount(widget.web3client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    for (int i = 0; i < snapshot.data![0].toInt(); i++)
                      FutureBuilder<List>(
                        future: getCandidateInfo(i, widget.web3client),
                        builder: (context, candidateSnapshot) {
                          if (candidateSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                'Name: ' +
                                    candidateSnapshot.data![0][0].toString(),
                              ),
                              subtitle: Text(
                                'Votes: ' +
                                    candidateSnapshot.data![0][1].toString(),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  vote(i, widget.web3client);
                                },
                                child: const Text('Vote'),
                              ),
                            );
                          }
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
