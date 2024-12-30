// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/model/donation_model.dart';

class CardDonationWidget extends StatefulWidget {
  const CardDonationWidget({Key? key}) : super(key: key);

  @override
  State<CardDonationWidget> createState() => _CardDonationWidgetState();
}

class _CardDonationWidgetState extends State<CardDonationWidget> {
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  Color borderColor3 = Colors.grey;
  Color bgColor1 = Colors.white;
  Color bgColor2 = Colors.white;
  Color bgColor3 = Colors.white;
  final TextEditingController valueController = TextEditingController();
  int valueDonation = 0;

  void SelectValue(int value) {
    setState(() {
      bgColor1 = value == 1 ? Colors.purple.shade400 : Colors.white;
      bgColor2 = value == 3 ? Colors.purple.shade400 : Colors.white;
      bgColor3 = value == 5 ? Colors.purple.shade400 : Colors.white;
      borderColor1 = value == 1 ? Colors.purple : Colors.grey.shade100;
      borderColor2 = value == 3 ? Colors.purple : Colors.grey.shade100;
      borderColor3 = value == 5 ? Colors.purple : Colors.grey.shade100;

      var result = valueController.text = value.toString();
      valueDonation = int.tryParse(result) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final db = FirebaseFirestore.instance;
    var socialNetworkController = TextEditingController();
    var messageController = TextEditingController();

    return SingleChildScrollView(
      child: Card(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 8,
        shadowColor: Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                      "Me ajuda a comprar café ☕",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('donations').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            "Erro ao carregar doações",
                            style: TextStyle(
                                color: Color.fromARGB(255, 137, 135, 135)),
                          );
                        }
                        int donatiounCount = snapshot.data?.docs.length ?? 3;

                        return Text("Doações: $donatiounCount",
                            style: TextStyle(
                                color: Color.fromARGB(255, 137, 135, 135)));
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.purple.withOpacity(0.1),
                    border: Border.all(
                        color: isDarkMode ? Colors.white70 : Colors.purple,
                        width: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "☕",
                          style: TextStyle(
                              fontSize: 50,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Icon(
                        Icons.close,
                        size: 20,
                        color: isDarkMode ? Colors.white : Colors.grey,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => SelectValue(1),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: bgColor1,
                                border:
                                    Border.all(color: borderColor1, width: 1.3),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: bgColor1 == Colors.purple.shade400
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.purple.shade200
                                            : Colors.purple),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => SelectValue(3),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: bgColor2,
                                border:
                                    Border.all(color: borderColor2, width: 1.3),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: bgColor2 == Colors.purple.shade400
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.purple.shade200
                                            : Colors.purple),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => SelectValue(5),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: bgColor3,
                                border:
                                    Border.all(color: borderColor3, width: 1.3),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: bgColor3 == Colors.purple.shade400
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.purple.shade200
                                            : Colors.purple),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                if (valueController.text != '') {
                                  valueDonation = int.tryParse(value) ?? 0;
                                }
                              });
                            },
                            controller: valueController,
                            readOnly: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            decoration: InputDecoration(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: socialNetworkController,
                  decoration: InputDecoration(
                      fillColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      filled: true,
                      hintText: '@sua_rede_social',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      fillColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      filled: true,
                      hintText: 'Me mande uma mensagem..',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    width: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              valueController.text == ''
                                  ? 'Doar'
                                  : 'Doar R\$' + (valueDonation * 5).toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 2,
                              height: 24,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (valueDonation > 0) {
                            try {
                              var donation = DonationModel(
                                quantity: valueDonation,
                                value: valueDonation * 5,
                                message: messageController.text,
                                socialNetwork: socialNetworkController.text,
                              );

                              await db
                                  .collection("donations")
                                  .add(donation.toJson());

                              // Limpa os campos
                              socialNetworkController.text = '';
                              messageController.text = '';

                              // Exibe a mensagem de sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Obrigado pela sua doação!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              // Exibe a mensagem de erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Ocorreu um erro ao processar sua doação."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            // Exibe a mensagem caso o valor da doação seja inválido
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Por favor, insira um valor válido para doar."),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
