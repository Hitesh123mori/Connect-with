


class Address {
  String? cityName;
  String? stateName;
  String? countryName;

  Address({this.cityName, this.stateName, this.countryName});

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'stateName': stateName,
      'countryName': countryName,
    };
  }

  factory Address.fromJson(dynamic json) {
    return Address(
      cityName: json['cityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
    );
  }
}