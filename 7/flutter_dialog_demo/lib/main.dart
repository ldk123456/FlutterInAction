import 'package:flutter/cupertino.dart';
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
      home: MyHomePage(title: 'Flutter 对话框'),
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

  Future<bool> showDeleteConfirmDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确定要删除当前文件夹吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(),   // 关闭对话框
            ),
            FlatButton(
              child: Text('删除'),
              onPressed: () {
                // 关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
    }
    );
  }

  Future<int> changeLanguage() async {
    return await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('请选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('中文简体'),
              ),
              onPressed: () {
                Navigator.pop(context, 1);
              },
            ),
            SimpleDialogOption(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('美国英语'),
              ),
              onPressed: () {
                Navigator.pop(context, 2);
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> showListDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        var child = Column(
          children: <Widget>[
            ListTile(title: Text('请选择')),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('$index'),
                    onTap: () => Navigator.of(context).pop(index),
                  );
                },
              ),
            ),
          ],
        );
        return Dialog(child: child);
      }
    );
  }

  Future<T> showCustomDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null ? Theme(data: theme, child: pageChild) : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  Future<bool> showDeleteCheckDialog() async {
    bool _withTree = false;   // 记录复选框是否选中
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('您确定要删除当前文件吗?'),
                Row(
                  children: <Widget>[
                    Text('同时删除子目录？'),
                    DialogCheckBox(
                      value: _withTree,   // 默认不选中
                      onChanged: (bool value) {
                        // 更新选中状态
                        _withTree = !_withTree;
                      },
                    )
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("删除"),
                onPressed: () {
                  // 将选中状态返回
                  Navigator.of(context).pop(_withTree);
                },
              ),
            ],
          );
        }
    );
  }

  Future<int> _showBottomDialog() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('$index'),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      }
    );
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text("正在加载，请稍后..."),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime> _showDateDialog() {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add(Duration(days: 30)),   // 未来30天可选
    );
  }

  Future<DateTime> _showIOSDateDialog() {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(Duration(days: 30)),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print('已选择：$value');
            },
          ),
        );
      },
    );
  }

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
            RaisedButton(
              child: Text('对话框1'),
              onPressed: () async {
                // 弹出对话框并等待其关闭
                bool delete = await showDeleteConfirmDialog();
                if (delete == null) {
                  print('取消删除');
                } else {
                  print('确认删除');
                  // ... 删除文件
                }
              },
            ),
            RaisedButton(
              child: Text('选择语言对话框'),
              onPressed: () async {
                int i = await changeLanguage();
                if (i != null) {
                  print("选择了：${i == 1 ? "简体中文" : "美国英语"}");
                }
              },
            ),
            RaisedButton(
              child: Text('List对话框'),
              onPressed: () async {
                int i = await showListDialog();
                if (i != null) {
                  print('选择了：$i');
                }
              },
            ),
            RaisedButton(
              child: Text('对话框2'),
              onPressed: () async {
                // 弹出对话框并等待其关闭
                bool delete = await showCustomDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('提示'),
                      content: Text('确定要删除当前文件夹吗？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('取消'),
                          onPressed: () => Navigator.of(context).pop(),   // 关闭对话框
                        ),
                        FlatButton(
                          child: Text('删除'),
                          onPressed: () {
                            // 关闭对话框并返回true
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  }
                );
                if (delete == null) {
                  print('取消删除');
                } else {
                  print('确认删除');
                  // ... 删除文件
                }
              },
            ),
            RaisedButton(
              child: Text("对话框3（复选框可点击）"),
              onPressed: () async {
                //弹出删除确认对话框，等待用户确认
                bool deleteTree = await showDeleteCheckDialog();
                if (deleteTree == null) {
                  print("取消删除");
                } else {
                  print("同时删除子目录: $deleteTree");
                }
              },
            ),
            RaisedButton(
              child: Text("显示底部菜单列表"),
              onPressed: () async {
                int type = await _showBottomDialog();
                print(type);
              },
            ),
            RaisedButton(
              child: Text("显示loading"),
              onPressed: () => showLoadingDialog(),
            ),
            RaisedButton(
              child: Text("显示日历选择对话框"),
              onPressed: () async {
                DateTime date = await _showDateDialog();
                print(date);
              },
            ),
            RaisedButton(
              child: Text("显示IOS日历选择对话框"),
              onPressed: () => _showIOSDateDialog(),
            ),
          ],
        ),
      ),
    );
  }
}

// 单独封装一个内部管理选中状态的复选框组件
class DialogCheckBox extends StatefulWidget {

  DialogCheckBox({
    Key key,
    this.value,
    @required this.onChanged,
  });

  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  _DialogCheckBoxState createState() => new _DialogCheckBoxState();
}

class _DialogCheckBoxState extends State<DialogCheckBox> {

  bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) {
        setState(() {
          // 更新自身选中状态
          value = v;
        });
      },
    );
  }
}