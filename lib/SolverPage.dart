import 'package:flutter/material.dart';

class SolverPage extends StatefulWidget {
  @override
  State<SolverPage> createState() => _SolverPageState();
}

class _SolverPageState extends State<SolverPage> {
  @override
  Widget build(BuildContext context) {
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
