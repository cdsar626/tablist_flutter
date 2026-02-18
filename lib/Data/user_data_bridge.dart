import 'package:tablist_app/Models/user.dart';
import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:tablist_app/db_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserDataBridge extends DB {
  UserDataBridge(DB instantiatedDB) {
    db = instantiatedDB.db;
    collUsers = instantiatedDB.collUsers;
    collWishes = instantiatedDB.collWishes;
  }

  Future<User> loadUser(String username) async {
    var userdata = await collUsers.findOne(where.eq('username', username));
    if (userdata == null) {
      return User('', '', DateTime.now(), DateTime.now(), []);
    }
    var wishes = await getWishes(username);
    return User(
      userdata['username'] ?? '',
      userdata['email'],
      userdata['firstLogin'] ?? DateTime.now(),
      userdata['birthday'],
      wishes,
    );
  }

  Future<void> createUser(String username) async {
    await collUsers.insertOne({
      'username': username,
      'email': '',
      'firstLogin': DateTime.now(),
      'birthday': null,
      'wishes': [],
    });
  }

  Future<bool> userExists(String username) async {
    var userdata = await collUsers.findOne(where.eq('username', username));
    return userdata != null;
  }

  Future<void> addNewWish(
      String title, String username, int currentWishesLength, int steps) async {
      
    // Shift all existing items down by 1 to make room at index 0
    await collWishes.updateMany(
      {'owner': username},
      {'\$inc': {'indexAtUserList': 1}}
    );
      
    await collWishes.insert({
      'owner': username,
      'title': title,
      'creation': DateTime.now(),
      'comments': '',
      'status': StatusItemWL.active.index,
      'progress': 0,
      'steps': steps,
      'history': [
        {
          'when': DateTime.now(),
          'status': StatusItemWL.active.index,
          'progress': 0
        },
      ],
      'indexAtUserList': 0,
    });
  }

  Future<List> getWishes(String username) async {
    var wishes = await collWishes.find({'owner': username}).toList();
    wishes.sort((a, b) {
      var aIdx = a['indexAtUserList'] ?? 0;
      var bIdx = b['indexAtUserList'] ?? 0;
      return aIdx.compareTo(bIdx);
    });
    return wishes;
  }

  Future<void> deleteWish(
      String username, int index, int wishListLength) async {
    await collWishes.deleteOne({'owner': username, 'indexAtUserList': index});
    await collWishes.updateMany({
      'owner': username,
      'indexAtUserList': {'\$gt': index}
    }, {
      '\$inc': {'indexAtUserList': -1}
    });
  }

  Future<void> updateWishesSortDB(
      String username, int oldIndex, int newIndex) async {
    if (newIndex < oldIndex) {
      await collWishes.updateOne({
        'owner': username,
        'indexAtUserList': oldIndex
      }, {
        '\$set': {'indexAtUserList': -999}
      });
      await collWishes.updateMany({
        'owner': username,
        'indexAtUserList': {'\$gte': newIndex, '\$lt': oldIndex}
      }, {
        '\$inc': {'indexAtUserList': 1}
      });
      await collWishes.updateOne({
        'owner': username,
        'indexAtUserList': -999
      }, {
        '\$set': {'indexAtUserList': newIndex}
      });
    } else if (newIndex > oldIndex) {
      await collWishes.updateOne({
        'owner': username,
        'indexAtUserList': oldIndex
      }, {
        '\$set': {'indexAtUserList': 999}
      });
      await collWishes.updateMany({
        'owner': username,
        'indexAtUserList': {'\$lte': newIndex, '\$gt': oldIndex}
      }, {
        '\$inc': {'indexAtUserList': -1}
      });
      await collWishes.updateOne({
        'owner': username,
        'indexAtUserList': 999
      }, {
        '\$set': {'indexAtUserList': newIndex}
      });
    }
  }

  Future<void> setWishStatus(username, int index, StatusItemWL status) async {
    await collWishes.updateOne({
      'owner': username,
      'indexAtUserList': index
    }, [
      {
        '\$set': {
          'status': status.index,
          'history': {
            '\$concatArrays': [
              '\$history',
              [
                {
                  'when': DateTime.now(),
                  'status': status.index,
                  'progress': '\$progress'
                }
              ]
            ]
          }
        }
      }
    ]);
  }

  Future<void> updateProgress(double endVal, int index, username, int maxSteps) async {
    // We update status to complete if endVal is ~100~ maxSteps
    // We also update progress to endVal
    // And add this update to history
    await collWishes.updateOne({
      'owner': username,
      'indexAtUserList': index
    }, [
      {
        '\$set': {
          'status': endVal == maxSteps? StatusItemWL.completed.index : '\$status',
          'progress': endVal,
          'history': {
            '\$concatArrays': [
              '\$history',
              [
                {
                  'when': DateTime.now(),
                  'progress': endVal
                }
              ]
            ]
          }
        }
      }
    ]);
  }
}
