import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entity/track.dart';

class TrackWidget extends StatelessWidget{
  final TrackMin _track;
  final void Function() _callback;

  TrackWidget(this._track, this._callback);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: _callback, child: Text('|>')),
        Text('${_track.artistString} - ${_track.title}')
      ],
    );
  }
}