import 'package:flutter/material.dart';

class FileItem extends StatelessWidget {
  FileItem(
      {Key? key,
      required this.fileName,
      required this.download,
      required this.delete})
      : super(key: key);

  String fileName;
  VoidCallback download;
  VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Text(fileName),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: download, icon: const Icon(Icons.download)),
            ),
            IconButton(
                onPressed: delete, icon: const Icon(Icons.delete_forever))
          ],
        ),
      ),
    );
  }
}
