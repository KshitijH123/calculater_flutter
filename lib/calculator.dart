import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _operand = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operand = buttonText;
          _currentInput = "";
          _output = _num1.toString() + " " + _operand;
        }
      } else if (buttonText == "=") {
        if (_currentInput.isNotEmpty && _operand.isNotEmpty) {
          double num2 = double.parse(_currentInput);
          switch (_operand) {
            case "+":
              _output = (_num1 + num2).toString();
              break;
            case "-":
              _output = (_num1 - num2).toString();
              break;
            case "×":
              _output = (_num1 * num2).toString();
              break;
            case "÷":
              _output = (_num1 / num2).toString();
              break;
          }
          _num1 = double.parse(_output);
          _operand = "";
          _currentInput = "";
        }
      } else {
        _currentInput += buttonText;
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _buttonPressed(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Calculator')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Divider()),
            Column(children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("÷")
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("×")
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-")
              ]),
              Row(children: [
                _buildButton("."),
                _buildButton("0"),
                _buildButton("00"),
                _buildButton("+")
              ]),
              Row(children: [_buildButton("C"), _buildButton("=")]),
            ])
          ],
        ),
      ),
    );
  }
}
