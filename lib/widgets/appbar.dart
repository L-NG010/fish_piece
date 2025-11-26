import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon1;
  final IconData icon2;
  final IconData? icon3;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon1,
    required this.icon2,
    this.icon3,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(title, style: textTheme.titleLarge),
      centerTitle: false,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(icon1)),
        IconButton(onPressed: (){}, icon: Icon(icon2)),
        if (icon3 != null)
          IconButton(onPressed: (){}, icon: Icon(icon3)),
        const SizedBox(width: 12),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
