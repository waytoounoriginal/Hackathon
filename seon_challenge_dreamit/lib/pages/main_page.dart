import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../others/color_scheme.dart';
import '../others/navbar.dart';
import '../others/frontend_icons_icons.dart';

import './dashboard.dart';
import './account_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dummyData = [];

    ValueNotifier currentPage = ValueNotifier(0);

    // final List<Widget> pages = [
    //   const Dashboard(
    //     key: ValueKey(0),
    //   ),
    //   const AccountViewer(
    //     key: ValueKey(1),
    //   )
    // ];

    return Scaffold(
        backgroundColor: AppColorScheme.normalGreen,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/logos/logo.png'),
                      const Text('X',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Image.asset('assets/images/logos/dreamIT.png')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Dashboard()
              ],
            ),
          ),
        ));
  }
}
