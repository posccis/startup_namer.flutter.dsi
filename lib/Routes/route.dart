import 'package:flutter/material.dart';

import 'package:start_up_namer/edit_page.dart';

const String EditPage = 'edit';

Route<dynamic> controller(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case EditPage:
      return MaterialPageRoute(builder: (context) => editPage(
        index : int.parse(args.toString())
      ));
    default:
      throw new Exception("");
  }
}
