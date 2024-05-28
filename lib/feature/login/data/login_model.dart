class LoginModel {
  String date;
  String uid;

  LoginModel({required this.date, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'uid': uid,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      date: map['date'],
      uid: map['uid'],
    );
  }
}
