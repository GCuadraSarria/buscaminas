import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class NumberBox extends StatelessWidget {
  final int index;
  final int bombsAround;
  final bool revealed;

  const NumberBox({
    super.key,
    required this.index,
    required this.revealed,
    required this.bombsAround,
  });

  @override
  Widget build(BuildContext context) {
    // open player won dialog
    void playerWon() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PlayerWonAlertbox();
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
                    provider.revealBox(index);
                    if (provider.playerWon) {
                      playerWon();
                    }
                  },
        child: Container(
          color: revealed || provider.squareStatus[index][2] == true
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.inversePrimary,
          child: revealed
              ? bombsAround != 0
                  ? Center(
                      child: Text(
                        '$bombsAround',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: getBombColor(bombsAround),
                        ),
                      ),
                    )
                  : const Text('')
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

  Color getBombColor(int bombsAround) {
    switch (bombsAround) {
      case 1:
        return const Color.fromARGB(255, 0, 108, 197);
      case 2:
        return const Color.fromARGB(255, 54, 124, 57);
      case 3:
        return const Color.fromARGB(255, 240, 60, 47);
      case 4:
        return const Color.fromARGB(255, 0, 12, 177);
      case 5:
        return const Color.fromARGB(255, 102, 23, 23);
      case 6:
        return const Color.fromARGB(255, 11, 157, 177);
      case 7:
        return const Color.fromARGB(255, 9, 14, 27);
      case 8:
        return const Color.fromARGB(255, 129, 129, 129);
      default:
        return Colors.transparent;
    }
  }
}
