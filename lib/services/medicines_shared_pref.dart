import 'package:free_medicine/models/medicine_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicinesLocalStorage {
  static const String medicines = 'medicines';

  static Future<void>  addMedicine({required MedicineModel medicineModel}) async {
    final prefs = await SharedPreferences.getInstance();

    // Example of saving data
    // await prefs.setInt();
    // await prefs.setString('username', 'JohnDoe');
    // await prefs.setBool('isLoggedIn', true);

    List<String> medicines = await getAllMedicinesStringsList();

    medicines.add(
        "${medicineModel.name ?? ''},${medicineModel.barCode ?? ''},${medicineModel.type ?? ''},${medicineModel.amount ?? ''},${medicineModel.providerLocation ?? ''},${medicineModel.providerContactNumber ?? ''},${medicineModel.date ?? ''}");

    await prefs.setStringList(MedicinesLocalStorage.medicines, medicines);
  }

  static Future<void>  deleteMedicine({required MedicineModel medicineModel}) async {
    final prefs = await SharedPreferences.getInstance();

    // Example of saving data
    // await prefs.setInt();
    // await prefs.setString('username', 'JohnDoe');
    // await prefs.setBool('isLoggedIn', true);

    List<String> medicines = await getAllMedicinesStringsList();

    medicines.forEach((element) {
      print(element);
    });

    // print(medicines.length);
    // print("${medicineModel.name ?? ''},${medicineModel.barCode ?? ''},${medicineModel.type ?? ''},${medicineModel.amount ?? ''},${medicineModel.providerLocation ?? ''},${medicineModel.providerContactNumber ?? ''},${medicineModel.date ?? ''}");

    int index= medicines.indexOf(
        "${medicineModel.name ?? ''},${medicineModel.barCode ?? ''},${medicineModel.type ?? ''},${medicineModel.amount ?? ''},${medicineModel.providerLocation ?? ''},${medicineModel.providerContactNumber ?? ''},${medicineModel.date ?? ''}");
    medicines.removeAt(index);
    // print(medicines.length);

    await prefs.setStringList(MedicinesLocalStorage.medicines, medicines);
  }


  static Future<List<String>> getAllMedicinesStringsList() async {
    final prefs = await SharedPreferences.getInstance();

    // Example of retrieving data
    // int? counter = prefs.getInt('counter');
    // bool? isLoggedIn = prefs.getBool('isLoggedIn');

    List<String>? medicines =
        prefs.getStringList(MedicinesLocalStorage.medicines);

    return medicines ?? [];
  }

  static Future<List<MedicineModel>> getAllMedicinesModelList() async {
    List<String> medicinesStrings = await getAllMedicinesStringsList();

    List<MedicineModel> medicines = [];
    List<String> medicine = [];
    medicinesStrings.forEach((medicineString) {
      // print(medicineString);
      medicine = medicineString.split(',');
      if (medicine.isNotEmpty) {
        medicines.add(MedicineModel(
            name: medicine[0],
            barCode: medicine[1],
            type: medicine[2],
            amount: medicine[3],
            providerLocation: "${medicine[4]??''},${medicine[5]??''}",
            providerContactNumber: medicine[6],
            date: medicine[7]));
      }
      medicine = [];
    });

    return medicines ?? [];
  }

  static Future<void> removeData() async {
    final prefs = await SharedPreferences.getInstance();

    // Example of removing data
    await prefs.remove(MedicinesLocalStorage.medicines);
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all data
    await prefs.clear();
  }
}
