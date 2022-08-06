import 'package:flutter/material.dart';

import '../../domain/entity/track.dart';

class TrackEntryWidget extends StatelessWidget {
  const TrackEntryWidget(this._track, this._callback, {super.key});
  final TrackMin _track;
  final void Function() _callback;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ElevatedButton(
            onPressed: _track.available ? _callback : null,
            child: const Text('|>'),
          ),
          Text('${_track.artistString} - ${_track.title}')
        ],
      );
}
