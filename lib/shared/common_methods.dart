import 'dart:math';

import 'package:flutter/material.dart';
import 'package:free_medicine/shared/colors_manager.dart';
import 'package:free_medicine/shared/shared_widgets.dart';
import 'package:free_medicine/shared/sizes_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonMethods {
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permissions are denied.";
      }
      // return "Location services are disabled.";
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permissions are denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Location permissions are permanently denied.";
    }

    Geolocator.getLastKnownPosition().then((value) => print(value?.longitude));

    // If permissions are granted, get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // print("${position.latitude},${position.longitude}");
    print(position);
    return "${position.latitude},${position.longitude}";
  }

  static Future<void> checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to prompt user to enable location services
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enable Location Services"),
            content: const Text(
                "Location services are disabled. Please enable them in your device settings."),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Settings"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openLocationSettings();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   QRViewController? controller;
  //   controller?.scannedDataStream.listen((scanData) {
  //     // Handle the scanned barcode data
  //     print('Scanned code: ${scanData.code}');
  //     // Do something with the scanned data (e.g., navigate to another screen)
  //   });
  // }

  static void showAlertDialog(
      {required BuildContext context,
      required IconData icon,
      Color iconColor = AppColors.greenColor,
      required String text}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: AppSizes.s50,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static bool noValue(String? value) {
    if (value == null || value.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static void errorValue(
      {required BuildContext context,
      required String? value,
      required String text}) {
    if (noValue(value)) {
      CommonMethods.showAlertDialog(
        context: context,
        icon: Icons.cancel,
        iconColor: AppColors.redColor,
        text: text,
      );
    }
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static double calculateDistanceKM(String location1, String location2) {
    const int earthRadius = 6371; // Earth radius in kilometers

    List<String> loc1 = location1.split(',');
    List<String> loc2 = location2.split(',');
    // print(loc1);
    // print(loc2);
    double distance = -1;
    try {
      double startLatitude = double.parse(loc1[0]);
      double startLongitude = double.parse(loc1[1]);
      double endLatitude = double.parse(loc2[0]);
      double endLongitude = double.parse(loc2[1]);

      double dLat = _degreesToRadians(endLatitude - startLatitude);
      double dLon = _degreesToRadians(endLongitude - startLongitude);

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(_degreesToRadians(startLatitude)) *
              cos(_degreesToRadians(endLatitude)) *
              sin(dLon / 2) *
              sin(dLon / 2);

      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      distance = earthRadius * c;
    } catch (exe) {
      distance = -1;
    }
    return distance;
  }

  static void aboutUsDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Column(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.greenColor,
                size: AppSizes.s50,
              ),
              const Text(
                "App Idea",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                "The Idea of the application is that if you have a medicine that you don't use any more, you can help some one who can't afford buying it, and give it to him for free.",
                textAlign: TextAlign.center,
              ),
              const Text(
                "Developer",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                "This app is developed and maintained by\nSeif El-Deen Mostafa\n A software engineer who is trying to make something useful in this world.",
                textAlign: TextAlign.center,
              ),
              const Text(
                "Contacts",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              contactWidget(
                  icon: Icons.mail_outline,
                  text: "seifeldeenmostafa000@gmail.com",
                  link: "mailto:seifeldeenmostafa000@gmail.com"),
              sb(h: 10),
              contactWidget(
                  icon: Icons.phone,
                  text: "+201064598589",
                  link: "https://wa.me/+201064598589"),
              sb(h: 10),
              contactWidget(
                  icon: Icons.person_outline,
                  text: "Portfolio",
                  link: "https://seif-el-deen.github.io/portfolio2023/#/"),
              const Text(
                "More Applications",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                "more Applications are also developed by \nSeif El-Deen Mostafa",
                textAlign: TextAlign.center,
              ),
              contactWidget(
                  icon: Icons.shopping_bag_outlined,
                  text: "My Bags",
                  link:
                      "https://play.google.com/store/apps/details?id=com.my_bags.my_bag_application"),
              sb(h: 10),
              contactWidget(
                  text: "مهاراتى",
                  link:
                      "https://play.google.com/store/apps/details?id=com.skills.my_skills"),
              sb(h: 10),
              contactWidget(
                  text: "متقنون",
                  link:
                      "https://play.google.com/store/apps/details?id=com.language.motkenon"),
              contactWidget(
                  text: "المسلم المثقف",
                  link:
                      "https://play.google.com/store/apps/details?id=com.educatedmuslim.motkenon"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void launchEmail(String email) async {
    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: email,
    // );
    try {
      await launchUrlString(email);
    } catch (exe) {}
    // if (await canLaunchUrl(emailUri)) {
    // await launchUrl(emailUri);

    // } else {
    //   throw 'Could not launch $emailUri';
    // }
  }

// static double calculateDistanceKM(
//     double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
//   double earthRadiusKm = 6371.0;
//
//   final double startLatRad = _degreesToRadians(startLatitude);
//   final double startLonRad = _degreesToRadians(startLongitude);
//   final double endLatRad = _degreesToRadians(endLatitude);
//   final double endLonRad = _degreesToRadians(endLongitude);
//
//   final double dLat = endLatRad - startLatRad;
//   final double dLon = endLonRad - startLonRad;
//
//   final double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(startLatRad) * cos(endLatRad) * sin(dLon / 2) * sin(dLon / 2);
//   final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//
//   return earthRadiusKm * c;
// }
}
