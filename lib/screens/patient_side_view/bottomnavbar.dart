
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../admin-side-view/dashbaord.dart';
import 'home-view.dart';


class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {


  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedIndexProvider>(
      builder: (context, selectedIndexProvider, _) {
        final List<Widget> pages = [
          const HomeView(),
          const Dashboard(),
        ];

        return Scaffold(
          body: pages[selectedIndexProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndexProvider.selectedIndex,
            onTap: (index) {
              selectedIndexProvider.setSelectedIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Dashboard',
              ),
            ],
          ),
        );
      },
    );
  }
}