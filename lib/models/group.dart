class Group {
  final String? id;
  final String? adminId;
  final String name;
  final int? code;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Group({
    this.id,
    this.code,
    this.adminId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    print('converting to object');
    return Group(
      id: json['id'],
      adminId: json['adminId'],
      // code: int.parse(json['code']),
      code: json['code'],
      name: json['name'],
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static Map<String, dynamic> toJson(Group group) {
    return {
      'id': group.id,
      'adminId': group.adminId,
      'name': group.name,
      'code': group.code,
      // 'createdAt': group.createdAt,
      // 'updatedAt': group.updatedAt,
    };
  }
}
