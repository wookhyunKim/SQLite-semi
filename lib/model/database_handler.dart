import 'package:path/path.dart';
import 'package:schedule_sqlite_app/model/user.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHandler{

  Future<Database> initiallizeDB() async{
    String path = await getDatabasesPath(); // db의 경로를 받기
    return openDatabase(
      join(path, "todolist.db"),       // path 위치로 들어가서 user.db라는 이름의 db를 찾는다.
      onCreate: (db, version) async{
        await db.execute(
          "create table user(seq integer primary key autoincrement , uid text  , upassword text, uname text, ugender integer, uphone text, uemail text, uinsertdate text, udeleted integer)"
        );
      },
      version: 1,
    );
  }



  Future<List<User>> queryUser() async{
    final Database db = await initiallizeDB(); // db연결
    final List<Map<String,Object?>> queryResult = await db.rawQuery("select * from user");
    return queryResult.map((e) => User.fromMap(e)).toList();
  }


  Future<int> insertUser(User user) async{
    int result = 0; 
    final currentTime = DateTime.now();
    final Database db = await initiallizeDB(); // db연결
    result = await db.rawInsert(
      "insert into user (uid,upassword,uname,ugender,uphone,uemail,uinsertdate,udeleted) values (?,?,?,?,?,?,?,?)",
      [user.uid, user.upassword, user.uname, user.ugender,user.uphone, user.uemail,currentTime.toIso8601String(),0] // value값 넣어주기
    );

    return result;  // Students에 생성자 타입으로 리턴함.
  }

  // 유저정보 삭제는 사용하지 않음.
  // Future<void> deleteUser(String uid) async{
  //   final Database db = await initiallizeDB();
  //   await db.rawDelete(
  //     "delete from user where uid =? ",
  //     [uid]
  //   );
  // }

  Future<void> updateUser(User user) async{
    final Database db = await initiallizeDB();
    await db.rawUpdate(
      "update user set upassword = ?, uname = ?, uemail = ? where uid = ? ",
      [user.upassword,user.uname,user.uemail,user.uid]
    );
  }


  Future<void> deleteUser(User user) async{
    final Database db = await initiallizeDB();
    await db.rawUpdate(
      "update user set udeleted = 1 where uid = ? ",
      [user.uid]
    );
  }


  //중복체크
Future<List<User>> checkID(String uid) async {
  final Database db = await initiallizeDB();
  final List<Map<String, Object?>> dupResult = await db.rawQuery(
    "select * from user where uid = ? ",
    [uid],
  );
  return dupResult.map((e) => User.fromMap(e)).toList();

}

Future<List<User>> loginCheck(String uid,String upassword) async {
  final Database db = await initiallizeDB();
  final List<Map<String, Object?>> loginResult = await db.rawQuery(
    "select * from user where uid = ? and upassword = ? ",
    [uid,upassword],
  );
  return loginResult.map((e) => User.fromMap(e)).toList();

}





}//end