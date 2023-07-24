class User{
  int? seq;
  String? uid;  //seq auto increase
  String? upassword;
  String? uname;
  int? ugender;
  String? uemail;
  String? uphone;
  String? uinsertdate;
  int? udeleted;
  



  // 생성자
  User( 
    {
      this.seq,
      required this.uid,  
      required this.upassword,
      required this.uname,
      required this.ugender,
      required this.uphone,
      required this.uemail,
      required this.uinsertdate,
      required this.udeleted
    }
  );

  // user info insert 하기위한 생성자
  User.insert( 
    {
      this.seq,
      required this.uid,  
      required this.upassword,
      required this.uname,
      required this.ugender,
      required this.uphone,
      required this.uemail,
      this.uinsertdate,
      this.udeleted
    }
  );

  // user login check constructor
  User.login(
    {
      this.seq,
      required this.uid,  
      required this.upassword,
      this.uname,
      this.ugender,
      this.uphone,
      this.uemail,
      this.uinsertdate,
      this.udeleted
    }
  );

  // user info update constructor
  User.update(
    {
      required this.seq,
      required this.uid,  
      required this.upassword,
      required this.uname,
      this.ugender,
      required this.uphone,
      required this.uemail,
      this.uinsertdate,
      this.udeleted
    }
  );



  User.fromMap(Map<String,dynamic> res)  // 생성자   select할때 map형식을 list type으로 바꿈
    : seq =res["seq"],
    uid = res["uid"],
    upassword = res["upassword"],
    uname = res["uname"],
    ugender = res["ugender"],
    uphone = res["uphone"],
    uemail = res["uemail"],
    uinsertdate = res["uinsertdate"],
    udeleted = res["udeleted"];

  
  Map<String, Object?> toMap(){  //db에 넘겨줄때  insert할때  map형식으로 db에 데이터를 넣음  Student생성자를 선언하면 자동으로 map형식으로 됌
    return {
      "seq" : seq,
      "uid" : uid,
      "upassword" : upassword,
      "uname" : uname,
      "ugender" : ugender,
      "uphone" : uphone,
      "uemail" : uemail,
      "uinsertdate" : uinsertdate,
      "udeleted" : udeleted
    };
  }




}