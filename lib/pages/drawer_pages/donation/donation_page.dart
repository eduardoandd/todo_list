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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Página de doação"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ProfilePhoto(
              totalWidth: 150,
              cornerRadius: 80,
              color: Colors.purple,
              image: AssetImage('assets/eu.jpg'),
              badgeAlignment: Alignment.bottomLeft,
              badgeSize: 60,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Dialog(
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(450),
                            child:
                                Image.asset('assets/eu.jpg', fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
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
                                child: Text(
                                  "Eu sou completamente viciado em café, mas, olha, essa história de 'me ajuda a comprar um café' é só uma brincadeira! Na verdade, essa página é só uma forma de me incentivar a continuar perseguindo o meu sonho. Se você puder ajudar, ótimo! Se não, sem problemas! O importante é que o apoio, de qualquer forma, já é um grande incentivo para seguir em frente. Então, se você se sentir à vontade, fique à vontade para contribuir, mas saiba que o mais valioso mesmo é a sua energia positiva! Vamos juntos!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
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
    );
  }
}
