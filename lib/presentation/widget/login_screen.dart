import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocListener<LoginBloc, LoginFormState>(
        listenWhen: (previous, current) => previous.state != current.state,
        listener: (context, state) {
          switch (state.state) {
            case LoginState.success:
              bloc.add(const LoginFormEvent.clearState());
              Navigator.pop(context);
              break;
            case LoginState.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Login failure'),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                ),
              );
              bloc.add(const LoginFormEvent.clearState());
              break;

            case LoginState.initial:
              break;
          }
        },
        child: const _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Login',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Login must not be empty';
              }
              return null;
            },
            onSaved: (value) {
              bloc.add(SaveLogin(value!));
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password must not be empty';
              }
              return null;
            },
            onSaved: (value) {
              bloc.add(SavePassword(value!));
            },
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                bloc.add(const TryLogin());
              }
            },
          ),
        ],
      ),
    );
  }
}
