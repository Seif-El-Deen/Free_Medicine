import 'package:flutter/material.dart';
import 'package:free_medicine/screens/add_medicine_screen.dart';
import 'package:free_medicine/screens/search_medicine_screen.dart';
import 'package:free_medicine/shared/common_methods.dart';
import 'package:free_medicine/shared/sizes_manager.dart';
import 'package:free_medicine/shared/strings_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  void onPageNavigationTapped(int index) {
    pageIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        leading: IconButton(
          onPressed: () async {
            CommonMethods.aboutUsDialog(
                context: context);

          },
          icon: const Icon(Icons.info_outline),
        ),
        centerTitle: true,
      ),
      body: returnedBody(index: pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: AppSizes.s0,
        onTap: onPageNavigationTapped,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: AppStrings.search),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: AppStrings.add),
        ],
      ),
      // floatingActionButton: returnFloatingButton(index: pageIndex),
    );
  }

  Widget returnedBody({required int index}) {
    switch (index) {
      case 0:
        return const SearchMedicineScreen();
      case 1:
        return const AddMedicineScreen();
      default:
        return const Center(
          child: Text(AppStrings.pageNotFound),
        );
    }
  }

  // Widget returnFloatingButton({required int index}) {
  //   switch (index) {
  //     // case 0:
  //     //   return FloatingActionButton(
  //     //     onPressed: () {
  //     //
  //     //
  //     //       print("Search");
  //     //     },
  //     //     child: Icon(Icons.search),
  //     //   );
  //     case 1:
  //       return ;
  //     default:
  //       return const Center(
  //         child: Text("Page not found"),
  //       );
  //   }
  // }


}
