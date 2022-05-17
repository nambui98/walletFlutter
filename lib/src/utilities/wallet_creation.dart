import 'dart:convert';
import 'dart:ffi';
import 'package:bip39/bip39.dart' as bip39;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<bool> submitCreate(String mnemonic);
}

// import "dart:math";

// void main() {
//   var list = ['a','b','c','d','e'];
//   list.shuffle();
//   print(list);
// }
class WalletAddress implements WalletAddressService {
  //create new wallet
  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  //import wallet
  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final seedHex = bip39.mnemonicToSeedHex(mnemonic);
    print("seedHex: " + seedHex);
    print("seed: " + mnemonic.toString());
    var chain = Chain.seed(seedHex);
    var key = chain.forPath("m/44'/60'/0'/0/0") as ExtendedPrivateKey;
    final credentials = EthPrivateKey.fromHex(key.privateKeyHex());
    print(credentials.address);
    return key.privateKeyHex();
  }

  //get public key wallet
  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    print('address: $address');
    return address;
  }

  @override
  Future<EthereumAddress> getAddressImport(String privateKey) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    print(credentials.address);
    return credentials.address;
  }

  @override
  Future<bool> submitCreate(String mnemonic) async {
    return true;
  }
}
