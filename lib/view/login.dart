import 'package:flutter/material.dart';
import 'package:schedule_sqlite_app/model/database_handler.dart';
import 'package:schedule_sqlite_app/model/user.dart';
import 'package:schedule_sqlite_app/view/mypage.dart';
import 'package:schedule_sqlite_app/view/register.dart';
import 'package:schedule_sqlite_app/view/userinfo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    uidController = TextEditingController();
    upasswordController = TextEditingController();
    handler = DatabaseHandler();

    // Temporary
    handler.initiallizeDB().whenComplete(() async {
      await addUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Log In1",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const Info();
                          },
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        "images/todolist.png",
                      ),
                      radius: 100,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "ID : ",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "PW : ",
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 180,
                              height: 35,
                              child: TextField(
                                controller: uidController,
                                decoration: const InputDecoration(
                                  labelText: "아이디를 입력하세요!",
                                  border: OutlineInputBorder(), // 텍스트필드 테두리
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            height: 35,
                            child: TextField(
                              controller: upasswordController,
                              // 일하는 것은 컨트롤러 글씨가 바뀌는 것을 탐지 setState가 없어도된다.
                              decoration: const InputDecoration(
                                labelText: "비밀번호를 입력하세요!", // 글자없어지지 않음
                                border: OutlineInputBorder(), // 텍스트필드 테두리
                              ),
                              keyboardType: TextInputType.number, // 키보드 형태
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Register();
                              },
                            ),
                          );
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          loginCheck();
                          //첫화면 띄우기
                          // 마이페이지 일단 띄우기 나중에 홈에서 앱바에 아이콘버튼으로 수정할예정

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
                          "Log In",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> addUser() async {
    User user = User.insert(
        uid: "IU1993",
        upassword: "1234",
        uname: "이지금",
        ugender: 1,
        uphone: "0000",
        uemail: "now@naver.com");
    await handler.insertUser(user);

    return 0;
  }

// ID/PW 체크
  loginCheck() async {
    List result = await handler.loginCheck(
        uidController.text.trim(), upasswordController.text.trim());
    if (result.isNotEmpty &&
        result[0].uid == uidController.text.trim() &&
        result[0].upassword == upasswordController.text.trim()) {
      // 로그인성공 alert
      _SuccessAlert(result);
    } else {
      // 로그인 실패 alert
      _FailAlert();
    }
    setState(() {});
  }

  _SuccessAlert(List result) {
    // _를 처음에 사용하면 private
    showDialog(
      context: context, // 복원시키기위해 context필요
      barrierDismissible: false, // alert창 외에 클릭 시 alert 닫히는 것을 막기위함
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "Success",
          ),
          content: Text(
            "${result[0].uname}님 환영합니다 !",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyPage(
                            seq: result[0].seq,
                            uid: result[0].uid,
                            upassword: result[0].upassword,
                            uname: result[0].uname,
                            ugender: result[0].ugender,
                            uemail: result[0].uemail,
                            uphone: result[0].uphone,
                            uinsertdate: result[0].uinsertdate,
                            udeleted: result[0].udeleted
                          );
                        },
                      ),
                    );
                  }, //pop은 메모리에서 지우기
                  child: const Text(
                    "OK",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  _FailAlert() {
    // _를 처음에 사용하면 private
    showDialog(
      context: context, // 복원시키기위해 context필요
      barrierDismissible: false, // alert창 외에 클릭 시 alert 닫히는 것을 막기위함
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "Fail",
          ),
          content: const Text(
            "ID 와 PW 를 확인해주세요.",
          ), //
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }, //pop은 메모리에서 지우기
                  child: const Text(
                    "로그인실패",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }



// db데이터 가져오기
reloadData() {
    //future build라서 clear가 없어도됌
    handler.queryUser();
    setState(() {});
  }











} //end
