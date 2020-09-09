import 'package:embeddedvideoplayer/plugins/js_flutter.dart';
import 'package:embeddedvideoplayer/ui/home_page/links_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(height: 50,),
            LinksListSuperVideo(),
          ],
        ),
      ),
    );
  }

}
