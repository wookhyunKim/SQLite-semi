import 'package:flutter/material.dart';
import 'package:schedule_sqlite_app/model/database_handler.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late DatabaseHandler handler;


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User INFO",
        ),
      ),
      body: FutureBuilder(
        future: handler.queryUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const DetailList(),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: Colors.cyanAccent,
                    child: Column(
                      children: [
                        Text(
                          "ID : ${snapshot.data![index].uid}",
                        ),
                        Text(
                          "PW : ${snapshot.data![index].upassword}",
                        ),
                        Text(
                          "E-mail : ${snapshot.data![index].uemail}",
                        ),
                        Text(
                          "Gender : ${snapshot.data![index].ugender==1?"여성":"남성"}",
                        ),
                        Text(
                          "탈퇴여부 : ${snapshot.data![index].udeleted==0?"X":"O"}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


















}//end 
