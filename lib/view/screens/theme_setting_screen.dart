import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../style/theme_provider.dart';

class ThemeSettingScreen extends StatelessWidget {
  ThemeSettingScreen({super.key});

  final List<Color> _colors = [
    Colors.green,
    Colors.lightGreen,
    Colors.teal,
    Colors.blue,
    Colors.lightBlue,
    Colors.indigo,
    Colors.red,
    Colors.orange,
    Colors.pink,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentColor = themeProvider.primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(S.of(context)!.selectColor),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: _colors.map((color) {
          // ignore: deprecated_member_use
          final isSelected = color.value == currentColor.value;
          return GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().changeColor(color);
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                  color: Colors.black,
                  width: 3,
                )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
