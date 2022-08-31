import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'player_widget.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({required this.title, required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Column(children: [Expanded(child: child), const PlayerWidget()]),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}
