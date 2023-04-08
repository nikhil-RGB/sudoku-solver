import 'package:flutter/material.dart';
import 'package:sudoku_solver/main.dart';
import 'package:sudoku_solver/solver/SudokuBoard.dart';
import 'package:sudoku_solver/util/Tester.dart';

class InputPage extends StatefulWidget {
  //An empty Sudoku Board
  // static SudokuBoard control = SudokuBoard.empty(); //empty sudoku board
  static SudokuBoard control = SudokuBoard.fromConfig(grid: Tester.test_board);

  InputPage({required super.key});
  static List<int> control_coords = [
    0,
    0,
    0,
  ]; //currently active control_coords in sudoku board.
  @override
  // ignore: no_logic_in_create_state
  State<InputPage> createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: constructBoard(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          numberPanel(),
        ],
      ),
    );
  }

  GridView constructBoard() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: List.generate(9, (index) {
        return constructRegion(region: index);
      }),
    );
  }

  GridView constructRegion({required int region}) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: List.generate(9, (index) {
        List<int> coords = translateCoords(region, index);
        return SudokuCell(i: coords[0], j: coords[1], k: coords[2]);
      }),
    );
  }

  SizedBox numberPanel() {
    List<Widget> buttons = List.generate(9, (index) {
      return InkWell(
        onTap: () {},
        child: Ink(
            width: 90,
            height: 140,
            decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: Center(
                child: Text(
              (++index).toString(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ))),
      );
    });

    Widget c = InkWell(
      child: Ink(
          width: 90,
          height: 140,
          decoration: const BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
          ),
          child: const Center(child: Icon(Icons.undo_outlined))),
    );
    buttons.add(c);
    // buttons.insert(
    //     0,
    //     ElevatedButton.icon(
    //       onPressed: () {},
    //       icon: const Icon(Icons.undo_outlined),
    //       label: const Text("Undo"),
    //     ));
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.165,
      width: MediaQuery.of(context).size.width * 0.45,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: buttons,
      ),
    );
  }
}

// ignore: must_be_immutable
class SudokuCell extends StatefulWidget {
  //3-D co-ordinates for the sudoku cell's position in the grid.
  int i;
  int j;
  int k;
  SudokuCell({super.key, required this.i, required this.j, required this.k});

  @override
  State<SudokuCell> createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  @override
  Widget build(BuildContext context) {
    int number = InputPage.control.grid[widget.i][widget.j][widget.k];
    return ElevatedButton(
      onPressed: () {
        inputPageKey.currentState!.setState(() {
          InputPage.control_coords = [widget.i, widget.j, widget.k];
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ((InputPage.control_coords[0] == widget.i) &&
                (InputPage.control_coords[1] == widget.j) &&
                (InputPage.control_coords[2] == widget.k))
            ? Colors.cyan
            : null,
      ),
      child: Text((number != 0) ? number.toString() : ""),
    );
  }
}

//Translates coordinates from region, index to (i,j,k)
List<int> translateCoords(int region, int index) {
  int i;
  int j;
  int k = index;
  if (region <= 2) {
    i = 0;
    j = region;
  } else if (region <= 5) {
    i = 1;
    j = region - 3;
  } else {
    i = 2;
    j = region - 6;
  }

  return [i, j, k];
}
