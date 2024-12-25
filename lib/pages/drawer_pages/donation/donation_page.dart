import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DonationPage(),
    );
  }
}

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  Color borderColor3 = Colors.grey;

  // Controlador para o campo de texto
  final TextEditingController valueController = TextEditingController();

  void selectValue(int value) {
    setState(() {
      // Alterando a cor dos botões para indicar a seleção
      borderColor1 = value == 1 ? Colors.purple : Colors.grey.shade100;
      borderColor2 = value == 3 ? Colors.purple : Colors.grey.shade100;
      borderColor3 = value == 5 ? Colors.purple : Colors.grey.shade100;

      // Atualizando o valor do campo de texto
      valueController.text = value.toString();
    });
  }

  @override
  void dispose() {
    valueController
        .dispose(); // Liberar o controlador quando não for mais necessário
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página de Doação')),
      body: Center(
        child: Column(
          children: [
            ProfilePhoto(
              totalWidth: 150,
              cornerRadius: 80,
              color: Colors.blue,
              image: const AssetImage('assets/eu.jpg'),
              badgeAlignment: Alignment.bottomLeft,
              badgeSize: 60,
            ),
            SizedBox(height: 15),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Me ajude a comprar café',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              "☕",
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                          SizedBox(width: 1),
                          Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => selectValue(1),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: borderColor1),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(child: Text('1',  style: TextStyle(fontSize: 20))),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => selectValue(3),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: borderColor2),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(child: Text('3',  style: TextStyle(fontSize: 20))),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => selectValue(5),
                                child: Container(
                                  width:50,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: borderColor3),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(child: Text('5', style: TextStyle(fontSize: 20),)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: valueController,
                                readOnly: false, // Somente leitura
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.purple.withOpacity(
                                          0.5), // Reduzindo a opacidade da borda
                                      width: 2.0, // Largura da borda
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(
                                          0.2), // Opacidade da borda habilitada
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: '@sua_rede_social',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Me mande uma mensagem..',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
