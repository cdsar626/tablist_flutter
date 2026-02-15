import 'package:mongo_dart/mongo_dart.dart';

class DB {
  late Db db;
  late DbCollection collUsers;
  late DbCollection collWishes;

  Future<DB> initDBConnection() async {
    db = await Db.create(conectionURI);
    await db.open();
    collUsers = db.collection('Users');
    collWishes = db.collection('Wishes');
    return this;
  }
}