import 'package:flutter/material.dart';
import 'package:sudoku_solver/pages/InputPage.dart';

import 'package:sudoku_solver/solver/SudokuBoard.dart';

class SolverPage extends StatefulWidget {
  final SudokuBoard solution;
  const SolverPage({super.key, required this.solution});

  @override
  State<SolverPage> createState() => _SolverPageState();
}

class _SolverPageState extends State<SolverPage> {
  @override
  Widget build(BuildContext context) {
    // Tester.main();
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
    int number = widget.solution.grid[i][j][k];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue,
      ),
      child: Center(child: Text(number.toString())),
    );
  }
}
