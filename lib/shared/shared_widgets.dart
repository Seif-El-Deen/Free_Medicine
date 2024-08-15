import 'package:flutter/material.dart';
import 'package:free_medicine/models/medicine_model.dart';
import 'package:free_medicine/services/medicines_shared_pref.dart';
import 'package:free_medicine/services/medicines_sheets_api.dart';
import 'package:free_medicine/shared/colors_manager.dart';
import 'package:free_medicine/shared/common_methods.dart';
import 'package:free_medicine/shared/sizes_manager.dart';

Widget sb({double w = 0, double h = 0}) {
  return SizedBox(width: w, height: h);
}

Widget textIconButton({
  required String text,
  required IconData icon,
  Color color = AppColors.greyColor,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSizes.s10, horizontal: AppSizes.s20),
      margin: const EdgeInsets.symmetric(vertical: AppSizes.s10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: AppSizes.s16),
            overflow: TextOverflow.ellipsis,
          ),
          sb(w: AppSizes.s20),
          Icon(
            icon,
            size: AppSizes.s50,
          ),
        ],
      ),
    ),
  );
}

Widget textButton({
  required String text,
  Color color = AppColors.greyColor,
  void Function()? onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(fontSize: AppSizes.s16, color: color),
    ),
  );
}

Widget customTextFormField(
    {void Function(String)? onChanged,
    TextInputType? keyboardType,
    String? labelText}) {
  return TextFormField(
    onChanged: onChanged,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: AppColors.greyColor,
      ),
    ),
    keyboardType: keyboardType,
  );
}

Widget centeredText({required String text}) {
  return Center(
    child: Text(text),
  );
}

Widget loadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget customDivider() {
  return const Padding(
    padding: EdgeInsets.all(AppSizes.s10),
    child: Divider(
      color: AppColors.primaryColor,
      thickness: AppSizes.s3,
    ),
  );
}

Widget medicinesWidget(
    {required List<MedicineModel> searchedMedicines,
    required String? searcherLocation}) {
  return ListView.separated(
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: () {
          CommonMethods.showAlertDialog(
              context: context,
              icon: Icons.call,
              text:
                  "Phone Number: ${searchedMedicines[index].providerContactNumber}");
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
          decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(AppSizes.s16),
              border: Border.all(width: 3, color: AppColors.primaryColor)),
          child: ListTile(
            title: Text(
              searchedMedicines[index].name ?? "",
              style: const TextStyle(
                  fontSize: AppSizes.s22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor),
            ),
            subtitle: Text(
              "Amount: ${searchedMedicines[index].amount ?? ''}\nDistance: ${CommonMethods.calculateDistanceKM(searchedMedicines[index].providerLocation!, searcherLocation!).round()} Km",
              // CommonMethods.calculateDistanceKM(searcherLocation!,searchedMedicines[index].providerLocation!)
              style: const TextStyle(
                  fontSize: AppSizes.s16, fontWeight: FontWeight.w500),
            ),
            trailing: medicineTypeWidget(searchedMedicines[index].type ?? ""),
          ),
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return customDivider();
    },
    itemCount: searchedMedicines.length,
  );
}

Widget userMedicinesWidget({required List<MedicineModel> addedMedicines}) {
  return ListView.separated(
    itemBuilder: (BuildContext context, int index) {
      // Phone Number: ${addedMedicines[index].providerContactNumber}
      return Dismissible(
        key: Key(addedMedicines[index].name ?? ''),
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
          decoration: BoxDecoration(
            color: AppColors.redColor,
            borderRadius: BorderRadius.circular(AppSizes.s16),
          ),
          // alignment: Alignment.centerLeft,
          child: const Padding(
            padding:  EdgeInsets.all(AppSizes.s10),
            child:  Row(
              children: [
                Icon(Icons.delete, color: AppColors.blackColor,size: AppSizes.s40),
                Text(
                  " Delete ",
                  style:  TextStyle(
                      fontSize: AppSizes.s22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor),
                ),
                Spacer(),
                Icon(Icons.delete, color: AppColors.blackColor,size: AppSizes.s40)

              ],
            ),
          ),
        ),
        onDismissed: (direction)async{
          await MedicinesLocalStorage.deleteMedicine(medicineModel: addedMedicines[index]);
          await MedicineSheetsApi.deleteMedicine(addedMedicines[index]);
          CommonMethods.showAlertDialog(
              context: context,
              icon: Icons.check_circle_sharp,
              text: "Medicine Deleted Successfully");
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
          padding: const EdgeInsets.all(AppSizes.s10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(AppSizes.s16),
              border: Border.all(
                  width: AppSizes.s5, color: AppColors.primaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Medicine Name: ${addedMedicines[index].name ?? ''}",
                style: const TextStyle(
                    fontSize: AppSizes.s22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
              Text(
                "Amount: ${addedMedicines[index].amount ?? ''}",
                // CommonMethods.calculateDistanceKM(searcherLocation!,searchedMedicines[index].providerLocation!)
                style: const TextStyle(
                    fontSize: AppSizes.s20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greenColor),
              ),
              Text(
                "Medicine Type: ${addedMedicines[index].type ?? ''}",
                // CommonMethods.calculateDistanceKM(searcherLocation!,searchedMedicines[index].providerLocation!)
                style: const TextStyle(
                    fontSize: AppSizes.s20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
            ],
          ),
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return customDivider();
    },
    itemCount: addedMedicines.length,
  );
}

Widget medicineTypeWidget(String medType) {
  // switch(medType){
  //   case "Pills":
  //     return Icon(Icons.circle);
  //   case "Liquid":
  //     return Icon(Icons.medication_liquid);
  // }
  // return Icon(Icons.medication);

  return Text(
    medType,
    style: const TextStyle(
      fontSize: AppSizes.s18,
      overflow: TextOverflow.clip,
      color: AppColors.whiteColor,
    ),
  );
}


Widget contactWidget({ IconData? icon,required String text, required String link }){
  return InkWell(
    child:  Container(
      padding: const EdgeInsets.all(AppSizes.s5),
      width: double.infinity,
      decoration: BoxDecoration(
          color:AppColors.blueColor,
          borderRadius: BorderRadius.circular(20)
      ),

      child:  Column(
        children: [
          icon!=null?
          Icon(icon,size: AppSizes.s40,):const SizedBox(),
          Text(
            text,
            style:const TextStyle(
                fontSize: AppSizes.s20
            ),maxLines: 2,
          ),
        ],
      ),
    ),
    onTap: () =>  CommonMethods.launchEmail(link),
  );
}
