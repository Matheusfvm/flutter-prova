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
        '/login': (context) => LoginPage(),
        '/notasAluno': (context) => NotasAlunoPage(),
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
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 10.0),
            ElevatedButton(
                child: Text('Acessar'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
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
  String token = "";
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("https://demo9989392.mockable.io/login"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        token = jsonResponse['token'];
      });
    } else {
      print("Requisição falhou com o status: ${response.statusCode}.");
    }
  }

  void _enviar() async {
    String email = _email.text;
    String senha = _senha.text;

    if (email.isNotEmpty && senha.isNotEmpty) {
      await fetchData();
      if (token.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TokenPage(token: token)));
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 200),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: 'Login',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                )),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _senha,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                )),
            const SizedBox(height: 100.0),
            SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _enviar,
                      child: const Text('Enviar'),
                    ),
                  ],
                )),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class TokenPage extends StatelessWidget {
  final String token;
  const TokenPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Token Recebido',
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              token,
              style: const TextStyle(fontSize: 24.0, color: Colors.black54),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/notasAluno');
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotasAlunoPage extends StatefulWidget {
  const NotasAlunoPage({super.key});

  @override
  State<StatefulWidget> createState() => NotasAlunoPageState();
}

class NotasAlunoPageState extends State<NotasAlunoPage> {
  List<dynamic> listaAlunos = [];
  List<dynamic> listaFiltrada = [];

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse("https://demo9989392.mockable.io/notasAlunos"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        listaAlunos = jsonResponse;
        listaFiltrada = listaAlunos;
      });
    } else {
      print("Requisição falhou com o status: ${response.statusCode}.");
    }
  }

  void _filtarNotasMenoresQue60() {
    setState(() {
      listaFiltrada = listaAlunos.where((aluno) => aluno['nota'] < 60).toList();
    });
  }

  void _filtarNotasEntre60E99() {
    setState(() {
      listaFiltrada = listaAlunos
          .where((aluno) => aluno['nota'] >= 60 && aluno['nota'] < 100)
          .toList();
    });
  }

  void _filtarNotasIguais100() {
    setState(() {
      listaFiltrada =
          listaAlunos.where((aluno) => aluno['nota'] == 100).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listaFiltrada.length,
                itemBuilder: (BuildContext context, int index) {
                  final aluno = listaFiltrada[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: (aluno['nota'] < 60
                          ? Colors.yellow
                          : aluno['nota'] < 100
                              ? Colors.blue
                              : Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text("Matricula: ${aluno['matricula']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  Nome: ${aluno['nome']}"),
                          Text("  Nota: ${aluno['nota']}")
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _filtarNotasMenoresQue60,
                    child: Text('< 60'),
                  ),
                  ElevatedButton(
                    onPressed: _filtarNotasEntre60E99,
                    child: Text('>=60'),
                  ),
                  ElevatedButton(
                    onPressed: _filtarNotasIguais100,
                    child: Text('=100'),
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
