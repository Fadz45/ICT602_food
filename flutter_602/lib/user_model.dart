class AppUser {
  final String uid;
  final String email; // Add email property
  late final String name;
  late final int age;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
  });
}
