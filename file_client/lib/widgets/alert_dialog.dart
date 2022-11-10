import 'package:flutter/material.dart';

displayDialog(context, positiveText, negativeText, Function positiveFunction,
    title, subTitle,
    {dismissDialog, willPop}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissDialog ?? true,
    builder: (context) => WillPopScope(
      onWillPop: () async => willPop ?? true,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          subTitle,
          style: TextStyle(color: Colors.white70.withOpacity(0.8)),
        ),
        actions: <Widget>[
          negativeText != null
              ? TextButton(
                  child: Text(
                    negativeText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          ElevatedButton(
            child: Text(
              positiveText,
            ),
            onPressed: () async {
              positiveFunction();
            },
          ),
        ],
      ),
    ),
  );
}
