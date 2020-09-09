import 'package:embeddedvideoplayer/managers/links_manager.dart';
import 'package:embeddedvideoplayer/models/content_data_model.dart';
import 'package:embeddedvideoplayer/models/video_model.dart';
import 'package:embeddedvideoplayer/plugins/js_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinksListSuperVideo extends StatelessWidget{
  //todo: url must be provided e.g https://supervideo.tv/e/{video id}
  JsFlutter _jsFlutter  = JsFlutter(url: "your url");

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: <Widget>[
    _header(),
    _linksStream()
    ],),);
  }
  Widget _links(List<VideoModel> items){
   return  new ListView.builder
      (
        itemCount: items.length,
       shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          return  _item(items[index]);
        }
    );
  }

  Widget _item(VideoModel videoModel){
    return  Container(
        height: 180,
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      videoModel.label,
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(videoModel.file, style: TextStyle(fontSize: 10)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          onPressed: () {
                            print('On Pressed');
                            LinksManager _linksManger = LinksManager();
                            _linksManger.launchURL(videoModel.file);
                          },
                          icon: Icon(Icons.play_arrow),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }

  _header() {
    return       SizedBox.fromSize(
      size: Size(250, 70), // button width and height
      child: Card(
        child: Material(
          color: Colors.yellow, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {

            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.movie), // icon
                Text("Get Links "+ "https://supervideo.tv/e/{VID}" , textAlign: TextAlign.center,), // text
              ],
            ),
          ),
        ),
      ),
    );


  }

  _linksStream() {
    return       Column(children: <Widget>[
      StreamBuilder<Object>(
          stream: _jsFlutter.subject.stream,
          builder: (context, snapshot) {
            ContentData cd = snapshot.data;
            if(snapshot.hasError) return Center(child: Text("error"),);
            if(snapshot.hasData) return _links(cd.content);
            return Center(child: CircularProgressIndicator(),);
          }
      )

    ],);
  }
}
