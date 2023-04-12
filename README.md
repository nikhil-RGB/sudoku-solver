# Sudoku Solver

This project aims at building an android app which can efficiently solve any sudoku board using algorithmic techniques like [depth-first search](https://www.geeksforgeeks.org/depth-first-search-or-dfs-for-a-graph/) and [backtracking](https://en.wikipedia.org/wiki/Backtracking#:~:text=Backtracking%20is%20a%20class%20of,be%20completed%20to%20a%20valid).

### Algorithm

The Sudoku Solver app uses an optimized depth-first search and backtracking algorithm to solve a given Sudoku puzzle. The algorithm works by maintaining a stack of boards representing the current state of the puzzle. The first board in the stack is the initial state of the puzzle. Every board is a node in the generated solution tree(implemented using a stack).

The algorithm starts by selecting the first empty cell in the top board of the stack. It then tries all possible values that can be placed in that cell. If value(s) are found that do not violate any of the Sudoku rules, new boards are created with those value(s) in the respective selected cell(s), and the new board(s) are added to the top of the stack. The algorithm then proceeds to the next empty cell and repeats the process. Everytime a board is analyzed, it will be removed from the stack, irrespective of whether or not it generated any child boards.
The process is then repeated on the current first element of the stack.

If the algorithm reaches a point where all elements have been removed from the stack and no filled/solved configuration is achieved, an error message is displayed.

Basic Dart implementation of approach:

```dart
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
```


### Design

The app has three screens: a welcome screen, an input screen, and a solution screen.
<br><br>


<div align="center">

<img width="230" alt="splash" align="left" src="https://user-images.githubusercontent.com/68727041/231554673-4f86fcdc-69df-4dc4-a0fa-45ca40552394.jpeg">

<img width="230" alt="system" align="center" src="https://user-images.githubusercontent.com/68727041/231554776-4a9e8027-c6de-4e45-98f6-aa4e8d0ba0a2.jpeg">

<img width="230" alt="automate" align="right" src="https://user-images.githubusercontent.com/68727041/231554894-43dc39f2-b2c9-4077-8fd0-ce35c047ab06.jpeg">
</div>

<br><br>

#### Welcome Screen
The welcome screen is the first screen that the user sees when they open the app. It contains a welcome message and a button that takes the user to the input screen.

#### Input Screen
The input screen allows the user to enter the initial values of a Sudoku puzzle. The user can either enter the values manually or import a puzzle from a text file. Once the user has entered the values, they can click the "Solve" button to find the solution to the puzzle.

#### Solution Screen
The solution screen displays the solution to the Sudoku puzzle. If the puzzle is unsolvable, the app will display an error message.

