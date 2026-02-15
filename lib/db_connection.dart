import 'package:mongo_dart/mongo_dart.dart';

// TODO: Replace with your actual MongoDB connection URI
const String conectionURI = "mongodb+srv://admin:admin@cluster0.abcde.mongodb.net/test?retryWrites=true&w=majority";

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
