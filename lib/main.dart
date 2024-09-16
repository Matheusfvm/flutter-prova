import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app',
      initialRoute: "/",
      routes: {
        '/': (context) => FirstPage(),
        'login': (context) => FirstPage(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // um retângulo para separar widgets
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 10.0),
            ElevatedButton(
                child: Text('Acessar'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                }),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailDigitado = TextEditingController();
  final TextEditingController _senhaDigitado = TextEditingController();
  String _emailRecuperado = '';
  String _senhaRecuperada = '';
  String _tokenRecuperado = '';

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(""));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _emailRecuperado = jsonResponse.email;
        _senhaRecuperada = jsonResponse.senha;
      });
    }
  }
}
