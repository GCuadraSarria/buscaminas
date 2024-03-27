import 'package:flutter/material.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class PlayerLostAlertbox extends StatelessWidget {
  const PlayerLostAlertbox({super.key});

  @override
  Widget build(BuildContext context) {
    // provider
    final provider = Provider.of<MineProvider>(context);
    
    return AlertDialog(
      title: const Center(
        child: Text('Y O U  L O S T'),
      ),
      content: ElevatedButton(
        onPressed: () {
          provider.restartGame();
          Navigator.pop(context);
        },
        child: const Text('Restart game'),
      ),
    );
  }
}
