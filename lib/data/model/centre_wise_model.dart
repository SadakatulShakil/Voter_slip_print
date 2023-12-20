class CenterWiseDataModel {
  int? id; // Add an ID for database primary key
  String name;
  String from;
  String to;

  CenterWiseDataModel({
    this.id,
    required this.name,
    required this.from,
    required this.to,
  });

  // Named constructor for null initialization
  CenterWiseDataModel.nullConstructor()
      : id = null,
        name = '',
        from = '',
        to = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'from': from,
      'to': to,
    };
  }

  // Create a User Data Model from a Map
  factory CenterWiseDataModel.fromMap(Map<String, dynamic> map) {
    return CenterWiseDataModel(
      id: map['id'],
      name: map['name'],
      from: map['from'],
      to: map['to'],
    );
  }

  @override
  String toString() {
    return 'AreaWiseDataModel{id: $id, name: $name, from: $from, to: $to}';
  }
}
