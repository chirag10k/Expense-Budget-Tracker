import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/card_row_details_widget.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {

  String insta = 'https://www.instagram.com/chirag_c.s/';
  String git = 'https://github.com/chirag10k';
  String play = 'https://github.com/chirag10k';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                   primaryColor2,
                    primaryColor1
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      backButtonWidget(context, Colors.white),
                      SizedBox(width: 10,),
                      Text(
                        'About the Developer',
                        textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rome',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[ Card(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30, left: 10, right: 10, bottom: 20),
                          child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 150.0,
                                      height: 200.0,
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/budgetingapp-b789b.appspot.com/o/me.jpg?alt=media&token=f026b079-2186-4dde-bf89-24546eef9a57',
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Loading(),
                                      ),
//                                      child: Image.network(
//                                        'https://firebasestorage.googleapis.com/v0/b/budgetingapp-b789b.appspot.com/o/me.jpg?alt=media&token=f026b079-2186-4dde-bf89-24546eef9a57',
//                                        fit: BoxFit.fill,
//                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text(
                                    'CHIRAG SARAOGI',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Rome',
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              SizedBox(height: 30,),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      _launchURL(git);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.github),
                                        SizedBox(width: 10,),
                                        Text(
                                          'GitHub',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    onTap: () {
                                      _launchURL(insta);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.instagram),
                                        SizedBox(width: 10,),
                                        Text(
                                          'Instagram',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    onTap: () {
                                      try {
                                        _launchURL(play);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.appStore),
                                        SizedBox(width: 10,),
                                        Text(
                                          'PlayStore',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
