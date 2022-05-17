// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:testwallet/src/utilities/firestore.dart';
import 'package:testwallet/src/utilities/wallet_creation.dart';
import 'package:testwallet/src/utilities/wallet_query.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

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
  EthereumAddress? importAddress;
  EthereumAddress? newAddress;
  late Client httpClient;
  late Web3Client ethClient;

  String? balanceImport;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // details();
    httpClient = Client();
    ethClient = Web3Client(
        "https://data-seed-prebsc-1-s1.binance.org:8545", httpClient);
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
    print(selected);
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
          selected == null
              ? Column(children: [
                  Text("network: BSC"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                            child: const Text('New wallet'),
                            onPressed: () async {
                              // setState(() {
                              //   selected = 1;
                              // });
                              WalletAddress service = WalletAddress();
                              final mnemonic = service.generateMnemonic();
                              final privateKey =
                                  await service.getPrivateKey(mnemonic);
                              final address =
                                  await service.getAddressImport(privateKey);
                              setState(() {
                                newAddress = address;
                              });
                            },
                          ))
                    ],
                  ),
                  newAddress != null
                      ? Text(
                          newAddress.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            child: const Text('Import wallet'),
                            onPressed: () async {
                              // setState(() {
                              //   selected = 1;
                              // });
                              WalletAddress service = WalletAddress();

                              // final publicKey =
                              //     await service.getPublicKey(privateKey);
                              // privAddress = privateKey;
                              // pubAddress = publicKey.toString();
                              // print(mnemonic);
                              // print(privateKey);
                              // final mnemonic = service.generateMnemonic();
                              // print('mnemonic $mnemonic');
                              final privateKey = await service.getPrivateKey(
                                  "cup able tissue garden capital armed scare ski disorder birth image carry");
                              // print(
                              //     "testPrivatekey " + testPrivatekey.toString());

                              // final credentials = EthPrivateKey.fromHex(
                              //     "63db5975d20692b711daf07f0e8d578aa1663aa4bdca87bb68165b77bc83ef6a");
                              // final address = credentials.address;
                              // final privateKey =
                              //     await service.getPrivateKey(testPrivatekey);
                              final EthereumAddress address =
                                  await service.getAddressImport(privateKey);
                              setState(() {
                                importAddress = address;
                              });

                              print("privateKey " + privateKey.toString());
                              // print("tesst " + testPrivatekey);
                              // addUserDetails(privateKey, publicKey);
                            },
                          ))
                    ],
                  ),
                  importAddress != null
                      ? Column(children: [
                          Text(
                            importAddress.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextButton(
                              onPressed: () async {
                                WalletQuery client = WalletQuery();

                                // EtherAmount amount = await client.getBalance(
                                //     ethClient, importAddress!);
                                // print("Balance " +
                                //     amount
                                //         .getValueInUnit(EtherUnit.ether)
                                //         .toString());
                                var amount = await client.getBalance(
                                    ethClient, importAddress!);
                                print("Balance " + amount.toString());
                                setState(() {
                                  balanceImport = amount.toString();
                                });
                              },
                              child: Text(
                                "Get Balance",
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                          TextButton(
                              onPressed: () async {
                                WalletQuery client = WalletQuery();

                                // EtherAmount amount = await client.getBalance(
                                //     ethClient, importAddress!);
                                // print("Balance " +
                                //     amount
                                //         .getValueInUnit(EtherUnit.ether)
                                //         .toString());
                                await client.sendCoin(
                                    ethClient,
                                    20,
                                    EthereumAddress.fromHex(
                                        "0x0A9D4B527b48d875f1B14a775cB1801C6876d5Ae"),
                                    "4dc47516d57230109f2071382dca83635dfe700e66a3c6b50dae09f28250bf39");
                                // print("Balance " + amount.toString());
                                // setState(() {
                                //   balanceImport = amount.toString();
                                // });
                              },
                              child: Text(
                                "Send",
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                          Text(
                            balanceImport.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ])
                      : SizedBox()
                ])
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
