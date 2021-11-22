import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Dbh {
  static const int version = 1;
  static const String todot = "todot";
  static const String dbn = "tododb.db";
  //for singletone one instance for all access
  Dbh._privateConst();
  static final inst = Dbh._privateConst();

  String path = "";
  static Database? mydb;
  Future initData() async {
    final v = await getApplicationDocumentsDirectory();
    path = join(v.path, dbn);
    mydb ??= await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      print("database created");
      await db
          .execute('CREATE TABLE $todot (id INTEGER PRIMARY KEY, name TEXT)');
    });
    print("data op");
  }

  Future insertData(String name) async {
    if (mydb != null) {
      await mydb!.insert(todot, {"name": name});
      print("prepar");
    }
  }

  Future<List<Map>> getData(String name) async {
    if (mydb != null) {
      print("prepar");
      return await mydb!.rawQuery("select * from $todot");
    } else {
      return [];
    }
  }

  Future deleteData(int id) async {
    if (mydb != null) {
      print("prepar");
      await mydb!.rawDelete('DELETE FROM $todot WHERE id = ?', [id]);
    } else {}
  }

  Future updateData(String name, int id) async {
    if (mydb != null) {
      print("prepar");
      int c = await mydb!
          .rawUpdate("UPDATE $todot SET name = ? WHERE id = ?", [name, id]);
        print("no of udated recodes is/are $c");
    } else {}
  }
}
