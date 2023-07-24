import 'package:flutter/material.dart';
import 'package:schedule_sqlite_app/model/database_handler.dart';
import 'package:schedule_sqlite_app/model/message.dart';
import 'package:schedule_sqlite_app/model/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late TextEditingController unameController;
  late TextEditingController uemailController;
  late TextEditingController uphoneController;
  late int _radioValue; // ugender 판단
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();

    uidController = TextEditingController();
    upasswordController = TextEditingController();
    unameController = TextEditingController();
    uemailController = TextEditingController();
    uphoneController = TextEditingController();
    _radioValue = 0; // 0 : 남성, 1 : 여성
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            width: 350,
            color: Color(0xFFF5F5DC),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: uidController,
                      decoration: const InputDecoration(
                        labelText: "아이디를 입력하세요.",
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          dupCheck(uidController);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // 버튼 배경색
                          foregroundColor: Colors.white, // 버튼 글씨색
                          minimumSize: const Size(70, 35),
                          shape: RoundedRectangleBorder(
                            //  버튼 모양 깎기
                            borderRadius: BorderRadius.circular(20), // 10은 파라미터
                          ),
                        ),
                        child: const Text(
                          "Check",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: upasswordController,
                    decoration: const InputDecoration(
                      labelText: "비밀번호를 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: unameController,
                    decoration: const InputDecoration(
                      labelText: "이름을 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: uphoneController,
                    decoration: const InputDecoration(
                      labelText: "전화번호를 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: uemailController,
                    decoration: const InputDecoration(
                      labelText: "이메일을 입력하세요.",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("성별 : "),
                    Radio(
                      value: 0,
                      groupValue: _radioValue, //radio grouping
                      onChanged: (value) {
                        Message.value = value!;
                        _radioChange(value);
                      },
                    ),
                    const Text(
                      "남성",
                    ),
                    Radio(
                      value: 1,
                      groupValue: _radioValue, //radio grouping
                      onChanged: (value) {
                        Message.value = value!;
                        _radioChange(value);
                      },
                    ),
                    const Text(
                      "여성",
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    insertData(Message.value);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색
                    foregroundColor: Colors.white, // 버튼 글씨색
                    minimumSize: const Size(100, 35),
                    shape: RoundedRectangleBorder(
                      //  버튼 모양 깎기
                      borderRadius: BorderRadius.circular(5), // 5 파라미터
                    ),
                  ),
                  child: const Text(
                    "Register",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _radioChange(int? value) {
    // type이 int? 이유는 radio 가 check 될 수 도 있고 안 될 수도 있기 때문
    _radioValue = value!;
    setState(() {});
  }

// insert
  Future<int> insertData(int value) async {
    User user = User.insert(
      uid: uidController.text.trim(),
      upassword: upasswordController.text.trim(),
      uname: unameController.text.trim(),
      ugender: Message.value,
      uphone: uphoneController.text.trim(),
      uemail: uemailController.text.trim(),
    );
    await handler.insertUser(user);
    _showDialog();
    return 0;
  }

// 중복체크
  dupCheck(TextEditingController uidController) async {
    List result = await handler.checkID(uidController.text.trim());
    result.length == 1 ? snackBarFunction() : snackBarsFunction();
  }

//중복메세지 스낵바
  snackBarFunction() {
    // 파라미터값을 받아사용
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "중복된 ID 입니다.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
        backgroundColor: Colors.red,
      ),
    );
  }

//아이디 사용가능 스낵바
  snackBarsFunction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "사용가능한 ID입니다.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
        backgroundColor: Colors.green,
      ),
    );
  }

// 회원정보를 받아서 가입승인 alert
  _showDialog() {
    // 받은 데이터를 animal이라는 하나의 var변수로 넣어두기
    var info = User.insert(
        uid: uidController.text.trim(),
        upassword: upasswordController.text.trim(),
        uname: unameController.text.trim(),
        ugender: _radioValue,
        uphone: uphoneController.text.trim(),
        uemail: uemailController.text.trim());
    showDialog(
      context: context, // 전 화면의 구성 dialog죽으면 다시 구성해야하기때문에 알고있어야함
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "가입승인",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            " ${info.uname}님의 가입을 축하드립니다 !",
              ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }
} //end
