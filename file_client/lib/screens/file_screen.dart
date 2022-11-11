import 'dart:convert';
import 'package:file_client/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/file_item_card.dart';
import '../widgets/progress_dialog.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  List<dynamic> _fileName = [];
  List<dynamic> _fileNameSearch = [];
  late Map<String, String> requestHeader;

  _getFileList() async {
    var response =
        await http.get(getURI("/files/getfiles"), headers: requestHeader);
    if (response.statusCode == 200) {
      setState(() {
        _fileName = json.decode(response.body)["files"];
        _fileNameSearch = json.decode(response.body)["files"];
      });
    }
  }

  _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    progressDialog(dismissDialog: false, willPop: false, context: context);
    if (result != null) {
      var request = http.MultipartRequest("POST", getURI("/files/uploadFile"));
      request.headers.addAll(requestHeader);
      request.files.add(http.MultipartFile.fromBytes(
          'file', result.files.single.bytes!.toList(),
          filename: result.files.single.name));
      request.send().then((response) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("File uploaded successfully")));
          print("Uploaded!");
          _getFileList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("File upload failed")));
        }
        Navigator.of(context).pop();
      });
    } else {
      print("No file selected");
      Navigator.of(context).pop();
    }
  }

  _deleteFile(fileName) async {
    var response = await http.delete(getURI("/files/deleteFile/$fileName"),
        headers: requestHeader);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Deleted file successfully!")));
      _getFileList();
    } else {
      print(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  _downloadFile(String fileName) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Downloading file"),
    ));
    try {
      await _launchUrl(getURI("/files/downloadFile/$fileName"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Download Failed"),
      ));
    }
  }

  _filterFiles(String searchString) {
    _fileName = _fileNameSearch
        .where((element) => element
            .toString()
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestHeader = {"auth-token": widget.token};
      _getFileList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Files and AmriDa"),
        actions: [
          IconButton(
              onPressed: () {
                _getFileList();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Eg: file.doc",
                  filled: true),
              onChanged: _filterFiles,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Text(
                "Files",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Expanded(
                child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _fileName.isNotEmpty
                    ? ListView.builder(
                        itemCount: _fileName.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FileItem(
                            download: () {
                              _downloadFile(_fileName[index]);
                            },
                            delete: () {
                              displayDialog(
                                context,
                                "Yes",
                                "No",
                                () {
                                  _deleteFile(_fileName[index]);
                                  Navigator.of(context).pop();
                                },
                                "Delete File",
                                "Are you sure you want to delete this file?",
                              );
                            },
                            fileName: _fileName[index],
                          );
                        })
                    : const Center(
                        child: Text("No files found"),
                      ),
              ),
            )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
              child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        _uploadFile();
                      },
                      icon: const Icon(Icons.upload),
                      label: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Upload File"),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
