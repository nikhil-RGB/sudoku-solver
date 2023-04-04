import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_solver/solver/BfsSolver.dart';
import 'package:sudoku_solver/solver/SudokuBoard.dart';

class Tester {
  static const List<List<List<int>>> test_board = [
    [
      [0, 0, 0, 6, 8, 0, 1, 9, 0],
      [2, 6, 0, 0, 7, 0, 0, 0, 4],
      [7, 0, 1, 0, 9, 0, 5, 0, 0]
    ],
    [
      [8, 2, 0, 0, 0, 4, 0, 5, 0],
      [1, 0, 0, 6, 0, 0, 0, 0, 0],
      [0, 4, 0, 9, 0, 0, 0, 0, 0]
    ],
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  ];

  static void main() async {
    SudokuBoard board = SudokuBoard.fromConfig(grid: test_board);
    printBoard(board.grid);
    Logger().w("Soluchan time: ");
    SudokuBoard soln = await compute<SudokuBoard, SudokuBoard>(
        BfsSolver.breadthFirstSolve, board);
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
