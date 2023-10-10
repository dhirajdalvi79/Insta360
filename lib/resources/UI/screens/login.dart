import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../interfaces/user_auth_repository.dart';
import '../../../screen_size.dart';
import '../../utilities/constants.dart';
import '../widgets/mybutton.dart';
import '../widgets/text_field.dart';

/// Login screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreenBody(),
    );
  }
}

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({Key? key}) : super(key: key);

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  // Controller for email.
  late TextEditingController myEmailNameController;

  // Controller for password.
  late TextEditingController myPasswordController;

  @override
  void initState() {
    super.initState();
    myEmailNameController = TextEditingController();
    myPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    myEmailNameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initializing media query.
    final screen = ScreenSizeConfig.screen(context: context);
    // Setting text field width.
    double textFieldWidth = screen.textInputWidth;
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo
              SizedBox(
                  width: 210, child: Image.asset('assets/images/1025.png')),
              // Text field for email.
              MyTextField(
                myFieldController: myEmailNameController,
                myHintText: 'Email',
                myLabelText: 'Email',
                myWidth: textFieldWidth,
                myKeyboardInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              // Text field for password.
              MyTextField(
                myFieldController: myPasswordController,
                myObscureText: true,
                myHintText: 'password',
                myLabelText: 'password',
                myWidth: textFieldWidth,
                myKeyboardInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                onButtonPressed: () async {
                  // Initializing user authentication method.
                  UserAuthenticationRepository obj =
                      UserAuthenticationRepository();
                  // Login user.
                  String result = await obj.userLogin(
                      getEmail: myEmailNameController.text,
                      getPassword: myPasswordController.text);
                  if (!mounted) return;
                  if (result == 'Success') {
                    // If success, open main screen with logged in user's data.
                    context.goNamed(mainScreen);
                  }
                },
                buttonText: 'Log In',
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      // To the sign up page.
                      context.goNamed(signup);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
