class AddressModel {
  final String id;
  final String fullName;
  final String mobile;
  final String emirate;
  final String area;
  final String building;
  final String flat;
  final String landmark;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.emirate,
    required this.area,
    required this.building,
    required this.flat,
    required this.landmark,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fullName": fullName,
      "mobile": mobile,
      "emirate": emirate,
      "area": area,
      "building": building,
      "flat": flat,
      "landmark": landmark,
      "isDefault": isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map["id"],
      fullName: map["fullName"],
      mobile: map["mobile"],
      emirate: map["emirate"],
      area: map["area"],
      building: map["building"],
      flat: map["flat"],
      landmark: map["landmark"],
      isDefault: map["isDefault"] ?? false,
    );
  }
}