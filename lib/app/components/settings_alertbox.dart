import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class SettingsAlertbox extends StatelessWidget {
  const SettingsAlertbox({super.key});

  @override
  Widget build(BuildContext context) {
    // provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(themeProvider.isDarkMode ? 'Dark mode' : 'Light mode'),
          CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme())
        ],
      ),
    );
  }
}
