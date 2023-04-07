import 'package:flutter/material.dart';
import 'package:sudoku_solver/util/Tester.dart';

class SolverPage extends StatefulWidget {
  const SolverPage({super.key});

  @override
  State<SolverPage> createState() => _SolverPageState();
}

class _SolverPageState extends State<SolverPage> {
  @override
  Widget build(BuildContext context) {
    Tester.main();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sudoku Solver"),
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: const Text("No implementation!"),
      ),
    );
  }
}
