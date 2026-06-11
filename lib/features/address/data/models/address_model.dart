class AddressModel {
  final String id; // Remains final and non-nullable for runtime safety
  final String fullName;
  final String mobileNumber;
  final String emirate;
  final String area;
  final String buildingName;
  final String flatNumber;
  final String landmark;
  bool isDefault;

  AddressModel({
    String? id, // FIX: Changed to optional parameter in the constructor
    required this.fullName,
    required this.mobileNumber,
    required this.emirate,
    required this.area,
    required this.buildingName,
    required this.flatNumber,
    required this.landmark,
    this.isDefault = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(); // FIX: Automatically generates a unique ID if your Cubit forgets to pass one!

  String get fullAddressText => 
      "Flat $flatNumber, $buildingName, $area, $landmark, $emirate";

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id']?.toString(),
      fullName: map['fullName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      emirate: map['emirate'] ?? '',
      area: map['area'] ?? '',
      buildingName: map['buildingName'] ?? '',
      flatNumber: map['flatNumber'] ?? '',
      landmark: map['landmark'] ?? '',
      isDefault: map['isDefault'] == 1 || map['isDefault'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'emirate': emirate,
      'area': area,
      'buildingName': buildingName,
      'flatNumber': flatNumber,
      'landmark': landmark,
      'isDefault': isDefault ? 1 : 0,
    };
  }
}