import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:budgetingapp/widgets/signin_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  
  final int _numPages = 3;

  List<Widget>_buildPageIndicator() {
    List<Widget> list = [];
    for(int i = 0; i < _numPages; i++){
      list.add((i == _currentPage) ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [ 0.1, 0.4, 0.7, 0.9],
            colors: [
              Colors.lightBlue,
              Colors.indigoAccent,
              Colors.indigo,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                
                height: MediaQuery.of(context).size.height/1.5,
                child: PageView.builder(
                  itemCount: _numPages,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, page){
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 70,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                                height: MediaQuery.of(context).size.height / 2.3,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(1,1),
                                      blurRadius: 2,
                                    ),
                                    BoxShadow(
                                      offset: Offset(1,0),
                                      blurRadius: 2,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 120,
                                      child: Image.asset(
                                        onboardImageString[page],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                      onboardTitle[page],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Rome',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                        color: Colors.indigo
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                      onboardSubTitle[page],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              (_currentPage != _numPages -1)
              ? Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ): Text(''),
            ],
          ),
        ),
      ),
      bottomSheet: (_currentPage == _numPages - 1)
          ? Container(
        height: 100.0,
        width: double.infinity,
        color: Colors.blue[50],
        padding: EdgeInsets.only(top: 22.0),
        child: SignIn(),
      ) : SizedBox.shrink(),
    );
  }
}
