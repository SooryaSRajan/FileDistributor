import 'dart:core';

String baseURLHTTP = "172.17.18.87:8000";
bool isHTTP = true;

getURI(route) {
  return isHTTP ? Uri.http(baseURLHTTP, route) : Uri.https(baseURLHTTP, route);
}
