import 'package:admin_have_a_meal/features/qr/widgets/menu_card.dart';
import 'package:admin_have_a_meal/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuCourse extends StatelessWidget {
  const MenuCourse({
    super.key,
    required this.courseName,
    required this.courseColor,
    required this.menuList,
    required this.timeName,
  });

  final String courseName;
  final Color courseColor;
  final List<MenuModel> menuList;
  final String timeName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          courseName,
          style: TextStyle(
            fontSize: 24,
            color: courseColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const Gap(4),
        for (int i = 0; i < menuList.length; i++)
          MenuCard(
            menuData: menuList[i],
            courseName: courseName,
            timeName: timeName,
          ),
      ],
    );
  }
}
