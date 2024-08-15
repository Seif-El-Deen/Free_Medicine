import 'package:flutter/cupertino.dart';
import 'package:free_medicine/models/medicine_model.dart';
import 'package:free_medicine/shared/common_methods.dart';
import 'package:gsheets/gsheets.dart';

class MedicineSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-356206",
  "private_key_id": "33c5e3f3655c8b8d5c63eea3fe8f3e0ed270dca8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC30J0NT9C4skRX\n4oTaBuDM94tRJO7uHblUtA8KefI/dC5KChyWTtYquHPYiEn5FwXZ4mKXegMLyGDO\n3wi3FVUjd/UNb1QNIsBXWNm/eoy5Vh0xAg1HJQUEYkA/CyMeGx8kpommqA3PonTj\nJPOY1sM5b5dC7A2CwMqCNpnP/l3kY4hErMTHfHeJs6dKoyvfpdSp1dUp5wG0AS7o\nJi+BR0oHpJV2CeDutDFNhZqC6m/iNP6r2YznZzcYvbLCmxsuTPqDWzEeAbrtL0tT\n2efiyMTemtiqyB22w5in07QATNpCKvOj4zJowMF/fNCwYezxN1HNv4k0Lw4vMRAu\nCLAzy6OVAgMBAAECggEAM10G1bZs439k243/g5ESdhPiCS2h2kXSCNo7rbi/uX10\nhdnnfRTQgaWDMYl76i/FwcmhtSQx/7PhYU0veUFrxfp6LmPif70rM/0u83OCKTPn\n+k7ReQTeLwhpXXR2Pq5jeHFU243wNgn2UZZ8v0Obz8vf36JocBYBQHuTZWx1viCc\nU7xHsDsnFdgZPx9CxxrFSXF0f5QP/IqrDhVltWcLtJZ+mdn83t+KB5XIxA5J3HSO\n0FANXJZ1lk9ccr+Ne9xEm8sO8LHKDabKy5idEYyo+fX9nEjjts7j9Rckrm0GJKTO\nIqL1rWOKQ67mGJdLlet6wvwfuJO9rB91NUEajsU/zQKBgQDqlGeqUHiz8St9xsYj\nzadZ+LpUKS9EYLfhmgjT8dj8k6AJQegZ0q9M9aoh3zk9+QHsai8WkUTarmWYMiA4\nBmLfZ6+SIqHYQCiv12EiGrO+Jwdx/6d+VMF/yB8JT7jTRnB+Am1azCzRbYayApNR\nLKoISYVo6+X/IsWnWVs+OFig2wKBgQDImYRzb1s6I5RvQQIQTIRdsjOQFfjf2/5A\n7E9vEGC9xEh/ZNdNAOv7hNSvu8Nz8CCWTiaveWf18ANvfHKqEsR7QXmCcKKnQiS5\n5j8HiYPqWECi9OcAJpMM1oxIwgc/11PQUjmoW3XC+/vh4HZFlVfrVSIHuaZWjcC0\noTO0GvYATwKBgDQ61toVEMr/568ZkwRlxd1ChDo48U1IO6j/oveN4cJbHEbzZbpa\nLq30BO2FxjkGOGdrPRDJR4tpSTWZ85KF2X3kmDLxgxejMWv1iKsPRvYPupinU6PN\nO0g4RrDMD1r7VBC6eZ691zzKJjN8X1CzoSg3Nn0mCQ/FrjyUqLwxz4oBAoGAIY2c\nG/raVYUyBNHo2HUUBuARw94I/Ni9VHqyZq9knxk/zx887AJldnKnaKWNcc0OhlWY\nHu29t+Nnj7RPMadl+f/fpTPV4QgtQHMEw+v6hq4wUZGJOfs5yYHxgRIDSGhp+oRm\nZIS30992KDf1UHpEdHaO9J/W9M9NFmmITm3cC/0CgYBb7BA/IwjfVTQj29oqb+eB\n3WShOY07h74DzYnruZERCGM5ymPaY2h6sxPC5+XBb1MbGm+1phF58UZaIDt3/yPv\nVoh3NhVJPjV767bWu971Z4dVrxTD9y49rTaO0RaL4Prn5YmLG3O7LgtLAE+VTLDD\nf1aXFqR0iu5Sl2so9ctPcA==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-356206.iam.gserviceaccount.com",
  "client_id": "108284686644495254943",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-356206.iam.gserviceaccount.com"
}
  ''';
  static const _spreadsheetId = '1fTfPHrFx-zQJFbjT_hXSpfHrowyOrKxpzFQeE9stTcQ';

  static final _gSheets = GSheets(_credentials);

  static Worksheet? _medicineSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gSheets.spreadsheet(_spreadsheetId);
      _medicineSheet = await _getWorkSheet(spreadsheet, title: 'Medicines');
      // final firstRow = MedicineFields.getFields();
      // _medicineSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      debugPrint('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_medicineSheet == null) return;
    _medicineSheet!.values.map.appendRows(rowList);
  }

  static Future<int> getRowCount() async {
    // print("ENtered the function");
    if (_medicineSheet == null) return 0;
    final lastRow = await _medicineSheet!.values.lastRow();
    // print(lastRow);
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future<MedicineModel?> getById(int id) async {
    if (_medicineSheet == null) return null;
    final json = await _medicineSheet!.values.map.rowByKey(id, fromColumn: 1);
    return json == null ? null : MedicineModel.fromJson(json);
  }

  static Future<List<MedicineModel>> getAll() async {
    if (_medicineSheet == null) return <MedicineModel>[];
    final medicines = await _medicineSheet!.values.map.allRows();

    medicines == null
        ? <MedicineModel>[]
        : medicines.map(MedicineModel.fromJson).forEach((medicine) {
            // print(medicine.providerLocation);
          });

    return medicines == null
        ? <MedicineModel>[]
        : medicines.map(MedicineModel.fromJson).toList();
  }

  static Future<List<MedicineModel>> getByNameAndLocation(
      {required String name, required String location}) async {
    List<MedicineModel> allList = await getAll();
    List<MedicineModel> returnedList = [];
    for (int i = 0; i < allList.length; i++) {
      // print(allList[i].providerLocation!);
      // print(location);
      if (allList[i].name != null
                &&
                allList[i].providerLocation != null && allList[i].name!.contains(name)
          // && CommonMethods.calculateDistanceKM(allList[i].providerLocation!, location)<=10
          ) {
        // print(CommonMethods.calculateDistanceKM(allList[i].providerLocation!, location));
        returnedList.add(allList[i]);
      }
    }
    return returnedList;
  }

  static Future<bool> update(
    int id,
    Map<String, dynamic> user,
  ) async {
    if (_medicineSheet == null) return false;

    return _medicineSheet!.values.map.insertRowByKey(id, user);
  }

  static Future<bool> updateCell({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    if (_medicineSheet == null) return false;

    return _medicineSheet!.values.insertValueByKeys(
      value,
      columnKey: key,
      rowKey: id,
    );
  }

  static Future<bool> deleteMedicine(MedicineModel medicineModel) async {
    List<MedicineModel> allMedicines = await getAll();
    int index = -1;
    for (int i = 0; i < allMedicines.length; i++) {
      // print(allMedicines[i].providerContactNumber);
      if (allMedicines[i].providerContactNumber ==
              medicineModel.providerContactNumber &&
          allMedicines[i].name == medicineModel.name) {
        index = i + 2;
        // print(index);
        // print("found");
        break;
      }
    }
    if (_medicineSheet == null) return false;
    // final index = await _medicineSheet!.values.rowIndexOf(id);
    if (index == -1) return false;
    return _medicineSheet!.deleteRow(index);
  }

  static Future<bool> deleteById(int id) async {
    if (_medicineSheet == null) return false;
    final index = await _medicineSheet!.values.rowIndexOf(id);
    if (index == -1) return false;
    return _medicineSheet!.deleteRow(index);
  }
}
