import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTapped,
    required this.items,
    required this.itemTitle,
  }) : super(key: key);

  final int selectedIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final Function(int) onTapped;
  final List<IconData> items;
  final List<String> itemTitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      height: 60.0,
      // margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(40.0),
        //   topRight: Radius.circular(40.0),
        // ),
        // borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-2, -1),
            color: Get.theme.colorScheme.outlineVariant,
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
          BoxShadow(
            offset: const Offset(2, 0),
            color: Get.theme.colorScheme.outlineVariant,
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < items.length; i++)
            Column(
              children: [
                IconButton(
                  icon: Icon(items[i]),
                  iconSize: 22.0,
                  color: selectedIndex == i ? selectedColor : unselectedColor,
                  onPressed: () {
                    onTapped(i);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
