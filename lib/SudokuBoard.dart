import 'package:logger/logger.dart';
import 'package:sudoku_solver/util/IllegalInitializationException.dart';

class SudokuBoard {
  List<List<List<int>>> grid;
  List<int> current_pos = [0, 0, 0];
  //initialize board with pre-existing config
  SudokuBoard.fromConfig({required this.grid}) {
    if ((grid.length != 3) ||
        (grid[0].length != 3) ||
        (grid[0][0].length != 9)) {
      throw IllegalInitializationException(
          "A valid sudoku board is always 3*3*9!");
    }
  }
  //Generate a standard empty grid
  SudokuBoard.empty() : grid = generateEmptyGrid();
  static List<List<List<int>>> generateEmptyGrid() {
    List<List<List<int>>> l = List.generate(
        3,
        (index) =>
            List.generate(3, ((index) => List.generate(9, (index) => 0))));
    return l;
  }

  //returns a solution set for a grid box considering absolutely no constraints.
  static List<int> solSet() {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9];
  }

  //Extracts a list of numbers which are present in that particular column for indices(i,j,k)
  List<int> extractColumnAt(int i, int j, int k) {
    int k1 = 0;
    if ((k == 0) || (k == 3) || (k == 6)) {
      k1 = 0;
    } else if ((k == 1) || (k == 4) || (k == 7)) {
      k1 = 1;
    } else {
      k1 = 2;
    }

    List<int> arri = List.empty(growable: true);
    for (int i1 = 0; i1 < 3; ++i1) {
      for (int k2 = k1; k2 <= (k1 + 6); k2 += 3) {
        arri.add(grid[i1][j][k2]);
      }
    }
    return arri;
  }

  //Extracts a row from the subregion and index specified by (i,j,k)
  List<int> extractRowAt(int i, int j, int k) {
    int k1 = 0;
    if ((k == 0) || (k == 1) || (k == 2)) {
      k1 = 0;
    } else if ((k == 3) || (k == 4) || (k == 5)) {
      k1 = 3;
    } else {
      k1 = 6;
    }
    List<int> arrs = List.empty(growable: true);
    for (int j1 = 0; j1 < 3; ++j1) {
      for (int k2 = k1; k2 <= (k1 + 2); ++k2) {
        arrs.add(grid[i][j1][k2]);
      }
    }
    return arrs;
  }

  //formats the board to an "empty" state,by replacing all the number positions with 0.
  void formatBoard() {
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        for (int k = 0; k < 9; ++k) {
          grid[i][j][k] = 0;
        }
      }
    }
  }

  //gets a list of all possible solutions at position (i,j,k)
  List<int> possibleSolutionsAt(int i, int j, int k) {
    List<int> all = SudokuBoard.solSet();
    List<int> available = List.empty(growable: true);
    //In this loop we check for every point whether it is a part of the solution set for that particular
    //position or not.
    for (int soln in all) {
      if (isValidSolutionFor(solution: soln, i: i, j: j, k: k)) {
        available.add(soln);
      }
    }
    return available;
  }

  //checks if a particular number is valid for a particular position in the sudoku grid.
  bool isValidSolutionFor({
    required int solution,
    required int i,
    required int j,
    required int k,
  }) {
    if (solution <= 0 || solution > 9) {
      return false;
    }
    List<int> row = extractRowAt(i, j, k);
    List<int> col = extractColumnAt(i, j, k);
    List<int> region = grid[i][j];

    if (row.contains(solution) ||
        col.contains(solution) ||
        region.contains(solution)) {
      return false;
    }
    return true;
  }

  //Aquires the position of the first grid position which is unsolved, left to right, region by region, top to bottom
  List<int> calculateEmptyCoords() {
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        for (int k = 0; k < 9; ++k) {
          if (grid[i][j][k] == 0) {
            return [i, j, k];
          }
        }
      }
    }
    return [];
  }

  //checks if the board is filled completely yet.
  bool isBoardFilled() {
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        for (int k = 0; k < 9; ++k) {
          int num = grid[i][j][k];
          if (num == 0) {
            return false;
          }
        }
      }
    }
    return true;
  }

  //Checks if the board has been solved and filled correctly.
  bool isBoardSolved() {
    if (!isBoardFilled()) {
      return false;
    }
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        for (int k = 0; k < 9; ++k) {
          int num = grid[i][j][k];
          if (!isValidSolutionFor(solution: num, i: i, j: j, k: k)) {
            return false;
          }
        }
      }
    }
    return true;
  }
}
