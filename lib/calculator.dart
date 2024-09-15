import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey,
            side: BorderSide(color: Colors.grey[800]!, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentInput = "";
  List<String> _expression = [];

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _expression.clear();
        _currentInput = "";
        _output = "0";
      } else if (buttonText == "⌫") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          if (_currentInput.isEmpty) {
            if (_expression.isNotEmpty) {
              _expression.removeLast();
            }
          }
          _updateOutput();
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_currentInput.isNotEmpty) {
          _expression.add(_currentInput);
          _expression.add(buttonText);
          _currentInput = "";
          _updateOutput();
        }
      } else if (buttonText == "=") {
        if (_currentInput.isNotEmpty) {
          _expression.add(_currentInput);
          _currentInput = "";
          try {
            _output = _calculateExpression(_expression).toString();
          } catch (e) {
            _output = "Error";
          }
          _expression.clear();
          _expression.add(_output);
        }
      } else {
        _currentInput += buttonText;
        _updateOutput();
      }
    });
  }

  void _updateOutput() {
    String expression = _expression.join(" ");
    if (_currentInput.isNotEmpty) {
      expression += " $_currentInput";
    }
    _output = expression.isEmpty ? "0" : expression;
  }

  double _calculateExpression(List<String> expression) {
    String exp = expression.join(" ");
    exp = exp.replaceAll("×", "*").replaceAll("÷", "/");

    final expressionToEvaluate = Expression.parse(exp);
    final evaluator = const ExpressionEvaluator();

    try {
      final result = evaluator.eval(expressionToEvaluate, {});
      return result.toDouble();
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  Widget _buildButton(String buttonText, {Color? color}) {
    return Expanded(
      child: Container(
        height: 80,
        margin: EdgeInsets.all(1),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color ?? Colors.grey[900],
            padding: EdgeInsets.all(20),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Calculator Example')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(child: Divider()),
            Column(children: [
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("÷")
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("×")
              ]),
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("-")
              ]),
              Row(children: [
                _buildButton("."),
                _buildButton("0"),
                _buildButton("00"),
                _buildButton("+")
              ]),
              Row(children: [
                _buildButton("C", color: Colors.red[700]),
                _buildButton("⌫", color: Colors.blue[700]),
                _buildButton("=", color: Colors.green[700])
              ]),
            ])
          ],
        ),
      ),
    );
  }
}
