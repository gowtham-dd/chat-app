// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:chattapp/constants.dart';
import 'package:chattapp/models/user_profile.dart';
import 'package:chattapp/services/alert_service.dart';
import 'package:chattapp/services/auth_service.dart';
import 'package:chattapp/services/database-service.dart';
import 'package:chattapp/services/media_service.dart';
import 'package:chattapp/services/navigation_service.dart';
import 'package:chattapp/services/storage_service.dart';
import 'package:chattapp/widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  bool isLoading = false;
  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  File? selectedImage;

  String? email, password, name;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Let's get going!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _pfpSelectionFiled(),
            CustomFormField(
                hintText: "Name",
                height: MediaQuery.sizeOf(context).height * 0.1,
                validationRegEx: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                }),
            CustomFormField(
                hintText: "Email",
                height: MediaQuery.sizeOf(context).height * 0.1,
                validationRegEx: EMAIL_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                }),
            CustomFormField(
                hintText: "Password",
                height: MediaQuery.sizeOf(context).height * 0.1,
                obscureText: true,
                validationRegEx: PASSWORD_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                }),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionFiled() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            File? file = await _mediaService.getImageFromGallery();
            if (file != null) {
              setState(() {
                selectedImage = file;
              });
            }
          },
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.15,
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
          ),
        ),
        SizedBox(height: 10), // Add some spacing
        Text(
          'Please set your profile picture',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (_registerFormKey.currentState?.validate() ?? false) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpURL;
                if (selectedImage != null) {
                  pfpURL = await _storageService.uploadUserPfp(
                      file: selectedImage!, uid: _authService.user!.uid);
                }
                await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                        uid: _authService.user!.uid,
                        name: name,
                        pfpURL: pfpURL));

                _navigationService.pushReplacementNamed("/home");

                _alertService.showToast(
                    text: "Registration Successful!", icon: Icons.check);
              }
              print(result);
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              if (e.code == 'email-already-in-use') {
                // Email is already in use
                _alertService.showToast(
                    text: "Email already in use, please try again!",
                    icon: Icons.error);
              } else {
                // Other FirebaseAuth related errors
                _alertService.showToast(
                    text: "Registration failed, please try again!",
                    icon: Icons.error);
              }
            } else {
              // Other non-auth related errors
              _alertService.showToast(
                  text: "Registration failed, please try again!",
                  icon: Icons.error);
            }
            print(e);
          }

          setState(() {
            isLoading = false;
          });
        },
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Allready have an account?"),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: Text(
              "Log In",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
