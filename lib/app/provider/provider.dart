import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum GameDifficulty { easy, medium, hard }

class MineProvider extends ChangeNotifier {
  int _numberInEachRow = 7;
  int get numberInEachRow => _numberInEachRow;
  int _numberOfSquares = 7 * 7;
  int get numberOfSquares => _numberOfSquares;

  // game difficulty
  GameDifficulty _gameDifficulty = GameDifficulty.medium;
  GameDifficulty get gameDifficulty => _gameDifficulty;

  // [number of bombs around, revealed = true / false, flag = true / false]
  final List _squareStatus = [];
  List get squareStatus => _squareStatus;

  // Define a Timer object
  Timer? _timer;
  // Define a variable to store the current countdown value
  int _countdownValue = 0;
  int get countdownValue => _countdownValue;

  // index where the bombs are in the game
  List<int> _bombLocation = [];
  List<int> get bombLocation => _bombLocation;

  // set flag button
  bool _setFlagger = false;
  bool get setFlagger => _setFlagger;

  // amount of bombs
  int _bombAmount = 7;
  int get bombAmount => _bombAmount;

  // did game finish
  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  // did player won
  bool _playerWon = false;
  bool get playerWon => _playerWon;

  // bombs tapped
  bool _bombRevealed = false;
  bool get bombRevealed => _bombRevealed;

  // start the game
  bool _startPlaying = false;
  bool get startPlaying => _startPlaying;

  // player set difficulty
  void setDifficulty(GameDifficulty value) {
    _gameDifficulty = value;
    switch (value) {
      case GameDifficulty.easy:
        _bombAmount = 5;
        gridSettings(5);
        notifyListeners();
        break;
      case GameDifficulty.medium:
        _bombAmount = 7;
        gridSettings(7);
        notifyListeners();
        break;
      default:
        _bombAmount = 13;
        gridSettings(9);
        notifyListeners();
    }
    notifyListeners();
  }

