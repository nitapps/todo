import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

enum AppLoginState { loggedIn, loggedOut, email, password, signUp }

class Authentication extends StatelessWidget {
  const Authentication(
      {Key? key,
      required this.appLoginState,
      this.email,
      required this.verifyEmail,
      required this.startLoginFlow,
      required this.signIn,
      required this.signUp,
      required this.cancel,
      required this.signOut})
      : super(key: key);
  final AppLoginState appLoginState;
  final String? email;
  final void Function(String email) verifyEmail;
  final void Function() startLoginFlow;
  final void Function(String email, String password) signIn;
  final void Function(String email, String password, String name) signUp;
  final void Function() cancel;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (appLoginState) {
      case AppLoginState.loggedIn:
        return Row(
          children: [
            const Expanded(
                child: Center(
              child: Text(
                "Welcome to Todo",
                style: TextStyle(fontSize: 32.0, color: Colors.blue),
              ),
            )),
            ElevatedButton(
                onPressed: () {
                  signOut();
                },
                child: const Text("Sign Out")),
          ],
        );
      case AppLoginState.email:
        return EmailForm(verifyEmail: (email) => verifyEmail(email));
      case AppLoginState.password:
        return Center(
          child: PasswordForm(
              email: email!,
              login: (email, password) {
                signIn(email, password);
              }),
        );
      case AppLoginState.signUp:
        return Center(
          child: SignUpForm(
            email: email!,
            signUp: (email, password, name) {
              signUp(email, password, name);
            },
            cancel: () {
              cancel();
            },
          ),
        );
      case AppLoginState.loggedOut:
        return Center(
          child: ElevatedButton(
            onPressed: () {
              startLoginFlow();
            },
            child: const Text("Login"),
          ),
        );
      default:
        return const Center(
          child: Text("Something went wrong"),
        );
    }
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key, required this.verifyEmail}) : super(key: key);
  final void Function(String email) verifyEmail;

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _emailFormKey = GlobalKey<FormState>();
  final _emailFormFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Sign in with email",
          style: TextStyle(fontSize: 32.0, color: Colors.blue),
        ),
        Form(
          key: _emailFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailFormFieldController,
                decoration: const InputDecoration(
                  hintText: "Enter your Email",
                ),
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Enter a valid email",
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_emailFormKey.currentState!.validate()) {
                      widget.verifyEmail(_emailFormFieldController.text);
                    }
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key, required this.email, required this.login})
      : super(key: key);
  final String email;
  final Function(String email, String password) login;

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFieldController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Login",
          style: TextStyle(fontSize: 32.0, color: Colors.blue),
        ),
        Form(
          key: _passwordFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailFieldController,
                decoration: const InputDecoration(
                  hintText: "Enter your email address",
                ),
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Enter a valid email",
              ),
              TextFormField(
                controller: _passwordFieldController,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  } else if (value.length < 5) {
                    return "Password should be of minimum 5 characters";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_passwordFormKey.currentState!.validate()) {
                      widget.login(_emailFieldController.text,
                          _passwordFieldController.text);
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm(
      {Key? key,
      required this.signUp,
      required this.email,
      required this.cancel})
      : super(key: key);
  final void Function(String email, String password, String name) signUp;
  final String email;
  final void Function() cancel;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _nameFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFieldController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Create new account",
        style: TextStyle(fontSize: 32.0, color: Colors.blue),
      ),
      Form(
        key: _signUpFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailFieldController,
              decoration: const InputDecoration(
                hintText: "Enter email address",
              ),
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : "Enter a valid Email Address",
            ),
            TextFormField(
              controller: _passwordFieldController,
              decoration: const InputDecoration(
                hintText: "Enter your password",
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                } else if (value.length < 6) {
                  return "Password should be of minimum 6 characters";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: _nameFieldController,
              decoration: const InputDecoration(
                hintText: "Enter your name",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your name";
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.cancel();
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_signUpFormKey.currentState!.validate()) {
                          widget.signUp(
                              _emailFieldController.text,
                              _passwordFieldController.text,
                              _nameFieldController.text);
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
