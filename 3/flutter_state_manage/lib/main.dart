import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        title: Text("State Manage"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hello World " * 6,
              textAlign: TextAlign.left,
            ),
            Text(
              "Hello World! I'm Jack. " * 4,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Hello World",
              textScaleFactor: 1.5,
            ),
            TapBoxA(),
            Text(
              "Hello World",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                height: 1.8,
                fontFamily: "Courier",
                background: Paint()..color = Colors.yellow,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            ParentWidget(),
            DefaultTextStyle(
              // 1.设置文本的默认样式
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.start,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Hello World"),
                  Text("I'm Jack"),
                  Text("I'm Jack",
                    style: TextStyle(
                      inherit: false,   //2.不继承默认样式
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            ParentWidgetC(),
            Text.rich(TextSpan(
              children: [
                TextSpan(
                  text: "Home: ",
                ),
                TextSpan(
                  text: "https://flutterchina.club",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  recognizer: null,
                )
              ],
            )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// TapBoxA 管理自身状态
//------------------------ TapBoxA -----------------------------
class TapBoxA extends StatefulWidget {
  TapBoxA({Key key}) : super(key: key);
  @override
  _TapBoxAState createState() => new _TapBoxAState();
}

class _TapBoxAState extends State<TapBoxA> {
  bool _active = false;
  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? "Active" : "Inactive",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

// ParentWidget 为 TapBoxB 管理状态
//------------------------ ParentWidget -----------------------------
class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => new _ParentWidgetState();
}
class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;
  void _handleTapBoxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapBoxB(
        active: _active,
        onChanged: _handleTapBoxChanged,
      ),
    );
  }
}
//------------------------ TapBoxB -----------------------------
class TapBoxB extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  TapBoxB({
    Key key,
    this.active: false,
    @required this.onChanged
  }) : super(key: key);
  void _handleTap() {
    onChanged(!active);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? "Active" : "Inactive",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

// 混合状态管理
//------------------------ ParentWidget -----------------------------
class ParentWidgetC extends StatefulWidget {
  @override
  _ParentWidgetCState createState() => new _ParentWidgetCState();
}
class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;
  void _handleTapBoxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapBoxC(
        active: _active,
        onChanged: _handleTapBoxChanged,
      ),
    );
  }
}
//------------------------ TapBoxC -----------------------------
class TapBoxC extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  TapBoxC({
    Key key,
    this.active: false,
    @required this.onChanged
  }) : super(key: key);
  @override
  _TapBoxCState createState() => new _TapBoxCState();
}
class _TapBoxCState extends State<TapBoxC> {
  bool _hightlight = false;
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _hightlight = true;
    });
  }
  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _hightlight = false;
    });
  }
  void _handleTapCancle() {
    setState(() {
      _hightlight = false;
    });
  }
  void _handleTap() {
    widget.onChanged(!widget.active);
  }
  @override
  Widget build(BuildContext context) {
    // 按下时添加绿色边框，抬起时取消
    return GestureDetector(
      onTapDown: _handleTapDown,  // 处理按下事件
      onTapUp: _handleTapUp,  // 处理抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancle,
      child: Container(
        child: Center(
          child: Text(
            widget.active ? "Active" : "Inactive",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _hightlight ? Border.all(
            color: Colors.teal[700],
            width: 5.0,
          ) : null,
        ),
      ),
    );
  }
}