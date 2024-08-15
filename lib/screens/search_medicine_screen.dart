import 'package:flutter/material.dart';
import 'package:free_medicine/services/medicines_sheets_api.dart';
import 'package:free_medicine/shared/colors_manager.dart';
import 'package:free_medicine/shared/common_methods.dart';
import 'package:free_medicine/shared/shared_widgets.dart';
import 'package:free_medicine/shared/sizes_manager.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/medicine_model.dart';

class SearchMedicineScreen extends StatefulWidget {
  const SearchMedicineScreen({super.key});

  @override
  State<SearchMedicineScreen> createState() => _SearchMedicineScreenState();
}

class _SearchMedicineScreenState extends State<SearchMedicineScreen> {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;
  // bool isScannerVisible = false;

  String? medicineName = "";

  // String? medicineBarcode = "";
  String? searcherLocation = "";

  int bodyIndex = 0;

  // 0: no items searched yet
  // 1: is loading
  // 2: items returned
  // 3: no items found

  List<MedicineModel> searchedMedicines = [];

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       medicineBarcode = scanData.code!;
  //       isScannerVisible = false; // Hide the scanner after scanning
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returnedBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Search A Medicine"),
                  insetPadding: const EdgeInsets.symmetric(
                      vertical: AppSizes.s50, horizontal: AppSizes.s10),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            customTextFormField(
                              labelText: "Medicine Name",
                              onChanged: (String? value) {
                                medicineName = value;
                              },
                            ),
                            sb(h: AppSizes.s40),
                            // textIconButton(
                            //   text: "Scan Medicine Barcode",
                            //   icon: Icons.barcode_reader,
                            //   onTap: () {
                            //     setState(() {
                            //       isScannerVisible = !isScannerVisible;
                            //     });
                            //   },
                            //   color: CommonMethods.noValue(medicineBarcode)
                            //       ? AppColors.greyColor
                            //       : AppColors.greenColor,
                            // ),
                            // if (isScannerVisible)
                            //   SizedBox(
                            //     height: 200,
                            //     child: QRView(
                            //       key: qrKey,
                            //       onQRViewCreated: _onQRViewCreated,
                            //     ),
                            //   ),
                            textIconButton(
                                text: searcherLocation!.isEmpty
                                    ? 'Pick Your Location'
                                    : 'Location Added',
                                icon: Icons.location_on,
                                color: CommonMethods.noValue(searcherLocation)
                                    ? AppColors.greyColor
                                    : AppColors.greenColor,
                                onTap: () async {
                                  await CommonMethods.checkLocationService(
                                      context);
                                  searcherLocation =
                                      await CommonMethods.getCurrentLocation();
                                  // print(searcherLocation);
                                  setState(() {});
                                }),
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
                        text: "Search",
                        color: AppColors.blueColor,
                        onPressed: () async {
                          if (CommonMethods.noValue(medicineName)) {
                            CommonMethods.errorValue(
                                context: context,
                                value: medicineName,
                                text: "No Medicine Name");
                          } else if (CommonMethods.noValue(searcherLocation)) {
                            CommonMethods.errorValue(
                                context: context,
                                value: searcherLocation,
                                text: "Your location is not added");
                          } else {
                            // MedicineSheetsApi.getAll().then((value) {
                            //   searchedMedicines = value;
                            //   if (searchedMedicines.isEmpty) {
                            //     bodyIndex = 3;
                            //   } else {
                            //     bodyIndex = 2;
                            //   }
                            //   setState(() {});
                            //   Navigator.pop(context);
                            // });
                            // print(searcherLocation);
                            MedicineSheetsApi.getByNameAndLocation(
                                    name: medicineName!,
                                    location: searcherLocation!)
                                .then((value) {
                              searchedMedicines = value;
                              if (searchedMedicines.isEmpty) {
                                bodyIndex = 3;
                              } else {
                                bodyIndex = 2;
                              }
                              setState(() {});
                              Navigator.pop(context);
                            });
                          }
                        }),
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
        return centeredText(text: "Press The Floating Button to Search");
      case 1:
        return loadingWidget();
      case 2:
        return medicinesWidget(searchedMedicines: searchedMedicines,searcherLocation: searcherLocation);
      case 3:
        return centeredText(text: "No Medicines found");
    }
    return centeredText(text: "Reached the Default");
  }


}
