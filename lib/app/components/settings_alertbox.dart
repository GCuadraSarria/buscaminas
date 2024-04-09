import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class SettingsAlertbox extends StatelessWidget {
  const SettingsAlertbox({super.key});

  @override
  Widget build(BuildContext context) {
    // theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // game provider
    final gameProvider = Provider.of<MineProvider>(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(themeProvider.isDarkMode ? 'Dark mode' : 'Light mode'),
              CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme())
            ],
          ),
          const Text('Difficulty'),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    gameProvider.setDifficulty(GameDifficulty.easy);
                    gameProvider.restartGame();
                    Navigator.pop(context);
                  },
                  child: const Text('Easy'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    gameProvider.setDifficulty(GameDifficulty.medium);
                    gameProvider.restartGame();
                    Navigator.pop(context);
                  },
                  child: const Text('Medium'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    gameProvider.setDifficulty(GameDifficulty.hard);
                    gameProvider.restartGame();
                    Navigator.pop(context);
                  },
                  child: const Text('Hard'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
