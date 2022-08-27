import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cenoyam/presentation/bloc/login_bloc.dart';
import 'package:cenoyam/presentation/bloc/login_event.dart';
import 'package:cenoyam/presentation/bloc/login_state.dart';
import 'package:cenoyam/presentation/widget/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

void main() {
  final navigator = MockNavigator();
  final bloc = MockLoginBloc();
  tearDown(() {
    bloc.reset();
    reset(bloc);
    reset(navigator);
  });

  testWidgets('Form renders', (widgetTester) async {
    whenListen(
      bloc,
      const Stream<LoginFormState>.empty(),
      initialState: const LoginFormState(LoginState.initial, '', ''),
    );

    await widgetTester.pumpWidget(
      Provider<LoginBloc>.value(
        value: bloc,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('On input form changes internal state', (widgetTester) async {
    whenListen(
      bloc,
      const Stream<LoginFormState>.empty(),
      initialState: const LoginFormState(LoginState.initial, '', ''),
    );

    await widgetTester.pumpWidget(
      Provider<LoginBloc>.value(
        value: bloc,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    final loginField = find.widgetWithText(TextFormField, 'Login');
    expect(loginField, findsOneWidget);
    await widgetTester.enterText(loginField, 'some_login');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    expect(passwordField, findsOneWidget);
    await widgetTester.enterText(passwordField, 'some_password');
    final submitButton = find.widgetWithText(ElevatedButton, 'Login');
    expect(submitButton, findsOneWidget);
    await widgetTester.tap(submitButton);

    expect(bloc.result, 'some_login some_password');
  });

  testWidgets('On succesful login form exits', (widgetTester) async {
    whenListen(
      bloc,
      Stream<LoginFormState>.fromIterable(
        const [LoginFormState(LoginState.success, '', '')],
      ),
      initialState: const LoginFormState(LoginState.initial, '', ''),
    );

    await widgetTester.pumpWidget(
      Provider<LoginBloc>.value(
        value: bloc,
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const LoginScreen(),
          ),
        ),
      ),
    );
    await widgetTester.pump();

    verify(navigator.pop);
  });

  testWidgets('On failure form shows error', (widgetTester) async {
    whenListen(
      bloc,
      Stream<LoginFormState>.fromIterable(
        const [LoginFormState(LoginState.failure, '', '')],
      ),
      initialState: const LoginFormState(LoginState.initial, '', ''),
    );

    await widgetTester.pumpWidget(
      Provider<LoginBloc>.value(
        value: bloc,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
    await widgetTester.pump();

    verifyNever(navigator.pop);
    expect(find.text('Login failure'), findsOneWidget);
    expect(bloc.cleared, isTrue);
  });
}

class MockLoginBloc extends MockBloc<LoginFormEvent, LoginFormState>
    implements LoginBloc {
  String _login = '';
  String _password = '';
  String result = '';
  bool cleared = false;

  @override
  void add(LoginFormEvent event) {
    event.when(
      saveLogin: (login) => _login = login,
      savePassword: (password) => _password = password,
      login: () => result = '$_login $_password',
      clearState: () => cleared = true,
    );
    super.add(event);
  }

  void reset() {
    _login = '';
    _password = '';
    result = '';
    cleared = false;
  }
}
