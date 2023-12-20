class VotarDataModel {
  int? id; // Add an ID for database primary key
  String info;
  String gender;
  String ward_name;
  String voter_area_name;
  String voter_area_no;
  String center_name;

  VotarDataModel({
    this.id,
    required this.info,
    required this.gender,
    required this.ward_name,
    required this.voter_area_name,
    required this.voter_area_no,
    required this.center_name,
  });

  // Named constructor for null initialization
  VotarDataModel.nullConstructor()
      : id = null,
        info = '',
        gender = '',
        ward_name = '',
        voter_area_name = '',
        voter_area_no = '',
        center_name = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'info': info,
      'gender': gender,
      'ward_name': ward_name,
      'voter_area_name': voter_area_name,
      'voter_area_no': voter_area_no,
      'center_name': center_name,
    };
  }

  // Create a User Data Model from a Map
  factory VotarDataModel.fromMap(Map<String, dynamic> map) {
    return VotarDataModel(
      id: map['id'],
      info: map['info'],
      gender: map['gender'],
      ward_name: map['ward_name'],
      voter_area_name: map['voter_area_name'],
      voter_area_no: map['voter_area_no'],
      center_name: map['center_name'],
    );
  }

  @override
  String toString() {
    return 'VotarDataModel{id: $id, info: $info, gender: $gender, ward_name: $ward_name, voter_area_name: $voter_area_name, voter_area_no: $voter_area_no, center_name: $center_name}';
  }
}
