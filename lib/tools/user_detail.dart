class UserDetails {
  late String firstName;
  late String lastName;
  late String username;
  late String emailAddress;
  late String userId;
  late String profileImage;
  late String phone;
  late String interests;

  UserDetails(
    this.firstName,
    this.lastName,
    this.username,
    this.emailAddress,
    this.interests,
    this.phone,
    this.userId,
    this.profileImage,
  );
  factory UserDetails.fromDatabase(Map user) {
    return UserDetails(
      user['firstname'],
      user['lastname'],
      user['username'],
      user['email'],
      user['interests'],
      user['phone'],
      user['uid'],
      user['profileImage'],
    );
  }
}
