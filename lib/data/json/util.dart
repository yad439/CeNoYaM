int objectToInt(Object obj) {
  if (obj is int) {
    return obj;
  } else if (obj is String) {
    return int.parse(obj);
  } else {
    throw ArgumentError('Invalid object type', 'obj');
  }
}
