import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MOT/bloc/login/login_bloc.dart';
import 'package:MOT/bloc/register/register_bloc.dart';
import 'package:MOT/helpers/imagePicker/imagerPicker.dart';
import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/widgets/home.dart';
import 'package:MOT/widgets/widgets/loading_indicator.dart';

class RegisterSectionWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  RegisterSectionWidget({this.globalKey});

  @override
  _RegisterSectionWidgetState createState() => _RegisterSectionWidgetState();
}

class _RegisterSectionWidgetState extends State<RegisterSectionWidget> with TickerProviderStateMixin {
  bool hidePassword = false;
  SingleUserModel _singleLoginModel = SingleUserModel();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final double startingHeight = 20.0;
  final double horizontalPadding = 30;
  final double animationRange = 24;
  AnimationController animationController;
  final Duration animationDuration = const Duration(milliseconds: 500);
  int selectedId = 0;
  Widget myRadioButton({Widget title, int value, Function onChanged}) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).accentColor,
      ),
      child: RadioListTile(
        value: value,
        groupValue: selectedId,
        onChanged: onChanged,
        title: title,
        activeColor: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: animationDuration, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation =
    Tween(begin: 0.0, end: animationRange)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      });
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (BuildContext context, RegisterState state) {
      if (state is LoginInitial) {
        print("RegisterInitial");
      }

      if (state is RegisterError) {
        widget.globalKey?.currentState?.showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }

      if (state is RegisterLoaded) {
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
              'Sign up',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            Text(
              "Get started by adding your identity",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(fontWeight: FontWeight.normal)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            AnimatedBuilder(
              animation: offsetAnimation,
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: animationRange),
                  padding: EdgeInsets.only(
                      left: offsetAnimation.value + horizontalPadding,
                      right: horizontalPadding - offsetAnimation.value),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                          color: Theme.of(context).hintColor,
                          onPressed: () {
                            getImage().then((value) {
                                setState(() {
                                  _singleLoginModel.imageFile = value;
                                });
                              });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                                'Tap to add Image',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .merge(TextStyle(
                                    color:
                                    Theme.of(context).accentColor)),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Name',
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
                keyboardType: TextInputType.name,
                onSaved: (input) => _singleLoginModel.name = input,
                validator: (input) => input.isEmpty
                    ? "Required Field"
                    : null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Enter Username",
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .focusColor
                          .withOpacity(0.7)),
                  prefixIcon: Icon(Icons.perm_identity_sharp,
                      color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                ),
              ),
            ),
            SizedBox(height: 10),
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
                validator: (input) => !input.contains('@')
                    ? "Should be a valid email"
                    : null,
                decoration: InputDecoration(
                  /* labelText: "Email",
                    labelStyle:
                    TextStyle(color: Theme.of(context).focusColor),*/
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Enter Email",
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .focusColor
                          .withOpacity(0.7)),
                  prefixIcon: Icon(Icons.alternate_email_outlined,
                      color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).focusColor)),
                ),
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            Text(
              "Choose who you are",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(fontWeight: FontWeight.normal, color: Theme.of(context).hintColor)),
              textAlign: TextAlign.center,
            ),
            myRadioButton(
              title: Text("Investor",style: selectedId==0?TextStyle(fontSize: 25):TextStyle(),),
              value: 0,
              onChanged: (newValue) {
                setState(() {
                  selectedId = newValue;
                  _singleLoginModel.setType = "investor";
                });

              },
            ),
            myRadioButton(
              title: Text("Guru",style: selectedId==1?TextStyle(fontSize: 25):TextStyle(),),
              value: 1,
              onChanged: (newValue) {
                setState(() {
                  selectedId = newValue;
                  _singleLoginModel.setType = "guru";
                });
              },
            ),
            SizedBox(height: 15),
            state is RegisterLoading
            ? LoadingIndicatorWidget(): Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if(_singleLoginModel.isFileEmpty()) {
                      animationController.forward(from: 0.0);
                    }else{
                      if (loginFormKey.currentState.validate()) {
                        loginFormKey.currentState.save();
                        BlocProvider.of<RegisterBloc>(context).add(
                            FetchRegisterResults(singleUserModel: _singleLoginModel));
                      }
                    }
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
            SizedBox(height: 10),
          ],
        ),
      );
    });
  }
}
