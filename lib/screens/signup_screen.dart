import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:momday_app/app_state_manager.dart';
import 'package:momday_app/momday_localizations.dart';
import 'package:momday_app/momday_utils.dart';
import 'package:momday_app/styles/momday_colors.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

enum Genders {
  female,
  male
}

class _SignupScreenState extends State<SignupScreen> {

  bool _isSigningUp;
  Genders radioGender = Genders.female;

  @override
  void initState() {
    super.initState();
    this._lastNameFocusNode = FocusNode();
    this._emailFocusNode = FocusNode();
    this._dobFocusNode = FocusNode();
    this._phoneNumberFocusNode = FocusNode();
    this._passwordFocusNode = FocusNode();
    this._confirmPasswordFocusNode = FocusNode();
    this._isSigningUp = false;
  }

  FocusNode _lastNameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _dobFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  String _firstName;
  String _lastName;
  String _email;
  String _dob;
  String _gender = '7'; // female
  String _phoneNumber;
  String _password;
  String _confirmPassword;

  void setGender(Genders gender) {

    setState(() {

      this.radioGender = gender;

      if(gender == Genders.male)
        this._gender = '8';

      else
        this._gender = '7';

      print("gender is $_gender");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(
                getLocalizedBackwardArrowIcon(context),
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ),
        backgroundColor: Colors.white,
        body: Builder(
          builder: (BuildContext context) {
            return Form(
              key: this._formKey,
              child: Theme(
                data: ThemeData(
                  primaryColor: MomdayColors.MomdayGold,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text(
                        tTitle(context, 'welcome'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w600
                        )
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                      decoration: getMomdayInputDecoration(tTitle(context, 'first_name')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        }
                      },
                      onSaved: (value) => this._firstName = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._lastNameFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: false,
                      focusNode: this._lastNameFocusNode,
                      decoration: getMomdayInputDecoration(tTitle(context, 'last_name')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        }
                      },
                      onSaved: (value) => this._lastName = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._emailFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      focusNode: this._emailFocusNode,
                      decoration: getMomdayInputDecoration(tTitle(context, 'email')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        } else if (!emailRegExp.hasMatch(value)) {
                          return tSentence(context, 'not_valid_email');
                        }
                      },
                      onSaved: (value) => this._email = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._dobFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      autofocus: false,
                      focusNode: this._dobFocusNode,
                      decoration: getMomdayInputDecoration(tTitle(context, 'dob')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        }
                        else if (!dobRegExp.hasMatch(value)) {
                          return tSentence(context, 'not_valid_dob');
                        }
                      },
                      onSaved: (value) => this._dob = value,
//                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._phoneNumberFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Radio(
                          value: Genders.female,
                          groupValue: radioGender,
                          onChanged: (value) => setGender(value),
                          activeColor: MomdayColors.MomdayGold,
                        ),
                        new Text(
                          'Female',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: Genders.male,
                          groupValue: radioGender,
                          onChanged: (value) => setGender(value),
                          activeColor: MomdayColors.MomdayGold,
                        ),
                        new Text(
                          'Male',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      autofocus: false,
                      focusNode: this._phoneNumberFocusNode,
                      decoration: getMomdayInputDecoration(tTitle(context, 'phone')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        }
                        else if (!phoneRegExp.hasMatch(value)) {
                          return tSentence(context, 'invalid_phoneNumber');
                        }
                      },
                      onSaved: (value) => this._phoneNumber = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._passwordFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      autofocus: false,
                      focusNode: this._passwordFocusNode,
                      obscureText: true,
                      controller: this._passwordController,
                      decoration: getMomdayInputDecoration(tTitle(context, 'password')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        } else if (value.length < 4 || value.length > 20) {
                          return tSentence(context, 'password_length');
                        }
                      },
                      onSaved: (value) => this._password = value,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(this._confirmPasswordFocusNode),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      focusNode: this._confirmPasswordFocusNode,
                      decoration: getMomdayInputDecoration(tTitle(context, 'confirm_password')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return tSentence(context, 'field_required');
                        } else if (value != this._passwordController.text) {
                          return tSentence(context, 'confirm_password_different');
                        }
                      },
                      onSaved: (value) => this._confirmPassword = value,
                    ),
                    SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.grey
                          ),
                          text: tSentence(context, 'by_submitting'),
                          children: [
                            TextSpan(
                                text: t(context, 'terms_of_service'),
                                style: TextStyle(
                                    color: MomdayColors.MomdayGold
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('terms of service');
                                  }
                            ),
                            TextSpan(
                                text: t(context, 'and')
                            ),
                            TextSpan(
                                text: t(context, 'privacy_policy'),
                                style: TextStyle(
                                    color: MomdayColors.MomdayGold
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('privacy policy');
                                  }
                            ),
                            TextSpan(
                                text: '.'
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: MomdayColors.MomdayGold,
                      child: this._isSigningUp?
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Theme(
                            data: ThemeData(
                                accentColor: Colors.white
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                        )
                      ) :
                        ListTile(
                          title: Text(
                            tSentence(context, 'sign_up'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                      onPressed: () => this._onSignUp(context)
                  ),
                  ],
                ),
              ),
            );
          }
        )
    );
  }

  _onSignUp(context) async {
    if (!this._isSigningUp) {
      if (this._formKey.currentState.validate()) {
        this._formKey.currentState.save();

        setState(() {
          this._isSigningUp = true;
        });

        String response = await AppStateManager.of(context).signup(
          this._firstName,
          this._lastName,
          this._email,
          this._dob,
          this._gender,
          this._phoneNumber,
          this._password,
          this._confirmPassword,
        );

        setState(() {
          this._isSigningUp = false;
        });

        print("response $response");
        if (response == 'success') {
          Navigator.pushReplacementNamed(context, '/');
        } else {
          showTextSnackBar(context, response.toString());
        }
      }
    }
  }
}