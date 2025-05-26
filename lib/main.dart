import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Style Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';
  bool _shouldReset = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
        _shouldReset = false;
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '+/-') {
        if (_expression.isNotEmpty) {
          if (_expression.startsWith('-')) {
            _expression = _expression.substring(1);
          } else {
            _expression = '-$_expression';
          }
        }
      } else if (value == '%') {
        if (_expression.isNotEmpty) {
          try {
            final eval = ShuntingYardParser().parse(
              _expression.replaceAll('×', '*').replaceAll('÷', '/'),
            );
            final res =
                eval.evaluate(EvaluationType.REAL, ContextModel()) / 100;
            _expression = res.toString();
          } catch (_) {
            _result = 'Hiba';
          }
        }
      } else if (value == '=') {
        try {
          final exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
          final parser = ShuntingYardParser();
          final parsedExp = parser.parse(exp);
          final eval = parsedExp.evaluate(EvaluationType.REAL, ContextModel());
          _result = eval.toString().endsWith('.0')
              ? eval.toInt().toString()
              : eval.toString();
          _shouldReset = true;
        } catch (_) {
          _result = 'Hiba';
          _shouldReset = true;
        }
      } else {
        if (_shouldReset || _result == 'Hiba') {
          _expression = '';
          _result = '0';
          _shouldReset = false;
        }
        // Ne engedj dupla operátort
        if (_expression.isNotEmpty &&
            '+-×÷.'.contains(value) &&
            '+-×÷.'.contains(_expression[_expression.length - 1])) {
          _expression =
              _expression.substring(0, _expression.length - 1) + value;
        } else {
          _expression += value;
        }
      }
    });
  }

  Widget _buildButton(
    String text, {
    Color? color,
    Color? textColor,
    double fontSize = 32,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: AspectRatio(
          // MINDIG 1:1 arány, így a "0" is kör lesz
          aspectRatio: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor ?? Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(0),
              elevation: 0,
            ),
            onPressed: () => _onButtonPressed(text),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: textColor ?? Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF444444);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression,
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.white54,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton(
                        'C',
                        color: const Color(0xFFa5a5a5),
                        textColor: Colors.black,
                      ),
                      _buildButton(
                        '+/-',
                        color: const Color(0xFFa5a5a5),
                        textColor: Colors.black,
                        fontSize: 28,
                      ),
                      _buildButton(
                        '%',
                        color: const Color(0xFFa5a5a5),
                        textColor: Colors.black,
                      ),
                      _buildButton(
                        '÷',
                        color: const Color(0xFFf1a33c),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7', color: bg, textColor: Colors.white),
                      _buildButton('8', color: bg, textColor: Colors.white),
                      _buildButton('9', color: bg, textColor: Colors.white),
                      _buildButton(
                        '×',
                        color: const Color(0xFFf1a33c),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4', color: bg, textColor: Colors.white),
                      _buildButton('5', color: bg, textColor: Colors.white),
                      _buildButton('6', color: bg, textColor: Colors.white),
                      _buildButton(
                        '-',
                        color: const Color(0xFFf1a33c),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1', color: bg, textColor: Colors.white),
                      _buildButton('2', color: bg, textColor: Colors.white),
                      _buildButton('3', color: bg, textColor: Colors.white),
                      _buildButton(
                        '+',
                        color: const Color(0xFFf1a33c),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(
                        '0',
                        color: bg,
                        textColor: Colors.white,
                        fontSize: 32,
                      ),
                      _buildButton(
                        '.',
                        color: bg,
                        textColor: Colors.white,
                        fontSize: 32,
                      ),
                      _buildButton(
                        '⌫',
                        color: bg,
                        textColor: Colors.white,
                        fontSize: 28,
                      ),
                      _buildButton(
                        '=',
                        color: const Color(0xFFf1a33c),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
