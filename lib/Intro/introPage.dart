import 'package:begoodyapp/Intro/signUp.dart';
import 'package:flutter/material.dart';
import 'signIn.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_currentIndex == 0 ? 150 : 60),
        child: Padding(
          padding: EdgeInsets.only(top: _currentIndex == 0 ? 25 : 0),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFFAC2797),
              indicatorWeight: 5,
              unselectedLabelColor: Color(0xFF959DAD),
              labelColor: Color(0xFF454F63),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "SIGN IN",
                ),
                Tab(
                  text: "SIGN UP",
                ),
              ],
            ),
            title: _currentIndex == 0
                ? Container(
                    child: Image.asset("images/logo.png", width: 200),
                  )
                : Container(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // SIGN IN
          SignIn(),

          // SIGN UP
          SignUp(),
        ],
      ),
    );
  }
}
