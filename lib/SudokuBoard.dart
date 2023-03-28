class SudokuBoard {
  List<List<List<int>>> grid;
  //initialize board with pre-existing config
  SudokuBoard.fromConfig({required this.grid});
  //Generate a standard empty grid
  SudokuBoard.empty() : grid = generateEmptyGrid();
  static List<List<List<int>>> generateEmptyGrid() {
    List<List<List<int>>> l = List.generate(
        3,
        (index) =>
            List.generate(3, ((index) => List.generate(9, (index) => 0))));
    return l;
  }
}
