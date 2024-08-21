class ProvinceModel {
  String name;
  String xml;

  ProvinceModel({required this.name,
    required this.xml,});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'xml': xml,
    };
  }

  factory ProvinceModel.fromMap(Map<String, dynamic> map) {
    return ProvinceModel(
      name: map['name'] ?? '',
      xml: map['xml'] ?? '',
    );
  }
}
