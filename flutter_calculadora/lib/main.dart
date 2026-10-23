import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculadora Simples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controladores para pegar o texto digitado nos inputs
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  double _resultado = 0;

  // Função genérica para realizar as operações matemáticas
  void _calcular(String operacao) {
    // Converte o texto digitado para double (se estiver vazio, assume 0)
    double num1 = double.tryParse(_num1Controller.text) ?? 0;
    double num2 = double.tryParse(_num2Controller.text) ?? 0;

    setState(() {
      switch (operacao) {
        case '+':
          _resultado = num1 + num2;
          break;
        case '-':
          _resultado = num1 - num2;
          break;
        case '*':
          _resultado = num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            _resultado = num1 / num2;
          } else {
            _resultado = 0; // Tratamento para divisão por zero
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo para o primeiro número
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite o primeiro número',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para o segundo número
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite o segundo número',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Linha com os botões de operações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _calcular('+'),
                  child: const Text('+', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('-'),
                  child: const Text('-', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('*'),
                  child: const Text('×', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('/'),
                  child: const Text('÷', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Exibição do Resultado
            const Text(
              'Resultado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_resultado',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}