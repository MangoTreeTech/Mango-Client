import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mango/app_state/account.dart';
import 'package:mango/utils/login_info_check.dart';
import 'package:mango/utils/register_info_check.dart';
import 'package:oktoast/oktoast.dart';
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
  String inputUsername = "";
  String inputPassword = "";
  int pageSet = 0;
  @override
  Widget build(BuildContext context) {
    if (pageSet == 1) {
      return LoginBoxRegisterWidget(inputUsername, inputPassword, callback);
    } else {
      return LoginBoxLoginWidget(inputUsername, inputPassword, callback);
    }
  }

  void callback({String? username, String? password, int? pageSet}) {
    setState(() {
      if (username != null) inputUsername = username;
      if (password != null) inputPassword = password;
      if (pageSet != null) this.pageSet = pageSet;
    });
  }
}

class LoginBoxLoginWidget extends StatefulWidget {
  const LoginBoxLoginWidget(
      this.inputUsername, this.inputPassword, this.callback,
      {super.key});
  final String inputUsername;
  final String inputPassword;
  final Function callback;
  @override
  State<LoginBoxLoginWidget> createState() => _LoginBoxLoginWidgetState();
}

class _LoginBoxLoginWidgetState extends State<LoginBoxLoginWidget> {
  late String inputUsername;
  late String inputPassword;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    Account account = context.read<Account>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '用户名',
            ),
            onChanged: (String s) => setState(() {
              inputUsername = s;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            controller: passwordController,
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
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    widget.callback(
                        username: inputUsername,
                        password: inputPassword,
                        pageSet: 1);
                  },
                  child: const Text('注册')),
              OutlinedButton(
                  onPressed: () {
                    LoginInfoError e = LoginInfoCheck.offlineCheck(
                      inputUsername,
                      inputPassword,
                    );
                    if (e == LoginInfoError.noError) {
                      account.login(inputUsername, inputPassword);
                    } else {
                      showToast(
                          LoginInfoCheck.errorText[e] ?? "Unknown Error!");
                    }
                  },
                  child: const Text('登录')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    inputPassword = widget.inputPassword;
    inputUsername = widget.inputUsername;
    usernameController = TextEditingController(text: inputUsername);
    passwordController = TextEditingController(text: inputPassword);
    super.initState();
  }
}

class LoginBoxRegisterWidget extends StatefulWidget {
  const LoginBoxRegisterWidget(
      this.inputUsername, this.inputPassword, this.callback,
      {super.key});
  final String inputUsername;
  final String inputPassword;
  final Function callback;
  @override
  State<LoginBoxRegisterWidget> createState() => _LoginBoxRegisterWidgetState();
}

class _LoginBoxRegisterWidgetState extends State<LoginBoxRegisterWidget> {
  late String inputUsername;
  late String inputPassword;
  String reInputPassword = "";
  // String inputPhoneNumber = "";
  String inputEmail = "";

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    Account account = context.read<Account>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '用户名',
            ),
            onChanged: (String s) => setState(() {
              inputUsername = s;
            }),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        //   child: TextField(
        //     decoration: const InputDecoration(
        //       border: OutlineInputBorder(),
        //       labelText: '手机号',
        //     ),
        //     onChanged: (String s) => setState(() {
        //       inputPhoneNumber = s;
        //     }),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '邮箱',
            ),
            onChanged: (String s) => setState(() {
              inputEmail = s;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            controller: passwordController,
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '确认密码',
            ),
            onChanged: (String s) => setState(() {
              reInputPassword = s;
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    widget.callback(
                        username: inputUsername,
                        password: inputPassword,
                        pageSet: 0);
                  },
                  child: const Text('登录')),
              OutlinedButton(
                  onPressed: () {
                    RegisterInfoError e = RegisterInfoCheck.offlineCheck(
                        inputUsername, inputPassword, reInputPassword,
                        email: inputEmail);
                    if (e == RegisterInfoError.noError) {
                      account.register(inputUsername, reInputPassword);
                    } else {
                      showToast(
                          RegisterInfoCheck.errorText[e] ?? "Unknown Error!");
                    }
                  },
                  child: const Text('注册')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    inputPassword = widget.inputPassword;
    inputUsername = widget.inputUsername;
    usernameController = TextEditingController(text: inputUsername);
    passwordController = TextEditingController(text: inputPassword);
    super.initState();
  }
}
