class DashInfoModel {
  int? id; // Add an ID for database primary key
  String total_voters;
  String total_voters_with_migrate;
  String total_centers;

  DashInfoModel({
    this.id,
    required this.total_voters,
    required this.total_voters_with_migrate,
    required this.total_centers,
  });

  // Named constructor for null initialization
  DashInfoModel.nullConstructor()
      : id = null,
        total_voters = '',
        total_voters_with_migrate = '',
        total_centers = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'total_voters': total_voters,
      'total_voters_with_migrate': total_voters_with_migrate,
      'total_centers': total_centers,
    };
  }

  // Create a User Data Model from a Map
  factory DashInfoModel.fromMap(Map<String, dynamic> map) {
    return DashInfoModel(
      id: map['id'],
      total_voters: map['total_voters'],
      total_voters_with_migrate: map['total_voters_with_migrate'],
      total_centers: map['total_centers'],
    );
  }

  @override
  String toString() {
    return 'DashInfoModel{id: $id, total_voters: $total_voters, total_voters_with_migrate: $total_voters_with_migrate, total_centers: $total_centers}';
  }
}
