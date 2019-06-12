import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(new MaterialApp(home: new HomePage(), routes: <String, WidgetBuilder>{
    "/SecondPage": (BuildContext context) => SecondPage(),
    "/FilePicker": (BuildContext context) => FilePickerDemo()
  }));
}
// Melhor forma de organizar?
// qual o padrão da comunidade?

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/SecondPage");
        },
        child: Icon(Icons.navigate_next),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.ANY;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Second"),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                      title: Text(
                        "Documento",
                        style: Theme.of(context).textTheme.headline,
                      ),
                      subtitle: Text("Documento subtitle"),
                      leading: new CircleAvatar(
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed("/FilePicker");
                        debugPrint('onTap');
                      }),
                  ListTile(
                      title: Text(
                        "Potato",
                        style: Theme.of(context).textTheme.headline,
                      ),
                      leading: new CircleAvatar(
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                      onTap: () {
                        _openFileExplorer();

                      })
                ],
              ),
            ),
          ],
        ));
  }
}

// testeeeeeeeeeeeeeeee
class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.ANY;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('File Picker example app'),
        ),
        body: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100.0),
                  child: new Container(),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: new RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    child: new Text("Open file picker"),
                  ),
                ),
                new Builder(
                  builder: (BuildContext context) => new Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: new Scrollbar(
                          child: _path != null || _paths != null
                              ? new ListView.separated(
                                  itemCount: _paths != null && _paths.isNotEmpty
                                      ? _paths.length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath =
                                        _paths != null && _paths.isNotEmpty;
                                    final String name = 'File $index: ' +
                                        (isMultiPath
                                            ? _paths.keys.toList()[index]
                                            : _fileName ?? '...');
                                    final path = isMultiPath
                                        ? _paths.values
                                            .toList()[index]
                                            .toString()
                                        : _path;

                                    return new ListTile(
                                      title: new Text(
                                        name,
                                      ),
                                      subtitle: new Text(path),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          new Divider(),
                                )
                              : new Container(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
