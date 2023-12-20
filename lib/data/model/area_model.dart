class AreaDataModel {
  int? id; // Add an ID for database primary key
  int? word_id;
  String? ward_name;
  String name;
  String? code;
  String? code_bn;

  AreaDataModel({
    this.id,
    this.word_id,
    this.ward_name,
    required this.name,
    this.code,
    this.code_bn,
  });

  // Named constructor for null initialization
  AreaDataModel.nullConstructor()
      : id = null,
        word_id = null,
        ward_name = '',
        name = '',
        code = '',
        code_bn = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'word_id': word_id,
      'ward_name': ward_name,
      'name': name,
      'code': code,
      'code_bn': code_bn,
    };
  }

  // Create a User Data Model from a Map
  factory AreaDataModel.fromMap(Map<String, dynamic> map) {
    return AreaDataModel(
      id: map['id'],
      word_id: map['word_id'],
      ward_name: map['ward_name'],
      name: map['name'],
      code: map['code'],
      code_bn: map['code_bn'],
    );
  }

  @override
  String toString() {
    return 'AreaDataModel{id: $id, word_id: $word_id, ward_name: $ward_name, name: $name, code: $code, code_bn: $code_bn}';
  }
}
