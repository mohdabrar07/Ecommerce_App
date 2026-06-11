class AddressModel {
  final String fullName;
  final String mobileNumber; // Matches UI criteria variable name
  final String emirate;
  final String area;
  final String buildingName; // Matches UI criteria variable name
  final String flatNumber;
  final String landmark;
  final bool isDefault;

  AddressModel({
    required this.fullName,
    required this.mobileNumber,
    required this.emirate,
    required this.area,
    required this.buildingName,
    required this.flatNumber,
    required this.landmark,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? fullName,
    String? mobileNumber,
    String? emirate,
    String? area,
    String? buildingName,
    String? flatNumber,
    String? landmark,
    bool? isDefault,
  }) {
    return AddressModel(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emirate: emirate ?? this.emirate,
      area: area ?? this.area,
      buildingName: buildingName ?? this.buildingName,
      flatNumber: flatNumber ?? this.flatNumber,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'emirate': emirate,
      'area': area,
      'buildingName': buildingName,
      'flatNumber': flatNumber,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) {
    return AddressModel(
      fullName: map['fullName'] as String? ?? '',
      mobileNumber: map['mobileNumber'] as String? ?? '',
      emirate: map['emirate'] as String? ?? '',
      area: map['area'] as String? ?? '',
      buildingName: map['buildingName'] as String? ?? '',
      flatNumber: map['flatNumber'] as String? ?? '',
      landmark: map['landmark'] as String? ?? '',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }
}