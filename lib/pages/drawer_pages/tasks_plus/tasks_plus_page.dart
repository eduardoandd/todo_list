import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:todo_list/pages/drawer_pages/tasks_plus/plan_card.dart';

class TasksPlusPage extends StatefulWidget {
  @override
  _TasksPlusPageState createState() => _TasksPlusPageState();
}

class _TasksPlusPageState extends State<TasksPlusPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _onBuyPlan(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Plano ${index + 1} Selecionado"),
          content: Text(
              "Você selecionou o plano ${index == 0 ? "Mensal" : index == 1 ? "Anual" : "Permanente"}."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Tasks Plus", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade600,
        centerTitle: true,
      ),
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return PlanCard(
            title: index == 0
                ? "Plano Mensal"
                : index == 1
                    ? "Plano Anual"
                    : "Plano Permanente",
            price: index == 0
                ? "R\$9,99"
                : index == 1
                    ? "R\$29,99"
                    : "R\$50,00",
            description: index == 0
                ? "Aproveite todos os benefícios por um mês."
                : index == 1
                    ? "Economize com o plano anual e remova os anúncios."
                    : "Acesso completo e vitalício ao conteúdo, sem anúncios. Inclui WhatsApp particular do desenvolvedor.",
            gradient: index == 0
                ? LinearGradient(
                    colors: [Colors.purple.shade300, Colors.purple.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : index == 1
                    ? LinearGradient(
                        colors: [
                          Color.fromARGB(255, 239, 158, 58),
                          Colors.purple.shade600
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Color.fromARGB(255, 101, 104, 198),
                          Colors.purple.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
            voidCallback: () => _onBuyPlan(index),
            isMostSold: index == 2,
            isPermanent: index == 2 ,
          );
        },
        itemCount: 3,
        itemHeight: 300,
        itemWidth: 200,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
            activeColor: Color.fromARGB(255, 255, 255, 255),
            size: 8.0,
            activeSize: 12.0,
          ),
        ),
      ),
    );
  }
}
