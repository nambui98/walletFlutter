// Future<DeployedContract> loadContract() async {
//   String abi = await rootBundle.loadString("assets/abi/abi.json");
//   String contractAddress = "0x4a151003126f41c5cb23e31f5f29da05676e9cae";
//   final contract = DeployedContract(ContractAbi.fromJson(abi, "Gold"),
//       EthereumAddress.fromHex(contractAddress));
//   return contract;
// }

// Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
//   final contract = await loadContract();
//   final ethFunction = contract.function(functionName);
//   final result = await ethClient.call(
//       contract: contract, function: ethFunction, params: args);
//   return result;
// }

// Future<void> getBalance(EthereumAddress credentialAddress) async {
//   List<dynamic> result = await query("balanceOf", [credentialAddress]);
//   var data = result[0];
//   setState(() {
//     balance = data;
//   });
// }

// Future<String> sendCoin() async {
//   var bigAmount = BigInt.from(myAmount);
//   var response = await submit("transfer", [targetAddress, bigAmount]);
//   return response;
// }

// Future<String> submit(String functionName, List<dynamic> args) async {
//   DeployedContract contract = await loadContract();
//   final ethFunction = contract.function(functionName);
//   EthPrivateKey key = EthPrivateKey.fromHex(privAddress);
//   Transaction transaction = await Transaction.callContract(
//       contract: contract,
//       function: ethFunction,
//       parameters: args,
//       maxGas: 100000);
//   print(transaction.nonce);
//   final result = await ethClient.sendTransaction(key, transaction, chainId: 4);
//   return result;
// }

import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';

abstract class WalletQueryService {
  Future<DeployedContract> loadContract();
  Future<List<dynamic>> query(
      Web3Client ethClient, String functionName, List<dynamic> args);
  Future<dynamic> getBalance(
      Web3Client ethClient, EthereumAddress credentialAddress);
  Future<String> sendCoin(Web3Client ethClient, double myAmount,
      EthereumAddress targetAddress, String privAddress);
  Future<String> submit(Web3Client ethClient, String functionName,
      String privAddress, List<dynamic> args);
  Future<void> getAbi();
}

// import "dart:math";

// void main() {
//   var list = ['a','b','c','d','e'];
//   list.shuffle();
//   print(list);
// }
class WalletQuery implements WalletQueryService {
  @override
  Future<DeployedContract> loadContract() async {
    // String abi = await rootBundle.loadString("assets/abi/NVER.json");
    // String contractAddress = "0x04968120b53D883d7A82d32d15ab156B0b65c43C";
    final abi = await getAbi();
    final contract = DeployedContract(
        ContractAbi.fromJson(abi['abiCode'], "NVER"),
        EthereumAddress.fromHex(abi['contractAddress'].toString()));
    print(contract);
    return contract;
  }

  @override
  Future<List<dynamic>> query(
      Web3Client ethClient, String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  @override
  Future<dynamic> getBalance(
      Web3Client ethClient, EthereumAddress credentialAddress) async {
    List<dynamic> result =
        await query(ethClient, "balanceOf", [credentialAddress]);
    print("result $result");
    EtherAmount data = EtherAmount.inWei(result[0]);
    print("result $result");

    return data.getValueInUnit(EtherUnit.ether);
  }

  @override
  Future<String> sendCoin(Web3Client ethClient, double myAmount,
      EthereumAddress targetAddress, String privAddress) async {
    var bigAmount =
        EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(myAmount))
            .getInWei;
    print('bigAmount $bigAmount, myAmount $myAmount');
    var response = await submit(
        ethClient, "transfer", privAddress, [targetAddress, bigAmount]);
    print('response $response');
    return response;
  }

  @override
  Future<String> submit(Web3Client ethClient, String functionName,
      String privAddress, List<dynamic> args) async {
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    EthPrivateKey key = EthPrivateKey.fromHex(privAddress);
    print("key $args");
    Transaction transaction = await Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 100000);
    print('transaction.nonce ' + transaction.nonce.toString());
    final result =
        await ethClient.sendTransaction(key, transaction, chainId: 97);
    return result;
  }

  @override
  Future<dynamic> getAbi() async {
    String abiStringFile = await rootBundle.loadString("assets/abi/NVER.json");
    var jsonAbi = jsonDecode(abiStringFile);
    var _abiCode = jsonEncode(jsonAbi['abi']);
    var _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["97"]["address"]);
    // print("_abiCode $_abiCode");
    // print("_contractAddress $_contractAddress");
    return {'abiCode': _abiCode, 'contractAddress': _contractAddress};
  }
}
