import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver/main.dart';
import 'package:sudoku_solver/pages/SolverPage.dart';
import 'package:sudoku_solver/solver/Solver.dart';
import 'package:sudoku_solver/solver/SudokuBoard.dart';
import 'package:sudoku_solver/util/Tester.dart';

SudokuBoard control = SudokuBoard.fromConfig(grid: Tester.test_board);

// ignore: must_be_immutable
class InputPage extends StatefulWidget {
  //An empty Sudoku Board
  // static SudokuBoard control = SudokuBoard.empty(); //empty sudoku board

  const InputPage({required super.key});
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
  bool solving = false;
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
      floatingActionButton: (!solving)
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  solving = true;
                });
                SudokuBoard soln = await compute<SudokuBoard, SudokuBoard>(
                    Solver.depthFirstSolve, control);
                setState(() {
                  solving = false;
                });
                //Navigate to the solution page
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SolverPage(solution: soln))));
              },
              child: const Icon(Icons.fast_forward_outlined),
            )
          : const CircularProgressIndicator(),
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

  GridView constructRegion({
    required int region,
  }) {
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
    //coords for currently selected grid box
    int i = InputPage.control_coords[0];
    int j = InputPage.control_coords[1];
    int k = InputPage.control_coords[2];
    List<int> activeNums = control.possibleSolutionsAt(
      i,
      j,
      k,
    );
    List<Widget> buttons = List.generate(9, (index) {
      int number = ++index; //current number for panel
      //whether current button on panel should be enabled or not
      bool enabled = activeNums.contains(number);
      return InkWell(
        enableFeedback: enabled,
        onTap: () {
          if (!enabled) {
            return;
          }

          //set number in main sudoku board here.
          setState(() {
            control.grid[i][j][k] = number;
          });
        },
        child: Ink(
            width: 90,
            height: 140,
            decoration: BoxDecoration(
              color: (enabled) ? Colors.cyan : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: Center(
                child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ))),
      );
    });

    Widget c = InkWell(
      onTap: () {
        setState(() {
          control.grid[i][j][k] = 0;
        });
      },
      child: Ink(
          width: 90,
          height: 140,
          decoration: const BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
          ),
          child: const Center(child: Icon(Icons.delete_outlined))),
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
    int number = control.grid[widget.i][widget.j][widget.k];
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
