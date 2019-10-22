import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
      home: MyHomePage(title: 'Flutter 手势识别'),
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
      body: GestureConflictRoute(),
//      BothDirectionRoute(),   // 手势竞争
//      GestureRecognizerRoute(),   // GestureRecognizer
//      ScaleRoute(),   // 缩放
//      _DragVertical(),  //单一方向拖动
//      _Drag(),  // 拖动、滑动
//      GestureDetectorRoute(),   // 点击、双击、长按
    );
  }
}

class GestureDetectorRoute extends StatefulWidget {
  @override
  _GestureDetectorRouteState createState() => new _GestureDetectorRouteState();
}

class _GestureDetectorRouteState extends State<GestureDetectorRoute> {

  String _operation = "No Gesture detected!";   // 保存事件名

  void updateText(String text) {
    // 更新显示的事件名
    setState(() {
      _operation = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 200.0,
          height: 100.0,
          child: Text(_operation, style: TextStyle(color: Colors.white)),
        ),
        onTap: () => updateText("Tap"),   // 点击
        onDoubleTap: () => updateText("DoubleTap"),   // 双击
        onLongPress: () => updateText("LongPress"),   // 长按
      ),
    );
  }
}

class _Drag extends StatefulWidget {
  @override
  _DragState createState() => new _DragState();
}

class _DragState extends State<_Drag> {

  double _top = 0.0;    // 距顶部的偏移
  double _left = 0.0;   // 距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            // 手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              // 打印手指按下的位置(相对于屏幕)
              print("用户手指按下的位置：${e.globalPosition}");
            },
            // 手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              // 用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e) {
              // 打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
        ),
      ],
    );
  }
}

class _DragVertical extends StatefulWidget {
  @override
  _DragVerticalState createState() => new _DragVerticalState();
}

class _DragVerticalState extends State<_DragVertical> {

  double _top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _top += details.delta.dy;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ScaleRoute extends StatefulWidget {
  @override
  _ScaleRouteState createState() => new _ScaleRouteState();
}

class _ScaleRouteState extends State<ScaleRoute> {

  double _width = 200.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        //指定宽度，高度自适应
        child: Image.asset("./images/sea.png", width: _width),
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            // 缩放倍数在0.8到10倍之间
            _width = 200 * details.scale.clamp(.8, 10.0);
          });
        },
      ),
    );
  }
}
class GestureRecognizerRoute extends StatefulWidget {
  @override
  _GestureRecognizerRouteState createState() => new _GestureRecognizerRouteState();
}

class _GestureRecognizerRouteState extends State<GestureRecognizerRoute> {

  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  bool _toggle = false;   // 变色开关

  @override
  void dispose() {
    // 用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "你好世界"),
            TextSpan(
              text: "点我变色",
              style: TextStyle(
                fontSize: 30.0,
                color: _toggle ? Colors.blue : Colors.red
              ),
              recognizer: _tapGestureRecognizer
                ..onTap = () {
                  setState(() {
                    _toggle = !_toggle;
                  });
                },
            ),
            TextSpan(
              text: "你好世界"
            ),
          ]
        ),
      ),
    );
  }
}

class BothDirectionRoute extends StatefulWidget {
  @override
  BothDirectionRouteState createState() => new BothDirectionRouteState();
}

class BothDirectionRouteState extends State<BothDirectionRoute> {

  double _top = 0.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            // 垂直方向拖动事件
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _top += details.delta.dy;
              });
            },
            // 水平方向拖动事件
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _left += details.delta.dx;
              });
            },
          ),
        )
      ],
    );
  }
}

class GestureConflictRoute extends StatefulWidget {
  @override
  GestureConflictRouteState createState() => new GestureConflictRouteState();
}

class GestureConflictRouteState extends State<GestureConflictRoute> {
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 80.0,
          left: _left,
          child: Listener(
            onPointerDown: (details) {
              print("down");
            },
            onPointerUp: (details) {
              print("up");
            },
            child: GestureDetector(
              child: CircleAvatar(
                child: Text("A"),
              ),
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _left += details.delta.dx;
                });
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                print("onHorizontalDragEnd");
              },
          ),
        ),
        ),
      ],
    );
  }
}