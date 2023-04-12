import 'package:sudoku_solver/solver/SudokuBoard.dart';
import 'package:sudoku_solver/util/exceptions.dart';

class Solver {
  static SudokuBoard breadthFirstSolve(SudokuBoard root) {
    List<SudokuBoard> solutionSet = [root];
    while (solutionSet.isNotEmpty) {
      SudokuBoard target =
          solutionSet[0]; //target sudoku board for all operations.
      if (target.isBoardFilled()) {
        return target;
      }
      solutionSet.removeAt(0);
      solutionSet.addAll(target.stepInto());
    }
    //return empty sudoku board when solving board is not possible.
    return SudokuBoard.empty();
  }

  static SudokuBoard depthFirstSolve(SudokuBoard root) {
    List<SudokuBoard> solutionSet = [root];
    while (solutionSet.isNotEmpty) {
      SudokuBoard target =
          solutionSet[0]; //target sudoku board for all operations.
      if (target.isBoardFilled()) {
        return target;
      }
      solutionSet.removeAt(0);
      solutionSet.insertAll(0, target.stepInto());
    }
    //return empty sudoku board when solving is not possible
    return SudokuBoard.empty();
  }
}
