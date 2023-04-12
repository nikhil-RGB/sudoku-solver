import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_solver/pages/InputPage.dart';

import 'package:sudoku_solver/solver/SudokuBoard.dart';

class SolverPage extends StatefulWidget {
  final SudokuBoard solution;
  final SudokuBoard ogBoard;
  const SolverPage({super.key, required this.solution, required this.ogBoard});

  @override
  State<SolverPage> createState() => _SolverPageState();
}

class _SolverPageState extends State<SolverPage> {
  @override
  Widget build(BuildContext context) {
    // Tester.main();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            constructAppBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.466,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.084,
                  right: MediaQuery.of(context).size.width * 0.084,
                ),
                child: constructBoard(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.041,
            ),
            submitButton(
                bg: const Color(0xFFFFB59C),
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Another Puzzle"),
          ],
        ),
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

  GridView constructRegion({
    required int region,
  }) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: List.generate(9, (index) {
        List<int> coords = translateCoords(region, index);
        return sudokuTile(i: coords[0], j: coords[1], k: coords[2]);
      }),
    );
  }

  Container sudokuTile({
    required int i,
    required int j,
    required int k,
  }) {
    int ogNum = widget.ogBoard.grid[i][j][k];
    int number = widget.solution.grid[i][j][k];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9CFFC9),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
          child: Text(
        number.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: (ogNum == 0) ? const Color(0xFFFFB59C) : Colors.black,
        ),
      )),
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
            onPressed: () {
              Navigator.pop(context);
            },
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
            width: MediaQuery.of(context).size.width * 0.25,
          ),
        ],
      ),
    );
  }
}
