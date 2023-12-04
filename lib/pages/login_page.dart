import 'package:flutter/material.dart';
import 'package:mango/app_state/account.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoBoxWidget(),
            LoginBoxWidget(),
          ],
        ),
      ),
    );
  }
}

class LogoBoxWidget extends StatelessWidget {
  const LogoBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              "🥭",
              style: TextStyle(fontSize: 75),
            ),
          ),
          Text(
            "Mango",
            style: TextStyle(fontSize: 50),
          ),
        ],
      ),
    );
  }
}

class LoginBoxWidget extends StatefulWidget {
  const LoginBoxWidget({super.key});

  @override
  State<LoginBoxWidget> createState() => _LoginBoxWidgetState();
}

class _LoginBoxWidgetState extends State<LoginBoxWidget> {
  String inputUserId = "";
  String inputPassword = "";
  @override
  Widget build(BuildContext context) {
    final account = context.read<Account>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '用户名',
            ),
            onChanged: (String s) => setState(() {
              inputUserId = s;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '密码',
            ),
            onChanged: (String s) => setState(() {
              inputPassword = s;
            }),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          child: SizedBox(
            child: ElevatedButton(
                onPressed: () {
                  account.login(inputUserId, inputPassword);
                },
                child: const Text('登录')),
          ),
        ),
      ],
    );
  }
}
