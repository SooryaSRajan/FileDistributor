import 'dart:core';

String baseURLHTTP = "localhost:8000";
bool isHTTP = true;

getURI(route) {
  return isHTTP ? Uri.http(baseURLHTTP, route) : Uri.https(baseURLHTTP, route);
}
