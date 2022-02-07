import 'package:flutter/material.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:mono_learn/widgets/button_login.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class JsonTestPage extends StatefulWidget {
  const JsonTestPage({Key? key}) : super(key: key);
  @override
  State<JsonTestPage> createState() => _JsonTestPageState();
}

class _JsonTestPageState extends State<JsonTestPage> {
  TextEditingController _controllerKey = new TextEditingController();
  TextEditingController _controllerValue = new TextEditingController();

  bool isLoading = false;
  String fileName = "myJSONFile.json";
  bool _fileExists = false;
  Map<String, dynamic> _json = {};
  String _jsonString = '';
  late File? _filePath;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  void _writeJson(String key, dynamic value) async {
    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {key: value};
    print('1.(_writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    _json.addAll(_newJson);
    print('2.(_writeJson) _json(updated): $_json');

    //3. Convert _json ->_jsonString
    _jsonString = json.encode(_json);
    print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    await _filePath!.writeAsString(_jsonString).then((value) => setState(() {
          isLoading = false;
        }));
    print(_filePath.toString());
  }

  void _readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _fileExists = await _filePath!.exists();
    print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath!.readAsString();
        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>

        setState(() {
          _json = json.decode(_jsonString);
        });
        print('2.(_readJson) _json: $_json \n - \n');
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Instantiate _controllerKey and _controllerValue
    _controllerKey = TextEditingController();
    _controllerValue = TextEditingController();
    print('0. Initialized _json: $_json');
    _readJson();
  }

  @override
  void dispose() {
    _controllerKey.dispose();
    _controllerValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("JSON Tutorial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(top: 10.0)),
            new Text(
              "File content: ",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            new Text(_json.toString()),
            new Padding(padding: new EdgeInsets.only(top: 10.0)),
            new Text("Add to JSON file: "),
            new TextField(
              controller: _controllerKey,
            ),
            new TextField(
              controller: _controllerValue,
            ),
            new Padding(padding: new EdgeInsets.only(top: 20.0)),
            new ButtonLogin(
              buttonChild:
                  isLoading ? CircularProgressIndicator() : Text('Add pair'),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                _writeJson(_controllerKey.text, _controllerValue.text);
                print(
                    'Input key ${_controllerKey.text} Input value: ${_controllerValue.text}');
                // final file = await _localFile;
                // _fileExists = await file.exists();
              },
              borderColor: Colors.black38,
              buttonHeight: 20,
              borderRadius: 5,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}