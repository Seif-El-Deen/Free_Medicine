class MedicineFields {
  static const String name = 'medicine_name';
  static const String barCode = 'medicine_bar_code';
  static const String type = 'medicine_type';
  static const String amount = "medicine_amount";
  static const String providerLocation = "medicine_provider_location";
  static const String providerContactNumber =
      "medicine_provider_contact_number";
  static const String date = "date";

  static List<String> getFields() => [
        name,
        barCode,
        type,
        amount,
        providerLocation,
        providerContactNumber,
        date,
      ];
}

class MedicineModel {
  String? name;
  String? barCode;
  String? type;
  String? amount;
  String? providerLocation;
  String? providerContactNumber;
  String? date;

  MedicineModel({
    required this.name,
    required this.barCode,
    required this.type,
    required this.amount,
    required this.providerLocation,
    required this.providerContactNumber,
    required this.date,
  });

  MedicineModel copy({
    String? name,
    String? barCode,
    String? type,
    String? amount,
    String? providerLocation,
    String? providerContactNumber,
    String? date,
  }) =>
      MedicineModel(
          name: name ?? this.name,
          barCode: barCode ?? this.barCode,
          type: type ?? this.type,
          amount: amount ?? this.amount,
          providerLocation: providerLocation ?? this.providerLocation,
          providerContactNumber:
              providerContactNumber ?? this.providerContactNumber,
          date: date ?? this.date);

  Map<String, dynamic> toJson() => {
        MedicineFields.name: name,
        MedicineFields.barCode: barCode,
        MedicineFields.type: type,
        MedicineFields.amount: amount,
        MedicineFields.providerLocation: providerLocation,
        MedicineFields.providerContactNumber: providerContactNumber,
        MedicineFields.date: date,
      };

  static MedicineModel fromJson(Map<String, dynamic> json) => MedicineModel(
        name: json[MedicineFields.name],
        barCode: json[MedicineFields.barCode],
        type: json[MedicineFields.type],
        amount: json[MedicineFields.amount],
        providerLocation: json[MedicineFields.providerLocation],
        providerContactNumber: json[MedicineFields.providerContactNumber],
        date: json[MedicineFields.date],
      );
}

// medicine_name	medicine_bar_code
// medicine_type	medicine_amount
// medicine_provider_location
// medicine_provider_contact_number	date
