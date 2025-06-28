class User {
  final String _username;
  final String? _email;
  final DateTime _firstLogin;
  final DateTime? _birthday;
  List _wishes;

  User(
    this._username,
    this._email,
    this._firstLogin,
    this._birthday,
    this._wishes,
  );

  String get username => _username;
  String? get email => _email;
  DateTime get firstLogin => _firstLogin;
  DateTime? get birthday => _birthday;
  List get wishes => _wishes;

  set wishes(wishList) => _wishes = wishList;

}
