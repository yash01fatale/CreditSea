import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? pan;
  String? gender;
  String? address;
  DateTime? dob;
  int creditScore;
  bool profileCompleted;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.pan,
    this.gender,
    this.address,
    this.dob,
    this.creditScore = 0,
    this.profileCompleted = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      pan: json['pan'],
      gender: json['gender'],
      address: json['address'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      creditScore: json['creditScore'] ?? 0,
      profileCompleted: json['profileCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (pan != null) 'pan': pan,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (dob != null) 'dob': dob!.toIso8601String(),
      'creditScore': creditScore,
      'profileCompleted': profileCompleted,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(jsonDecode(str));

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? pan,
    String? gender,
    String? address,
    DateTime? dob,
    int? creditScore,
    bool? profileCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      pan: pan ?? this.pan,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      creditScore: creditScore ?? this.creditScore,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }
}
