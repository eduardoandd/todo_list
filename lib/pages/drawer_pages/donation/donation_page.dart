// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:todo_list/shared/widgets/card_donation_widget.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  Color borderColor3 = Colors.grey;

  final TextEditingController valueController = TextEditingController();

  void selectValue(int value) {
    setState(() {
      borderColor1 = value == 1 ? Colors.purple : Colors.grey.shade100;
      borderColor2 = value == 3 ? Colors.purple : Colors.grey.shade100;
      borderColor3 = value == 5 ? Colors.purple : Colors.grey.shade100;

      valueController.text = value.toString();
    });
  }
  final db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Doação"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ProfilePhoto(
                totalWidth: 150,
                cornerRadius: 80,
                color: Colors.purple,
                image: AssetImage('assets/eu.png'),
                badgeAlignment: Alignment.bottomLeft,
                badgeSize: 60,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        children: [
                          Container(
                            // backgroundColor: Colors.transparent,
                            width: MediaQuery.of(context).size.width * .6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(450),
                              child: Image.asset('assets/eu.png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Scrollbar(
                              interactive: true,
                              isAlwaysShown: true,
                              child: Container(
                                height: MediaQuery.of(context).size.height * .5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: isDarkMode
                                        ? [
                                            Color.fromARGB(255, 155, 39, 176),
                                            Color.fromARGB(140, 155, 39, 176).withOpacity(0.5),
                                          ]
                                        : [
                                            Color.fromARGB(53, 0, 0, 0)
                                                .withOpacity(0.1),
                                            Color.fromARGB(76, 0, 0, 0)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "Olá! Meu nome é Eduardo e sou o desenvolvedor deste aplicativo. Antes de mais nada, quero agradecer por estar aqui! Essa ideia de 'me ajuda a comprar um café' é só uma brincadeira mas, convenhamos, como qualquer desenvolvedor, eu realmente amo café e ele é quase um combustível para a criatividade haha.. Essa página é só uma forma divertida de abrir espaço para quem quiser apoiar o meu trabalho e me ajudar a continuar criando projetos como este. Se você puder contribuir, vai ser incrível! Mas, olha, se não puder, não tem problema. O que mais importa é o apoio que você já dá usando o aplicativo.Muito obrigado por acreditar no meu trabalho e por fazer parte dessa jornada. Vamos juntos construir algo ainda maior!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            CardDonationWidget(),
          ],
        ),
      ),
    );
  }
}
