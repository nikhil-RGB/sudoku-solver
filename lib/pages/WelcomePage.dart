import 'package:flutter/material.dart';
import 'package:sudoku_solver/main.dart';
import 'package:sudoku_solver/pages/InputPage.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash-screen.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
            ),
            Center(
              child: submitButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => InputPage(
                                  key: inputPageKey,
                                ))));
                  },
                  text: "Proceed",
                  bg: const Color(0xFF9CFFC9)),
            ),
          ],
        ),
      ),
    );
  }
}
