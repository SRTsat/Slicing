import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Allbarwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15, 
        horizontal: 15
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 50,
                      offset: const Offset(0,3),
                    )
                  ]
                ),
                child: const Icon(CupertinoIcons.arrow_left,),
              )
            ),
              
                InkWell(
              onTap: (){},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 50,
                      offset: const Offset(0,3),
                    )
                  ]
                ),
                child: const Icon(Icons.person),
              )
            )
          ]),
        );
  }
}