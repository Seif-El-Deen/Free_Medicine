import 'package:flutter/material.dart';
import 'package:free_medicine/models/medicine_model.dart';
import 'package:free_medicine/shared/colors_manager.dart';
import 'package:free_medicine/shared/common_methods.dart';
import 'package:free_medicine/shared/shared_widgets.dart';
import 'package:free_medicine/shared/sizes_manager.dart';
import 'package:free_medicine/services/medicines_sheets_api.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:free_medicine/shared/strings_manager.dart';

import '../services/medicines_shared_pref.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;
  // bool isScannerVisible = false;
  int bodyIndex = 0;

  MedicineModel medicine = MedicineModel(
      name: null,
      barCode: null,
      type: null,
      amount: null,
      providerLocation: null,
      providerContactNumber: null,
      date: null);

  List<MedicineModel> addedMedicines = [];

  void getMedicinesIfExist()async{
    bodyIndex=1;
    setState(() {

    });
    addedMedicines = await MedicinesLocalStorage.getAllMedicinesModelList() ;
    if(addedMedicines.isEmpty){
      bodyIndex=0;
    }else{
      bodyIndex=2;
    }
    setState(() {

    });
  }

  @override
  void initState() {
    getMedicinesIfExist();
    super.initState();
  }


  // void _toggleScanner() {
  //   setState(() {
  //     isScannerVisible = !isScannerVisible;
  //   });
  // }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       medicine.barCode = scanData.code!;
  //       isScannerVisible = false; // Hide the scanner after scanning
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returnedBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Add A Medicine"),
                  insetPadding: const EdgeInsets.symmetric(
                      vertical: AppSizes.s20, horizontal: AppSizes.s10),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            customTextFormField(
                              labelText: "Medicine Name",
                              onChanged: (String? value) {
                                medicine.name = value;
                              },
                            ),
                            sb(h: AppSizes.s30),
                            // textIconButton(
                            //     text: "Scan Medicine Barcode",
                            //     icon: Icons.barcode_reader,
                            //     color: medicine.barCode == null
                            //         ? AppColors.greyColor
                            //         : AppColors.primaryColor,
                            //     onTap: _toggleScanner),
                            // sb(h: AppSizes.s10),
                            // if (isScannerVisible)
                            //   SizedBox(
                            //     height: 200,
                            //     child: QRView(
                            //       key: qrKey,
                            //       onQRViewCreated: _onQRViewCreated,
                            //     ),
                            //   ),
                            // sb(h: AppSizes.s10),
                            textIconButton(
                                text: "Pick Your Location",
                                icon: Icons.location_on,
                                color: medicine.providerLocation != null
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor,
                                onTap: () async {
                                  medicine.providerLocation =
                                      await CommonMethods.getCurrentLocation();
                                  // print(medicine.providerLocation);
                                  setState(() {});
                                }),
                            sb(h: AppSizes.s30),
                            PopupMenuButton<String>(
                                child: textIconButton(
                                  text: "Medicine Type: ${medicine.type}",
                                  icon: Icons.medication_liquid,
                                  color: medicine.type != null
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor,
                                ),
                                onSelected: (String result) {
                                  setState(() {
                                    medicine.type = result;
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    AppStrings.medicineTypes
                                        .map((e) => PopupMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList()),
                            sb(h: AppSizes.s30),
                            customTextFormField(
                              labelText: "Amount",
                              onChanged: (String? value) {
                                medicine.amount = value;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            sb(h: AppSizes.s30),
                            customTextFormField(
                              labelText: "Contact Number",
                              onChanged: (String? value) {
                                medicine.providerContactNumber = value;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            sb(h: AppSizes.s30),
                          ],
                        ),
                      );
                    },
                  ),
                  actions: [
                    textButton(
                        text: "Cancel",
                        color: AppColors.redColor,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    textButton(
                      text: "ADD",
                      color: AppColors.blueColor,
                      onPressed: () async {
                        medicine.date = DateTime.now().toString();
                        MedicineSheetsApi.insert([medicine.toJson()])
                            .then((value) async{
                          CommonMethods.showAlertDialog(
                              context: context,
                              icon: Icons.check_circle_sharp,
                              text: "Medicine Added Successfully");
                          await MedicinesLocalStorage.addMedicine(medicineModel: medicine);
                          getMedicinesIfExist();
                          medicine = MedicineModel(
                              name: null,
                              barCode: null,
                              type: null,
                              amount: null,
                              providerLocation: null,
                              providerContactNumber: null,
                              date: null);
                          setState(() {});
                        });
                        Navigator.pop(context);

                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Widget returnedBody() {
    switch (bodyIndex) {
      case 0:
        return centeredText(text: "Press The Floating Button to Add");
      case 1:
        return loadingWidget();
      case 2:
        return userMedicinesWidget(addedMedicines: addedMedicines);
      case 3:
        centeredText(text: "No Medicines found");
    }
    return centeredText(text: "Reached the Default");
  }
}