  // start the countdown timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue++;
      notifyListeners();
    });
  }

  // we tap our first square
  void startGame() {
    _startPlaying = true;
    notifyListeners();
  }

  // player tap a bomb
  void setBombRevealed() {
    _bombRevealed = true;
    _timer?.cancel();
    notifyListeners();
  }

  // random bomb geneartor (we pass first index to avoid it to have a bomb)
  void setRandomBombs(int index) {
    Random random = Random();
    Set<int> uniqueNumbers = {}; // Set to store unique random numbers

    
    while (uniqueNumbers.length < _bombAmount) {
      int randomNumber = random.nextInt(_numberOfSquares);
      if (randomNumber != index) {
        uniqueNumbers.add(randomNumber);
      }
    }

    _bombLocation = uniqueNumbers.toList(); // Convert set to list
    print('Index -> $index');
    print(_bombLocation.map((e) => '$e'));
  }

  // restart the game
  void restartGame() {
    _isGameOver = false;
    _playerWon = false;
    _setFlagger = false;
    _bombRevealed = false;
    _startPlaying = false;
    _bombLocation = [];
    _timer?.cancel();
    _countdownValue = 0;
    _squareStatus.clear();
    setSquareStatus();
    notifyListeners();
  }

  // check winner
  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < _numberOfSquares; i++) {
      if (_squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    // if the number is same as the bombs, the player wins
    if (unrevealedBoxes == _bombAmount) {
      _playerWon = true;
      _timer?.cancel();
    }
    notifyListeners();
  }

  // set the grid values
  void gridSettings(int value) {
    _numberInEachRow = value;
    _numberOfSquares = value * value;
    notifyListeners();
  }

  // set all squares as 0 bombs around and not revealed
  void setSquareStatus() {
    for (int i = 0; i < _numberOfSquares; i++) {
      _squareStatus.add([0, false, false]);
    }
  }

  // player lose
  void gameOver() {
    _isGameOver = true;
    notifyListeners();
  }

  // set flag
  void setFlag(int index) {
    if (_squareStatus[index][2] == true) {
      _squareStatus[index][2] = false;
    } else {
      _squareStatus[index][2] = true;
    }
    notifyListeners();
  }

  // flag clicker
  void setFlagClicker() {
    _setFlagger = !_setFlagger;
    notifyListeners();
  }

  // reveal box
  void revealBox(int index) {
    if (_squareStatus[index][0] != 0) {
      _squareStatus[index][1] = true;
    }

    // if current box is 0
    else if (_squareStatus[index][0] == 0) {
      // reveal current box and the 8 surrounding boxes, unless you're on a wall
      _squareStatus[index][1] = true;
      // reveal left box (unless we are currently on the left wall)
      if (index % _numberInEachRow != 0) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index - 1][0] == 0 &&
            _squareStatus[index - 1][1] == false) {
          revealBox(index - 1);
        }
        // reveal left box
        _squareStatus[index - 1][1] = true;
      }

      // reveal top-left box (unless we are currently on the top row or left wall)
      if (index % _numberInEachRow != 0 && index >= _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index - 1 - _numberInEachRow][0] == 0 &&
            _squareStatus[index - 1 - _numberInEachRow][1] == false) {
          revealBox(index - 1 - _numberInEachRow);
        }
        // reveal top-left box
        _squareStatus[index - 1 - _numberInEachRow][1] = true;
      }

      // reveal top box (unless we are currently on the top row)
      if (index >= _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index - _numberInEachRow][0] == 0 &&
            _squareStatus[index - _numberInEachRow][1] == false) {
          revealBox(index - _numberInEachRow);
        }
        // reveal top box
        _squareStatus[index - _numberInEachRow][1] = true;
      }

      // reveal top-right box (unless we are currently on the top row or right wall)
      if (index % _numberInEachRow != _numberInEachRow - 1 &&
          index >= _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index + 1 - _numberInEachRow][0] == 0 &&
            _squareStatus[index + 1 - _numberInEachRow][1] == false) {
          revealBox(index + 1 - _numberInEachRow);
        }
        // reveal top-right box
        _squareStatus[index + 1 - _numberInEachRow][1] = true;
      }

      // reveal right box (unless we are currently on the right wall)
      if (index % _numberInEachRow != _numberInEachRow - 1) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index + 1][0] == 0 &&
            _squareStatus[index + 1][1] == false) {
          revealBox(index + 1);
        }
        // reveal right box
        _squareStatus[index + 1][1] = true;
      }

      // reveal bottom-right box (unless we are currently on the bottom row or right wall)
      if (index % _numberInEachRow != _numberInEachRow - 1 &&
          index < _numberOfSquares - _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index + 1 + _numberInEachRow][0] == 0 &&
            _squareStatus[index + 1 + _numberInEachRow][1] == false) {
          revealBox(index + 1 + _numberInEachRow);
        }
        // reveal bottom-right box
        _squareStatus[index + 1 + _numberInEachRow][1] = true;
      }

      // reveal bottom box (unless we are currently on the bottom row)
      if (index < _numberOfSquares - _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index + _numberInEachRow][0] == 0 &&
            _squareStatus[index + _numberInEachRow][1] == false) {
          revealBox(index + _numberInEachRow);
        }
        // reveal bottom box
        _squareStatus[index + _numberInEachRow][1] = true;
      }

      // reveal bottom-left box (unless we are currently on the bottom row or left wall)
      if (index % _numberInEachRow != 0 &&
          index < _numberOfSquares - _numberInEachRow) {
        // if next box isn't revealed yet and its a 0, then recurse
        if (_squareStatus[index - 1 + _numberInEachRow][0] == 0 &&
            _squareStatus[index - 1 + _numberInEachRow][1] == false) {
          revealBox(index - 1 + _numberInEachRow);
        }
        // reveal bottom-left box
        _squareStatus[index - 1 + _numberInEachRow][1] = true;
      }
    }
    // check winner everytime you reveal a cell
    checkWinner();
    notifyListeners();
  }

  // scan bombs in all the grid
  void scanBombs() {
    for (int i = 0; i < _numberOfSquares; i++) {
      // there are no bombs around initially
      int numberOfBombsAround = 0;

      /*
      check each square to see if it has bombs surrounding it,
      there are 8 surrounding boxes to check
      */

      // check square to the left, unless it is in the first column
      if (_bombLocation.contains(i - 1) && i % _numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      // check square to the right, unless it is in the last column
      if (_bombLocation.contains(i + 1) &&
          i % _numberInEachRow != _numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      // check square to the top, unless it is in the first row
      if (_bombLocation.contains(i - _numberInEachRow) &&
          i >= _numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the bottom, unless it is in the last row
      if (_bombLocation.contains(i + _numberInEachRow) &&
          i < _numberOfSquares - _numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the top-left, unless it is in the first column or first row
      if (_bombLocation.contains(i - 1 - _numberInEachRow) &&
          i % _numberInEachRow != 0 &&
          i >= _numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the bottom-left, unless it is in the first column or last row
      if (_bombLocation.contains(i - 1 + _numberInEachRow) &&
          i % _numberInEachRow != 0 &&
          i < _numberOfSquares - _numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the top-right, unless it is in the last column or first row
      if (_bombLocation.contains(i + 1 - _numberInEachRow) &&
          i % _numberInEachRow != _numberInEachRow - 1 &&
          i >= _numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the bottom-right, unless it is in the last column or last row
      if (_bombLocation.contains(i + 1 + _numberInEachRow) &&
          i % _numberInEachRow != _numberInEachRow - 1 &&
          i < _numberOfSquares - _numberInEachRow) {
        numberOfBombsAround++;
      }

      // add total number of bombs around to square status
      _squareStatus[i][0] = numberOfBombsAround;
    }
  }
}
