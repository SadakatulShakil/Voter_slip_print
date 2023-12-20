class WordDataModel {
  int? id; // Add an ID for database primary key
  String name;

  WordDataModel({
    this.id,
    required this.name,
  });

  // Named constructor for null initialization
  WordDataModel.nullConstructor()
      : id = null,
        name = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Create a User Data Model from a Map
  factory WordDataModel.fromMap(Map<String, dynamic> map) {
    return WordDataModel(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'VotarDataModel{id: $id, name: $name}';
  }
}
