import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreenWidget(),
    );
  }
}

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(117, 180, 225, 10),
                Color.fromRGBO(141, 175, 197, 250),
              ],
            ),
          ),
          child: const CalcWidget(),
        ),
      ),
    );
  }
}

class CalcWidget extends StatefulWidget {
  const CalcWidget({Key? key}) : super(key: key);

  @override
  _CalcWidgetState createState() => _CalcWidgetState();
}

class _CalcWidgetState extends State<CalcWidget> {
  final _model = CalculateWidgetModel();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ChangeNotifierProvider(
          model: _model,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('All fields must be filled in', style: TextStyle(fontSize: 18,),),
              SizedBox(
                height: 10,
              ),
              BillAmountWidget(),
              SizedBox(height: 10),
              TipPercentageWidget(),
              DropdownButtonWidget(),
              SizedBox(height: 10),
              NumberOfPersonsWidget(),
              SizedBox(height: 10),
              SummButtonWidget(),
              SizedBox(height: 10),
              ResultWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class BillAmountWidget extends StatelessWidget {
  const BillAmountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Bill amount',
        filled: true,
        fillColor: Colors.white.withAlpha(235),
        border: const OutlineInputBorder(),
      ),
      onChanged: (String value) =>
          ChangeNotifierProvider.read<CalculateWidgetModel>(context)
              ?.billAmount = value,
    );
  }
}

class TipPercentageWidget extends StatelessWidget {
  const TipPercentageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Tip percentage',
        filled: true,
        fillColor: Colors.white.withAlpha(235),
        border: const OutlineInputBorder(),
      ),
      onChanged: (String value) =>
          ChangeNotifierProvider.read<CalculateWidgetModel>(context)
              ?.tipPercentage = value,
    );
  }
}

class DropdownButtonWidget extends StatefulWidget {
  const DropdownButtonWidget({Key? key}) : super(key: key);

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  List<String> items = const [
    '1',
    '10',
    '50',
    '100',
  ];
  late String dropdownvalue = items[0];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Text('Rounding up to:', style: TextStyle(fontSize: 18,),),
            const SizedBox(
              width: 5,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton(
                //make true to take width of parent widget
                underline: Container(), //empty line
                style: const TextStyle(fontSize: 18, color: Colors.black),
                value: dropdownvalue,
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  ChangeNotifierProvider.read<CalculateWidgetModel>(context)
                      ?.rounding = newValue!;
                  setState(
                    () {
                      dropdownvalue = newValue!;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberOfPersonsWidget extends StatelessWidget {
  const NumberOfPersonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Number of persons',
        filled: true,
        fillColor: Colors.white.withAlpha(235),
        border: const OutlineInputBorder(),
      ),
      onChanged: (String value) =>
          ChangeNotifierProvider.read<CalculateWidgetModel>(context)
              ?.numberOfPersons = value,
    );
  }
}

class SummButtonWidget extends StatelessWidget {
  const SummButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          ChangeNotifierProvider.read<CalculateWidgetModel>(context)
              ?.calculate(),
      child: const Text('Сalculate'),
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value =
        ChangeNotifierProvider.watch<CalculateWidgetModel>(context)?.result ??
            '';
    return Text('Result: $value', style: const TextStyle(fontSize: 18,),);
  }
}

class CalculateWidgetModel extends ChangeNotifier {
  double? _billAmount;
  double? _tipPercentage;
  int? _numberOfPersons;
  int? _rounding = 1;
  double? result;

  set billAmount(String value) =>
      _billAmount = double.tryParse(value.replaceAll(',', '.'));
  set tipPercentage(String value) =>
      _tipPercentage = double.tryParse(value.replaceAll(',', '.'));
  set numberOfPersons(String value) => _numberOfPersons = int.tryParse(value);
  set rounding(String value) => _rounding = int.tryParse(value);

  void calculate() {
    result = 0.0;
    if (_billAmount != null &&
        _tipPercentage != null &&
        _numberOfPersons != null) {
      if (_rounding == 1) {
        result =
            (_billAmount! + (_tipPercentage! / 100 * _billAmount!)).ceil() /
                _numberOfPersons!;
      }
      if (_rounding == 10) {
        result =
            ((_billAmount! + (_tipPercentage! / 100 * _billAmount!)) / 10).ceil() * 10;
        result = result! / _numberOfPersons!;
      }
      if (_rounding == 50) {
        result = ((_billAmount! + (_tipPercentage! / 100 * _billAmount!)) / 50)
                .ceil() *
            50 /
            _numberOfPersons!;
      }
      if (_rounding == 100) {
        result = ((_billAmount! + (_tipPercentage! / 100 * _billAmount!)) / 100)
                .ceil() *
            100/
            _numberOfPersons!;
      }
    } else {
      result = 0;
    }
    notifyListeners();
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  const ChangeNotifierProvider({
    Key? key,
    required T model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static T? watch<T extends ChangeNotifier>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChangeNotifierProvider<T>>()
        ?.notifier;
  }

  static T? read<T extends ChangeNotifier>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ChangeNotifierProvider<T>>()
        ?.widget;
    if (widget is ChangeNotifierProvider<T>) {
      return widget.notifier;
    } else {
      return null;
    }
  }
}
