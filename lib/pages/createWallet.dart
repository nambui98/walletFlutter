// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:testwallet/src/utilities/firestore.dart';
import 'package:testwallet/src/utilities/wallet_creation.dart';
import 'package:web3dart/credentials.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWallet();
}

class _CreateWallet extends State<CreateWallet> {
  int? selected;
  String? pubAddress;
  String? privAddress;
  String? username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details();
  }

  details() async {
    // dynamic data = await getUserDetails();
    dynamic data = null;
    data != null
        ? setState(() {
            privAddress = data['privateKey'];
            pubAddress = data['publicKey'];
            username = data['user_name'];
            bool created = data['wallet_created'];
            created == true ? selected = 1 : selected = 0;
          })
        : setState(() {
            selected = 0;
          });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Information"),
        actions: [
          IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          selected == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text("Add a Wallet"),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          child: const Icon(Icons.add),
                          onPressed: () async {
                            // setState(() {
                            //   selected = 1;
                            // });
                            WalletAddress service = WalletAddress();
                            // final mnemonic = service.generateMnemonic();
                            // final privateKey =
                            //     await service.getPrivateKey(mnemonic);
                            // final publicKey =
                            //     await service.getPublicKey(privateKey);
                            // privAddress = privateKey;
                            // pubAddress = publicKey.toString();
                            // print(mnemonic);
                            // print(privateKey);
                            // final mnemonic = service.generateMnemonic();
                            // print('mnemonic $mnemonic');
                            final testPrivatekey = await service.getPrivateKey(
                                "define nuclear fog stool horror toilet cotton spatial direct ankle script abuse");
                            // print(
                            //     "testPrivatekey " + testPrivatekey.toString());

                            // final credentials = EthPrivateKey.fromHex(
                            //     "63db5975d20692b711daf07f0e8d578aa1663aa4bdca87bb68165b77bc83ef6a");
                            // final address = credentials.address;
                            final testpublicKey =
                                await service.getPublicKey(testPrivatekey);
                            print("testpublicKey " + testpublicKey.toString());
                            // print("tesst " + testPrivatekey);
                            // addUserDetails(privateKey, publicKey);
                          },
                        ))
                  ],
                )
              : Column(
                  children: [
                    Center(
                        child: Container(
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueAccent,
                      child: const Text(
                        "Successfully initiated wallet!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )),
                    const Center(
                      child: Text(
                        "Wallet Private Address :",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${privAddress}",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Do not reveal your private address to anyone!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Divider(),
                    const Center(
                      child: Text(
                        "Wallet Public Address : ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${pubAddress}",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Divider(),
                    const Center(
                      child: Text(
                        "Go back to main page!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
