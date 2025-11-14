class Role {
  final String name;

  const Role._(this.name);

  static const admin = Role._('ADMIN');
  static const user = Role._('USER');

  static const values = [admin, user];

  static Role fromString(String? role) {
    if (role == null) throw Exception('Role cannot be null');
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return admin;
      case 'USER':
        return user;
      default:
        throw Exception('Unknown Role: $role');
    }
  }

  @override
  String toString() => name;
}