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

  get username => _username;
  get email => _email;
  get firstLogin => _firstLogin;
  get birthday => _birthday;
  get wishes => _wishes;

  set wishes(wishList) => _wishes = wishList;

}
