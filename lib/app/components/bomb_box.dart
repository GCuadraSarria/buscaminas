import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class BombBox extends StatelessWidget {
  final bool revealed;
  final int index;

  const BombBox({
    super.key,
    required this.revealed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // open player lost dialog
    void playerLost() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PlayerLostAlertbox();
          });
    }

    return Consumer<MineProvider>(builder: (context, provider, _) {
      return GestureDetector(
        onTap: provider.isGameOver
            ? null
            : provider.setFlagger
                ? () {
                    provider.setFlag(index);
                  }
                : () {
                    provider.setBombRevealed();
                    provider.gameOver();
                    playerLost();
                  },
        child: Container(
          color: provider.squareStatus[index][2] == true
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.inversePrimary,
          child: revealed
              ? SvgPicture.asset(
                  'lib/assets/bomb.svg',
                  semanticsLabel: 'Bomb',
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  fit: BoxFit.fill,
                )
              : provider.squareStatus[index][2]
                  ? SvgPicture.asset(
                      'lib/assets/flag.svg',
                      semanticsLabel: 'Flag',
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      fit: BoxFit.fill,
                    )
                  : const Text(''),
        ),
      );
    });
  }
}
