class User {
  final int _uid;
  final String _login;

  User(this._uid, this._login);

  String get login => _login;

  int get uid => _uid;
}
