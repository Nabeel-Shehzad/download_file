import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProgressDialog? _progressDialog;
  DirectoryLocation? _pickedDirecotry;

  Future<void> _pickDirectory() async {
    _pickedDirecotry = (await FlutterFileDialog.pickDirectory());
    setState(() {
      print('Here saved: $_pickedDirecotry');
    });
  }


  Future<void> _saveFileToDirectory(String url, String filename) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    var response = await http.get(Uri.parse(url));
    var fileData = response.bodyBytes;
    var mimeType = response.headers['content-type'];
    var newFileName = filename;



    FlutterFileDialog.saveFileToDirectory(
      directory: _pickedDirecotry!,
      data: fileData,
      mimeType: mimeType,
      fileName: newFileName,
      replace: false,
      onFileExists: () async {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            _progressDialog!.close();
            return SimpleDialog(
              title: const Text('File already exists'),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                SimpleDialogOption(
                  child: const Text('Replace'),
                  onPressed: () {
                    Navigator.pop(context);
                    FlutterFileDialog.saveFileToDirectory(
                      directory: _pickedDirecotry!,
                      data: fileData,
                      mimeType: mimeType,
                      fileName: newFileName,
                      replace: true,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
    _progressDialog!.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Download File? '),
          onPressed: () async{
            await _pickDirectory();
            await _saveFileToDirectory('https://dotcomplypro.com/MobileScripts/uploads/driver/27/Final%20Lab%20Set%20B%20From%20girls%20section_%20solved.pdf', 'dummy.pdf');
          },
        ),
      ),
    );
  }
}
