

import 'package:flutter/material.dart';

import 'package:start_up_namer/edit_page.dart';

import 'package:start_up_namer/add_page.dart';

const String EditPage = 'edit';
const String AddPage = 'add';

Route<dynamic> controller(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case EditPage:
      return MaterialPageRoute(
          builder: (context) => editPage(index: int.parse(args.toString())));
    case AddPage:
      return MaterialPageRoute(builder: (context) => addPage());

    default:
      throw new Exception("");
  }
}
