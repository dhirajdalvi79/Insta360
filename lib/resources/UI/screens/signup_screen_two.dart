import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../bussiness_logic/providers/profile_image_state.dart';
import '../../../interfaces/user_auth_repository.dart';
import '../../../screen_size.dart';
import '../../utilities/constants.dart';
import '../widgets/mybutton.dart';
import '../widgets/text_field.dart';

/// Display second screen in sign up process.
class SignUpScreenTwo extends StatelessWidget {
  const SignUpScreenTwo({
    Key? key,
    required this.getFirstName,
    required this.getLastName,
    required this.getEmail,
  }) : super(key: key);
  final String getFirstName;
  final String getLastName;
  final String getEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpBodyTwo(
        firstName: getFirstName,
        lastName: getLastName,
        email: getEmail,
      ),
    );
  }
}

class SignUpBodyTwo extends StatefulWidget {
  const SignUpBodyTwo({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final String email;

  @override
  State<SignUpBodyTwo> createState() => _SignUpBodyTwoState();
}

class _SignUpBodyTwoState extends State<SignUpBodyTwo> {
  // Controller for username
  late TextEditingController usernameController;

  // Controller for password
  late TextEditingController passwordController;

  // Controller for date
  late TextEditingController dateController;

  // Setting global key of second screen for input validation.
  final formKeySignUpTwo = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    dateController = TextEditingController();
  }

  // Returns formatted date from string.
  DateTime getDateTimeFromString({required String data}) {
    List stringList = data.split(' ');
    DateTime convertedDate = DateTime(int.parse(stringList[0]),
        toNumericalMonthValue[stringList[1]]!, int.parse(stringList[2]));
    return convertedDate;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initializing media query.
    final screen = ScreenSizeConfig.screen(context: context);
    // Setting text field width.
    double textFieldWidth = screen.textInputWidth;
    return SafeArea(
        child: Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          // Setting form widget with global key.
          child: Form(
            key: formKeySignUpTwo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text field for username.
                MyTextField(
                    myFieldController: usernameController,
                    myKeyboardInputType: TextInputType.text,
                    myHintText: 'Username',
                    myLabelText: 'Username',
                    myWidth: textFieldWidth),
                const SizedBox(
                  height: 20,
                ),
                // Text field for password.
                MyTextField(
                  myFieldController: passwordController,
                  myKeyboardInputType: TextInputType.visiblePassword,
                  myHintText: 'Password',
                  myLabelText: 'Password',
                  myWidth: textFieldWidth,
                  myObscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Text field for date.
                MyTextField(
                  myFieldController: dateController,
                  myKeyboardInputType: TextInputType.datetime,
                  myHintText: 'Date',
                  myLabelText: 'Date',
                  myWidth: textFieldWidth,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                    buttonText: 'Sign Up',
                    onButtonPressed: () async {
                      // Gets form state for validation.
                      final form = formKeySignUpTwo.currentState!;
                      if (form.validate()) {
                        // If validated,
                        // Gets formatted date from string.
                        DateTime getDate =
                            getDateTimeFromString(data: dateController.text);
                        // Initializing user authentication methods.
                        final obj = UserAuthenticationRepository();
                        // Gets selected profile image.
                        final selectImageObj =
                            context.read<ProfileImageSelector>();
                        // Sign up the new user with provided input information.
                        String result = await obj.userSignUp(
                            getUserName: usernameController.text,
                            getPassword: passwordController.text,
                            getEmail: widget.email,
                            getFirstName: widget.firstName,
                            getLastName: widget.lastName,
                            getProfilePic: selectImageObj.imageBytes,
                            getDateOfBirth: Timestamp.fromDate(getDate));
                        if (!mounted) return;
                        if (result == "Success") {
                          // If success, open main screen with signed up user's data.
                          context.goNamed(mainScreen);
                        }
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
