import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categorieswidget extends StatelessWidget {
  const Categorieswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0,3),
                  )]
                ),
                child:
                    Image.asset("burger.png", height: 50, width: 50),
              ),
              const SizedBox(height: 8),
              Text(
                "All",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black
                  )
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0,3),
                  )]
                ),
                child:
                    Image.asset("burger.png", height: 50, width: 50),
              ),
              const SizedBox(height: 8),
              Text(
                "Makanan",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black
                 )
               ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0,3),
                  )]
                ),
                child:
                    Image.asset("teh_botol.png", height: 50, width: 50),
              ),
              const SizedBox(height: 8),
              Text(
                "Minuman",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
