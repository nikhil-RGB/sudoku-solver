import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // ignore: non_constant_identifier_names
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
          constructAppBar(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.466,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.084,
                  right: MediaQuery.of(context).size.width * 0.084),
              child: constructBoard(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.035,
          ),
          numberPanel(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          submitButton(
              onPressed: () async {
                SudokuBoard soln = await compute<SudokuBoard, SudokuBoard>(
                    Solver.depthFirstSolve, control);
                if (!soln.isBoardFilled()) {
                  // ignore: use_build_context_synchronously
                  openInfoDialog(
                      info_title: "Yikes!",
                      details:
                          "The solver was unable to wrap it's head around this one- It seems this board does not have any valid solutions!",
                      context: context);
                  return;
                }
                //Navigate to the solution page
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SolverPage(solution: soln))));
              },
              text: "Solve"),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
        ],
      ),
      // floatingActionButton: (!solving)
      //     ? FloatingActionButton(
      // onPressed: () async {
      //   setState(() {
      //     solving = true;
      //   });
      //   SudokuBoard soln = await compute<SudokuBoard, SudokuBoard>(
      //       Solver.depthFirstSolve, control);
      //   setState(() {
      //     solving = false;
      //   });
      //           //Navigate to the solution page
      //           // ignore: use_build_context_synchronously
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: ((context) => SolverPage(solution: soln))));
      //         },
      //         child: const Icon(Icons.fast_forward_outlined),
      //       )
      //     : const CircularProgressIndicator(),
    );
  }

  //This function creates the entire sudoku board
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

//this function creates and returns a sub-region for the input sudoku board
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

  //this function creates the number input panel for the sudoku board
  Widget numberPanel() {
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
            decoration: BoxDecoration(
              color: (enabled) ? const Color(0xFFFFB59C) : Colors.grey,
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
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
          decoration: const BoxDecoration(
            color: Color(0xFFFFB59C),
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
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
      // decoration: BoxDecoration(
      //   color: Colors.white,
      // ),
      height: MediaQuery.of(context).size.height * 0.23,
      width: MediaQuery.of(context).size.width * 0.8,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.03,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
        children: buttons,
      ),
    );
  }

  Widget constructAppBar() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04,
          bottom: MediaQuery.of(context).size.height * 0.04),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF9CFFC9),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "sudoku",
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 3,
                  color: const Color(0xFF9CFFC9),
                ),
              ),
              TextSpan(
                text: ".",
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 3,
                  color: const Color(0xFFFFB59C),
                ),
              ),
              TextSpan(
                text: "solver",
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 3,
                  color: const Color(0xFF9CFFC9),
                ),
              ),
            ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                control.formatBoard();
              });
            },
            icon: const Icon(Icons.restart_alt_outlined),
            color: const Color(0xFFFFB59C),
          ),
        ],
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
        foregroundColor: Colors.black,
        backgroundColor: ((InputPage.control_coords[0] == widget.i) &&
                (InputPage.control_coords[1] == widget.j) &&
                (InputPage.control_coords[2] == widget.k))
            ? const Color(0xFFFFB59C)
            : const Color(0xFF9CFFC9),
      ),
      child: Center(
        child: Text(
          (number != 0) ? number.toString() : "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
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

// Create an elevated button for submitting the board or trying again.
ElevatedButton submitButton({
  required VoidCallback onPressed,
  required String text,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9CFFC9),
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              // border radius
              borderRadius: BorderRadius.circular(50))),
      onPressed: onPressed,
      child: const Padding(
        padding: EdgeInsets.only(
          top: 15.0,
          bottom: 15.0,
          left: 45,
          right: 45,
        ),
        child: Text(
          "Solve",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ));
}

Future openInfoDialog(
        {String info_title = "Information",
        required String details,
        required BuildContext context}) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          title: Text(
            info_title,
            style: const TextStyle(
              color: Color(0xFF9CFFC9),
            ),
          ),
          content: Text(
            details,
            style: const TextStyle(
              color: Color(0xFF9CFFC9),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB59C)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
          backgroundColor: Colors.grey.shade900,
        );
      },
    );
