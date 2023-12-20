class AreaWiseDataModel {
  int? id; // Add an ID for database primary key
  String name;
  String male_voters;
  String female_voters;

  AreaWiseDataModel({
    this.id,
    required this.name,
    required this.male_voters,
    required this.female_voters,
  });

  // Named constructor for null initialization
  AreaWiseDataModel.nullConstructor()
      : id = null,
        name = '',
        male_voters = '',
        female_voters = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'male_voters': male_voters,
      'female_voters': female_voters,
    };
  }

  // Create a User Data Model from a Map
  factory AreaWiseDataModel.fromMap(Map<String, dynamic> map) {
    return AreaWiseDataModel(
      id: map['id'],
      name: map['name'],
      male_voters: map['male_voters'],
      female_voters: map['female_voters'],
    );
  }

  @override
  String toString() {
    return 'AreaWiseDataModel{id: $id, name: $name, male_voters: $male_voters, female_voters: $female_voters}';
  }
}
