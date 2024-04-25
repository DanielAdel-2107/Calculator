// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:calculator/constants.dart';
import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String num1 = "";
  String operand = "";
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${num1}${operand}${num2}".isEmpty
                          ? "0"
                          : "${num1}${operand}${num2}",
                      style:
                          const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                      height: screenSize.width / 5,
                      width: value == Btn.n0
                          ? (screenSize.width / 2)
                          : (screenSize.width / 4),
                      child: CustomMaterialButton(value)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
  //################## button function
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clear();
      return;
    }
    if (value == Btn.per) {
      percentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }
  //################## percentage delete

  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    }
    if (operand.isNotEmpty) {
      operand = "";
    }

    if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }
  //################## percentage clear

  void clear() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  //################## percentage method
  void percentage() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }
    if (num1.isEmpty && operand.isEmpty && num2.isEmpty) return;
    if (operand.isNotEmpty) {
      return;
    }
    final res = double.parse(num1);

    setState(() {
      num1 = "${res / 100}";
      operand = "";
      num2 = "";
    });
  }

  //################## calculate method
  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;
    final number1 = double.parse(num1);
    final number2 = double.parse(num2);
    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = number1 + number2;
        break;
      case Btn.subtract:
        result = number1 - number2;
        break;
      case Btn.multiply:
        result = number1 * number2;
        break;
      case Btn.divide:
        result = number1 / number2;
        break;
      default:
    }
    setState(() {
      num1 = "${result}";

      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }
      operand = '';
      num2 = '';
    });
  }

  //################## appendValue method
  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      } else {
        return;
      }
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      if (num1 == Btn.dot && num1.contains(Btn.dot)) {
        return;
      }
      if (num1 == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isEmpty) {
      if (num2 == Btn.dot && num2.contains(Btn.dot)) {
        return;
      }
      if (num2 == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

  //############### set color for button
  Color getColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.subtract,
            Btn.calculate,
            Btn.divide,
            Btn.multiply,
            Btn.add
          ].contains(value)
            ? Colors.orange
            : Colors.black;
  }

  //############### custom button widget
  Widget CustomMaterialButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MaterialButton(
        color: getColor(value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => onBtnTap(value),
        child: Text('$value',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
