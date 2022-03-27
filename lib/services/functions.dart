import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dapp_election/utils/constant.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contract_address;
  final contract = DeployedContract(ContractAbi.fromJson(abi, contract_name),
      EthereumAddress.fromHex(contractAddress));

  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract deployedContract = await loadContract();
  final ethFunction = deployedContract.function(functionName);
  final res = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: deployedContract, function: ethFunction, parameters: args),
      chainId: null,
      fetchChainIdFromNetworkId: true);

  return res;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction(start_election, [name], ethClient, owner_private_key);

  if (kDebugMode) {
    print('Election started successfully');
  }

  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunction(add_candidate, [name], ethClient, owner_private_key);

  if (kDebugMode) {
    print('Candidate added successfully');
  }

  return response;
}

Future<String> authVoter(String address, Web3Client ethClient) async {
  var response = await callFunction(auth_voter,
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);

  if (kDebugMode) {
    print('voter authorized successfully');
  }

  return response;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunc = contract.function(funcName);
  final res =
      ethClient.call(contract: contract, function: ethFunc, params: args);

  return res;
}

Future<List> getCandidatesCount(Web3Client ethClient) async {
  List<dynamic> res = await ask(get_total_candidates, [], ethClient);

  if (kDebugMode) {
    print('Candidate added successfully');
  }

  return res;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> res = await ask(get_total_votes, [], ethClient);

  if (kDebugMode) {
    print('get total votes successfully');
  }

  return res;
}

Future<List> getCandidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> res =
      await ask(get_candidate_info, [BigInt.from(index)], ethClient);

  if (kDebugMode) {
    print('get candidate info successfully');
  }

  return res;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  final response = await callFunction(vote_function,
      [BigInt.from(candidateIndex)], ethClient, voter_private_key);

  if (kDebugMode) {
    print('vote counted successfully');
  }

  return response;
}
