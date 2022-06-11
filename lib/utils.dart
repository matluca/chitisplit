import 'package:flutter/material.dart';

FutureBuilder futurify<T>(
    Future<T> future, Widget Function(BuildContext, AsyncSnapshot, T) f) {
  return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          T futureData = snapshot.data as T;
          return f(context, snapshot, futureData);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const Text("fuffa");
        }
      });
}
