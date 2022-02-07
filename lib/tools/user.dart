class User {
  String? email;
  String? uid;
  bool emailVerified;

  User(this.email, this.uid, this.emailVerified);

  String getUid() {
    return this.uid!;
  }
}
