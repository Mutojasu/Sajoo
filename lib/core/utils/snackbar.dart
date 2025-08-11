import 'package:flutter/material.dart';
void showSnack(BuildContext c, String m) =>
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
