import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Como usar o App"),
      backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Bem-vindo ao Tutorial!",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            Text(
              "Aqui você aprenderá como adicionar, editar e excluir tarefas no seu aplicativo.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20),
            _buildSectionTitle("1. Como adicionar uma tarefa"),
            _buildStepText(
                "Toque no botão de '+' no canto inferior direito para adicionar uma nova tarefa."),
            SizedBox(height: 20),
            
            _buildSectionTitle("2. Como editar uma tarefa"),
            _buildStepText(
                "Clique em uma tarefa existente para abrir a tela de edição e fazer alterações."),
            SizedBox(height: 20),
            
            _buildSectionTitle("3. Como excluir uma tarefa"),
            _buildStepText(
                "Deslize para a esquerda na tarefa ou toque no ícone de lixeira para excluir."),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStepText(String step) {
    return Text(
      step,
      style: TextStyle(fontSize: 16),
    );
  }

}
