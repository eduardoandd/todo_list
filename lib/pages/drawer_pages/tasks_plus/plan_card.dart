// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final Gradient gradient;
  final voidCallback;
  final bool isMostSold;
  final bool isPermanent;

  const PlanCard(
      {Key? key,
      required this.title,
      required this.price,
      required this.gradient,
      this.voidCallback,
      required this.isMostSold,
      required this.isPermanent,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, blurRadius: 6, offset: Offset(4, 4))
            ]),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                price,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text:
                          "Acesso completo e vitalício ao conteúdo, sem anúncios. Inclui",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400),
                    ),
                    if (isPermanent) ...[
                      TextSpan(
                          text: " WhatsApp",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: " particular do desenvolvedor",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400)),
                    ]
                  ]),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isMostSold
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Mais vendido!",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple.shade700,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(30),
                    )
                  ),
                  child: Text(
                    'Adquirir agora',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  
                ),
                // child: ElevatedButton(),
              ),
              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Remover anúncios e aproveita uma experiência sem interrupções.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ), 
              )
            ],
          ),
        ),
      ),
    );
  }
}