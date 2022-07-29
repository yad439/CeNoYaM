class User {
  User(this._uid, this._login);
  final int _uid;
  final String _login;

  String get login => _login;

  int get uid => _uid;
}
