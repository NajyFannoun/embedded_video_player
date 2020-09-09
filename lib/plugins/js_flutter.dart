import 'dart:convert';

import 'package:embeddedvideoplayer/models/content_data_model.dart';
import 'package:embeddedvideoplayer/models/video_model.dart';
import 'package:flutter/services.dart';
import 'package:interactive_webview/interactive_webview.dart';
import 'package:rxdart/rxdart.dart';

enum LinkLinksType { Link, Links }

class JsFlutter {
  final _webView = InteractiveWebView();
  final String url;

  final subject = BehaviorSubject<ContentData>();

  JsFlutter({this.url}) {
    _listenToDataFromWebPage();
    _webViewStateChangedListener();
    _webView.loadUrl(url);
  }

  /// this used to get the source code which called inside eval function to play the video in the browser
  /// eval(function(p,a,c,k,e,d){while(c--)if(k[c])p=p.replace ...etc)
  // goGetPackedFunctionLinks() {}

  /// i call this to get the video src from an html page
  /// document.getElementsByTagName('video')[0].src
  // goGetDirectLink() {}

  _listenToDataFromWebPage() {
    _webView.didReceiveMessage.listen((message) {
      print("##### message is" + message.data.toString());

      /// if the data has the word eval
      ///                 then we need to unpack the function to get the links
      if (message.data.toString().contains("Eval")) {
        _webView.evalJavascript("unPack(${message.data.toString()});");

      } else if (message.data.toString().contains("oneLink")) {
        VideoModel videoModel = VideoModel(file: "MP4" , label:message.data.toString().substring(7) );
        List<VideoModel> oneLinkList = List<VideoModel>();
        oneLinkList.add(videoModel);
        ContentData contentData = ContentData(
            linkLinksType: LinkLinksType.Link,
            content: oneLinkList );
        subject.add(contentData);

      } else if (message.data.toString().contains("Links")) {

        String data = message.data.toString().substring(5).toString();
        // json.decode FormatException: Unexpected character at file so we make it "file"
        data = data.replaceAll("file", '"file"');
        data = data.replaceAll("label", '"label"');

        List<VideoModel> videoEval = superVideoEvalFromJson(data);
        ContentData contentData =
            ContentData(linkLinksType: LinkLinksType.Links, content: videoEval);
        subject.add(contentData);
      }
    });
  }

  _webViewStateChangedListener() {
    _webView.stateChanged.listen((state) {
      print("stateChanged ${state.type} ${state.url}");
      if (state.type == WebViewState.didFinish) this._onFinish();
    });
  }

  _onFinish() async {
    // inject our script in
    final script = await rootBundle.loadString("assets/injection.js", cache: false);

    _webView.evalJavascript(script);
    _webView.evalJavascript("goGetPackedFunctionLinks();");
  }
}
