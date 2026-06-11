class AddressModel {
  final String fullName;
  final String mobile;
  final String emirate;
  final String area;
  final String building;
  final String flat;
  final String landmark;

  AddressModel({
    required this.fullName,
    required this.mobile,
    required this.emirate,
    required this.area,
    required this.building,
    required this.flat,
    required this.landmark,
  });

  Map<String,dynamic> toMap() {
    return {
      "fullName": fullName,
      "mobile": mobile,
      "emirate": emirate,
      "area": area,
      "building": building,
      "flat": flat,
      "landmark": landmark,
    };
  }

  factory AddressModel.fromMap(
    Map<dynamic,dynamic> map,
  ) {
    return AddressModel(
      fullName: map["fullName"],
      mobile: map["mobile"],
      emirate: map["emirate"],
      area: map["area"],
      building: map["building"],
      flat: map["flat"],
      landmark: map["landmark"],
    );
  }
}