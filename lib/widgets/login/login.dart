import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/login/login_bloc.dart';
import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/widgets/home.dart';
import 'package:MOT/widgets/register/register_section.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';

class LoginSectionWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  LoginSectionWidget({this.globalKey});

  @override
  _LoginSectionWidgetState createState() => _LoginSectionWidgetState();
}

class _LoginSectionWidgetState extends State<LoginSectionWidget> {
  bool hidePassword = false;
  SingleUserModel _singleLoginModel = SingleUserModel();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
      if (state is LoginInitial) {
        print("LoginInitial");
      }

      if (state is LoginError) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          widget.globalKey.currentState.showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        });
      }

      if (state is LoginLoaded) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => StockMarketAppHome()));
        });
      }

      return Form(
        key: loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Sign in',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            Text(
              'Start trade by signing in',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(fontWeight: FontWeight.normal)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Email',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(fontWeight: FontWeight.normal)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (input) => _singleLoginModel.email = input,
                validator: (input) =>
                    !input.contains('@') ? "Should be a valid email" : null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Enter username",
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.perm_identity_sharp,
                      color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Password',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(fontWeight: FontWeight.normal)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (input) => _singleLoginModel.password = input,
                validator: (input) =>
                    input.length < 8 ? "Should be more then 8 character" : null,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).accentColor),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor,
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .merge(TextStyle(height: -2.4)),
                ),
              ),
            ),
            SizedBox(height: 10),
            state is LoginLoading
                ? LoadingIndicatorWidget()
                : Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (loginFormKey.currentState.validate()) {
                            loginFormKey.currentState.save();
                            BlocProvider.of<LoginBloc>(context).add(
                                FetchLoginResults(
                                    email: _singleLoginModel.email,
                                    password: _singleLoginModel.password));}
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          'Continue',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 15),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
                children: [
                  TextSpan(
                    text: 'Not a member yet',
                  ),
                  TextSpan(
                    text: '? ',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  TextSpan(
                    text: 'Register',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RegisterSection()));
                        });
                      },
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' today.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
