import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Http请求'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: HttpTestRoute(),
    );
  }
}

class HttpTestRoute extends StatefulWidget {
  @override
  HttpTestRouteState createState() => new HttpTestRouteState();
}

class HttpTestRouteState extends State<HttpTestRoute> {
  bool _loading = false;
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("获取百度首页"),
              onPressed: _loading ? null : () async {
                setState(() {
                  _loading = true;
                  _text = "正在请求...";
                });
                try {
                  // 创建一个HttpClient
                  HttpClient httpClient = new HttpClient();
                  // 打开Http连接
                  HttpClientRequest request = await httpClient.getUrl(Uri.parse("https://www.baidu.com"));
                  // 使用iPhone的UA
                  request.headers.add("user-agent", "Mozilla/5.0 (iphone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1)");
                  // 等待连接服务器（会将请求信息发送给服务器）
                  HttpClientResponse response = await request.close();
                  // 读取响应内容
                  _text = await response.transform(utf8.decoder).join();
                  // 输出响应头
                  print(response.headers);

                  // 关闭client后，通过该client发起的所有请求都会中止
                  httpClient.close();
                } catch (e) {
                  _text = "请求失败：$e";
                } finally {
                  setState(() {
                    _loading = false;
                  });
                }
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50.0,
              child: Text(_text.replaceAll(new RegExp(r"\s"), "")),
            ),
          ],
        ),
      ),
    );
  }
}