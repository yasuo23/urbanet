// class conn {
//   static late conn _instance;

//   var id;
//   String? name;
//   String? email;

//   factory conn({var id, String? name, String? email}) {
//     if (_instance == null) {
//       conn._(id: id, name: name, email: email);
//     }
//     return _instance;
//   }

//   conn._({this.id, this.name, this.email});

//   String? get userId => id;
//   String? get userName => name;
//   String? get userEmail => email;
//   void disconnect() {
//     id = null;
//     name = null;
//     email = null;
//   }
// }
class conn {
  static var idUser;
  static String? nameuser = '';
  static String? emailuser = '';
  static String imageuser = '';
  static String? phoneuser = '';
  conn() {}

  void setconn(
      var id, String name, String email, String profile, String phone) {
    idUser = id;
    nameuser = name;
    emailuser = email;
    imageuser = profile;
    phoneuser = phone;
  }

  String? get userId => idUser;
  String? get userName => nameuser;
  String? get userEmail => emailuser;
  String? get imageUser => imageuser;
  String? get userphone => phoneuser;

  static void disconnect() {
    idUser = null;
    nameuser = null;
    emailuser = null;
    imageuser = '';
  }
}
