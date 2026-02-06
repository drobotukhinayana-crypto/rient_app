enum UserRole {
  owner(0, 'Владелец'),
  administrator(1, 'Администратор'),
  manager(2, 'Менеджер'),
  client(3, 'Клиент'),
  worker(4, 'Сотрудник');

  const UserRole(this.value, this.title);

  final int value;
  final String title;

  static UserRole fromInt(int v) =>
      UserRole.values.firstWhere((e) => e.value == v);
}
