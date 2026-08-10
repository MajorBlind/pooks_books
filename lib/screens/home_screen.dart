import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'goals_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade200,
          title: const Text('Pooks\' Books <3'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: const Color.fromARGB(255, 180, 63, 91), width: 1.5),
                ),
              ),
              child: Stack(
                children: [
                  const TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: 'Reading List'),
                      Tab(text: 'Progress/Goal'),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 1.5,
                      height: 48,
                      color: const Color.fromARGB(255, 180, 63, 91),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            BookListScreen(),
            GoalsScreen(),
          ],
        ),
      ),
    );
  }
}