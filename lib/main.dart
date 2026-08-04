import 'package:flutter/material.dart';

void main() {
  runApp(PINApp());
}

class PINApp extends StatelessWidget {
  const PINApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PIN',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PIN(),
    );
  }
}

class PIN extends StatefulWidget {
  const PIN({super.key});

  @override
  PINState createState() => PINState();
}

class PINState extends State<PIN> {
  String result = '';

  TextEditingController nameInput = TextEditingController();
  TextEditingController input = TextEditingController();

  FocusNode nameInputFocus = FocusNode();
  FocusNode inputFocus = FocusNode();

  String errorText = '';

  int total = 0;

  final Map<String, int> alphabetNumbers = {
    'A': 1,
    'B': 2
  };

  @override
  void initState() {
    nameInputFocus.requestFocus();
    super.initState();
  }

  int numberChange(dynamic number) {
    switch (number) {
      case 10:
        return 1;
      case 11:
        return 2;
      case 12:
        return 3;
      case 13:
        return 4;
      case 14:
        return 5;
      case 15:
        return 6;
      case 16:
        return 7;
      case 17:
        return 8;
      case 18:
        return 9;
      default:
        return number;
    }
  }

  String r = '';

  dynamic continueTillSingle(dynamic result) {
    String res = '';
    for (var i = 0; i < result.length; i++) {
      if (i != result.length - 1) {
        res += numberChange(
          (int.parse(result[i]) + int.parse(result[i + 1])),
        ).toString();
      }
    }
    if (res.length == 1) {
      r += '\n$res';
      return r;
    } else {
      r += '\n$res';
      continueTillSingle(res);
    }
  }

  void convert() {
    try {
      setState(() {
        r = '';
        result = '';
        total = 0;
      });
      String name = nameInput.text;
      if (name.isNotEmpty) {
        input.text = '';
        for (var i = 0; i < name.length; i++) {
          input.text += alphabetNumbers.keys.contains(name[i].toUpperCase()) ? alphabetNumbers[name[i].toUpperCase()].toString() : '';
        }
      }

      setState(() {
        input.text = input.text.replaceAll(',', '');
        input.text = input.text.replaceAll('.', '');
        input.text = input.text.replaceAll(' ', '');
        input.text = input.text.replaceAll('-', '');
      });
      String testVal = input.text;
      for (var i = 0; i < testVal.length; i++) {
        total += int.parse(testVal[i]);
        if (i != testVal.length - 1) {
          setState(() {
            result += numberChange(
              (int.parse(testVal[i]) + int.parse(testVal[i + 1])),
            ).toString();
          });
        }
      }
      continueTillSingle(result);
      setState(() {
        result += r;
        result = '${input.text}\n$result';
        errorText = '';
      });
      nameInputFocus.unfocus();
    } catch (e) {
      setState(() {
        errorText = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: nameInputFocus,
                            controller: nameInput,
                            decoration: InputDecoration(labelText: 'Enter Name'),
                          ),
                        ),
                        ElevatedButton(onPressed: () => nameInput.text = '', child: Text('CLEAR'))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: inputFocus,
                            keyboardType: TextInputType.number,
                            controller: input,
                            decoration: InputDecoration(
                              labelText: 'Enter Number',
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            '= $total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () => convert(),
                          child: Text('GO'),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              r = '';
                              result = '';
                              input.text = '';
                              nameInput.text = '';
                              errorText = '';
                              total = 0;
                            });
                            nameInputFocus.requestFocus();
                          },
                          child: Text('CLEAR'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        result,
                        style: TextStyle(
                          letterSpacing: 3.5,
                          height: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(errorText),
          ],
        ),
      ),
    );
  }
}
