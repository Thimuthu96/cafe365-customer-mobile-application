class User {
  String? id;
  String? name;
  String? mobile;
  String? city;
  String? email;
  String? password;

  User({
    this.id,
    this.name,
    this.mobile,
    this.city,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'city': city,
      'email': email,
      'password': password,
    };
  }

  User.fromMap(Map<String, dynamic> user) {
    id = user['id'];
    name = user['name'];
    mobile = user['mobile'];
    city = user['city'];
    email = user['email'];
    password = user['password'];
  }
}
