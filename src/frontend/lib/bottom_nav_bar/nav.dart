import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/pages/home_screen.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Nav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Home(),
    const Home(),
    const Home(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        AccountBubble(click: () {
          logOutUser();
        })
      ], title: const Text('Bottom Nav Bar')),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy < 0) {
              showModalBottomSheet(
                  context: context, builder: (context) => buildSheet());
            }
          },
          child: FloatingActionButton(
              child: const Icon(Icons.arrow_drop_up_rounded),
              onPressed: () {},
              mini: true)),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          notchMargin: 4,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart), label: 'Home1'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.play_arrow_rounded), label: 'Home2'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_rounded), label: 'Home3'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          )),
    );
  }

  Widget buildSheet() => Container();
}
