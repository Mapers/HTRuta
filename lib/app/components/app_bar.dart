import 'package:flutter/material.dart';

class AppBarMission extends AppBar {

  final String textTitle;
  @override
  final bool centerTitle;
  @override
  final List<Widget> actions;

  AppBarMission({
    this.textTitle,
    this.centerTitle,
    this.actions,
  }):super(
    title: Text(
      textTitle,
    ),
  );
}