import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      theme: ThemeData(primaryColor: Colors.amber),
      home: const SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<StatefulWidget> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";

  double equationFontSize = 25.0;
  double resultFontSize = 35.0;

  /// When users click the buttons, does processes and gives the result.
  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        resultFontSize = 35.0;
      } else if (buttonText == "X") {
        equationFontSize = 35.0;
        resultFontSize = 25.0;

        equation = equation.substring(0, equation.length - 1);
        if (equation == "") equation = "0";
      } else if (buttonText == "=") {
        equationFontSize = 25.0;
        resultFontSize = 35.0;

        expression = equation;
        expression = expression.replaceAll("x", "*");
        expression = expression.replaceAll("/", "/");
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();

          double res = exp.evaluate(EvaluationType.REAL, cm);
          result = (res % 1 == 0 ? res.toInt() : res).toString();
          equation = result;
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 35.0;
        resultFontSize = 25.0;

        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  /// When it works create button Widgets
  Widget buildButton(String buttonText, double buttonHeight, Color textColor) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * .25,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          padding: const EdgeInsets.all(15.0),
          backgroundColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            ),
          ),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.normal, color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          title: const Text("Calculator"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                equation,
                style: TextStyle(fontSize: equationFontSize),
              ),
            ), // Prints the Equation
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                result,
                style: TextStyle(fontSize: resultFontSize),
              ),
            ), // Prints the Result
            const Expanded(
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton("C", 1, Colors.blueAccent),
                          buildButton("X", 1, Colors.red),
                          buildButton("%", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("7", 1, Colors.black),
                          buildButton("8", 1, Colors.black),
                          buildButton("9", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("4", 1, Colors.black),
                          buildButton("5", 1, Colors.black),
                          buildButton("6", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("1", 1, Colors.black),
                          buildButton("2", 1, Colors.black),
                          buildButton("3", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton(".", 1, Colors.black),
                          buildButton("0", 1, Colors.black),
                          buildButton("00", 1, Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton("/", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("x", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("-", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("+", 1, Colors.black),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton("=", 1, Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ), // Button list
          ],
        ),
      ),
    );
  }
}
