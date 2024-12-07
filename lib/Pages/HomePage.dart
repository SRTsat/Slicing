import 'package:flutter/material.dart';
import 'package:food_app/Widgets/AppBarWidgets.dart';
import 'package:food_app/Widgets/CategoriesWidget.dart';
import 'package:food_app/Widgets/FoodGenreWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/CartPage');
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/AddPage');
    }
     else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Appbarwidgets(),
          const Categorieswidget(),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              "All Food",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Foodgenrewidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: '',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
      ),
    );
  }
}
