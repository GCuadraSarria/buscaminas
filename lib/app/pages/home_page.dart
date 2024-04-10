import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minesweeper/app/app.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // open settings dialog
  void openSettings() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SettingsAlertbox();
        });
  }

  // open player lost dialog
  void playerLost() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PlayerLostAlertbox();
        });
  }

  // open player lost dialog
  void playerWon() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PlayerWonAlertbox();
        });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MineProvider>(context, listen: false).setSquareStatus();
    // Provider.of<MineProvider>(context, listen: false).setRandomBombs();
    // Provider.of<MineProvider>(context, listen: false).scanBombs();
  }

  @override
  Widget build(BuildContext context) {
    // provider
    final provider = Provider.of<MineProvider>(context);

    // screen size
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 202, 202, 202),
          elevation: 0,
          centerTitle: true,
          title: const Text('Minesweeper'),
          actions: [
            IconButton(
              onPressed: () => openSettings(),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: screenSize.height * 0.025),
            // top information (bombs, restart, time)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${provider.bombAmount}',
                      style: const TextStyle(
                          fontSize: 42.0, fontWeight: FontWeight.w200),
                    ),
                    const Text(
                      'B O M B',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => provider.restartGame(),
                  icon: const Icon(Icons.refresh),
                  iconSize: 42.0,
                ),
                Column(
                  children: [
                    Text(
                      '${provider.countdownValue}',
                      style: const TextStyle(
                          fontSize: 42.0, fontWeight: FontWeight.w200),
                    ),
                    const Text(
                      'T I M E',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.025),
            // grid
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.numberOfSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: provider.numberInEachRow,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.bombLocation.contains(index)) {
                          return BombBox(
                            revealed: provider.bombRevealed,
                            index: index,
                          );
                        } else {
                          return NumberBox(
                            bombsAround: provider.squareStatus[index][0],
                            index: index,
                            revealed: provider.squareStatus[index][1],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.025),
            // set flag button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  type: MaterialType.circle,
                  elevation: provider.setFlagger ? 0 : 5.0,
                  clipBehavior: Clip.hardEdge,
                  color: provider.setFlagger
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () => provider.setFlagClicker(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500.0),
                        boxShadow: provider.setFlagger
                            ? [
                                BoxShadow(
                                  blurStyle: BlurStyle.inner,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                )
                              ]
                            : [],
                      ),
                      height: screenSize.width * 0.20,
                      width: screenSize.width * 0.20,
                      child: Transform.scale(
                        scale: provider.setFlagger ? 0.70 : 0.75,
                        child: SvgPicture.asset(
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                          'lib/assets/flag.svg',
                          semanticsLabel: 'Flag',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.025),
          ],
        ),
      ),
    );
  }
}
