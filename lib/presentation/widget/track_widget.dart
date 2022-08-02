import 'package:flutter/material.dart';

import '../../domain/entity/track.dart';

class TrackWidget extends StatelessWidget {
  const TrackWidget(this._track, this._callback, {super.key});
  final TrackMin _track;
  final void Function() _callback;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ElevatedButton(onPressed: _callback, child: const Text('|>')),
          Text('${_track.artistString} - ${_track.title}')
        ],
      );
}
