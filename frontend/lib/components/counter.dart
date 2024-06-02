import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {
  int counter = 0;

  void increment() => setState(() {
        counter++;
      });

  void decrement() => setState(() {
        counter--;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Count is $counter"),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: increment, child: const Text("Increment")),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: decrement, child: const Text("Decrement")),
      ],
    );
  }
}
