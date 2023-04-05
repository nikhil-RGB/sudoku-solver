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

    throw UnsolvableBoardException("No solutions found!");
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

    throw UnsolvableBoardException("No solutions found!");
  }
}
