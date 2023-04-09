import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_solver/solver/Solver.dart';
import 'package:sudoku_solver/solver/SudokuBoard.dart';

class Tester {
  static List<List<List<int>>> test_board = [
    [
      [5, 3, 0, 6, 0, 0, 0, 9, 8],
      [0, 7, 0, 1, 9, 5, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 6, 0]
    ],
    [
      [8, 0, 0, 4, 0, 0, 7, 0, 0],
      [0, 6, 0, 8, 0, 3, 0, 2, 0],
      [0, 0, 3, 0, 0, 1, 0, 0, 6]
    ],
    [
      [0, 6, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 4, 1, 9, 0, 8, 0],
      [2, 8, 0, 0, 0, 5, 0, 7, 9]
    ],
  ];

  static List<List<List<int>>> test_board1 = [
    [
      [4, 0, 6, 0, 0, 8, 0, 0, 0],
      [0, 0, 7, 0, 9, 0, 2, 8, 0],
      [0, 0, 2, 0, 4, 0, 1, 9, 0]
    ],
    [
      [5, 3, 0, 0, 0, 0, 0, 0, 0],
      [6, 0, 2, 0, 0, 0, 0, 0, 0],
      [9, 0, 0, 6, 0, 3, 0, 0, 0]
    ],
    [
      [1, 0, 0, 0, 0, 2, 0, 7, 4],
      [0, 0, 0, 0, 1, 0, 9, 0, 0],
      [0, 2, 0, 0, 0, 0, 0, 0, 0]
    ],
  ];

  static List<List<List<int>>> test_board2 = [
    [
      [0, 0, 7, 2, 0, 0, 0, 0, 0],
      [4, 9, 1, 0, 6, 0, 0, 0, 7],
      [6, 0, 5, 3, 0, 9, 0, 1, 0]
    ],
    [
      [0, 5, 8, 0, 0, 3, 0, 0, 6],
      [6, 0, 0, 0, 0, 0, 2, 0, 0],
      [0, 0, 4, 0, 9, 0, 1, 8, 7]
    ],
    [
      [9, 0, 4, 6, 7, 0, 8, 1, 0],
      [0, 7, 0, 8, 3, 0, 0, 4, 5],
      [0, 0, 2, 0, 0, 0, 0, 0, 0]
    ],
  ];

  static void main() async {
    SudokuBoard board = SudokuBoard.fromConfig(grid: test_board);
    printBoard(board.grid);
    Logger().w("Soluchan time: ");
    SudokuBoard soln =
        await compute<SudokuBoard, SudokuBoard>(Solver.depthFirstSolve, board);
    Logger().i("Reached here");
    printBoard(soln.grid);
  }

  static printBoard(List<List<List<int>>> board) {
    String s = "";
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        s += "\n";
        for (int k = 0; k < 9; ++k) {
          if ((k) % 3 == 0) {
            s += "\n";
          }
          s += ("${board[i][j][k]} ");
        }
        s += "\n";
      }
    }
    Logger().i(s);
  }
}
