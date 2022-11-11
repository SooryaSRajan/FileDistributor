import 'package:flutter/material.dart';

progressDialog({dismissDialog, willPop, context}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissDialog ?? true,
    builder: (context) => WillPopScope(
      onWillPop: () async => willPop ?? true,
      child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            "Uploading File",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "File is being uploaded, please wait",
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              )
            ],
          )),
    ),
  );
}
