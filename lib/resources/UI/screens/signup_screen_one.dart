import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta360/resources/UI/screens/signup_screen_two.dart';

import 'package:provider/provider.dart';

import '../../../bussiness_logic/providers/profile_image_state.dart';
import '../../../screen_size.dart';
import '../../utilities/constants.dart';
import '../widgets/dialogs.dart';
import '../widgets/mybutton.dart';
import '../widgets/text_field.dart';

/// Display first screen in sign up process.
class SignUpScreenOne extends StatelessWidget {
  const SignUpScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpBodyOne(),
    );
  }
}

class SignUpBodyOne extends StatefulWidget {
  const SignUpBodyOne({Key? key}) : super(key: key);

  @override
  State<SignUpBodyOne> createState() => _SignUpBodyOneState();
}

class _SignUpBodyOneState extends State<SignUpBodyOne> {
  // Controller for first name
  late TextEditingController firstNameController;

  // Controller for last name
  late TextEditingController lastNameController;

  // Controller for email.
  late TextEditingController emailController;

  // Setting global key for input validation.
  final formKeySignUpOne = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
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
                key: formKeySignUpOne,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // Consuming profile image selector provider.
                        Consumer<ProfileImageSelector>(
                            builder: (context, obj, __) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: iconSize / 2),
                            // Circle avatar for displaying selected profile image.
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: screen.screenWidth * 0.20,
                                backgroundImage: obj.imageBytes != null
                                    ? MemoryImage(obj.imageBytes!)
                                    : const AssetImage(
                                        'assets/images/default_user_profile_pic.jpg',
                                      ) as ImageProvider),
                          );
                        }),
                        Positioned(
                            //Evaluation for fixing icon at centre
                            left: (screen.screenWidth * 0.20) - iconSize / 2,
                            //right: screen.screenWidth * 0.15,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Returns dialog for selecting image source for profile image upload.
                                      return const ImageSourceSelectorDialog();
                                    });
                              },
                              child: const Icon(
                                Icons.add_a_photo_sharp,
                                size: iconSize,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Text field for first name.
                    MyTextField(
                        myFieldController: firstNameController,
                        myKeyboardInputType: TextInputType.text,
                        myHintText: 'First Name',
                        myLabelText: 'First Name',
                        myWidth: textFieldWidth),
                    const SizedBox(
                      height: 20,
                    ),
                    // Text field for last name.
                    MyTextField(
                        myFieldController: lastNameController,
                        myKeyboardInputType: TextInputType.text,
                        myHintText: 'Last Name',
                        myLabelText: 'Last Name',
                        myWidth: textFieldWidth),
                    const SizedBox(
                      height: 20,
                    ),
                    // Text field for email.
                    MyTextField(
                        myFieldController: emailController,
                        myKeyboardInputType: TextInputType.emailAddress,
                        myHintText: 'Email',
                        myLabelText: 'Email',
                        myWidth: textFieldWidth),
                    const SizedBox(
                      height: 30,
                    ),
                    MyButton(
                        buttonText: 'Next  ➔',
                        onButtonPressed: () {
                          // Gets form state for validation.
                          final form = formKeySignUpOne.currentState!;
                          if (form.validate()) {
                            // If validated, opens the next sign up screen with input information as passed arguments.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreenTwo(
                                        getFirstName: firstNameController.text,
                                        getLastName: lastNameController.text,
                                        getEmail: emailController.text,
                                      )),
                            );
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have an account?'),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Opens log in screen.
                            context.goNamed(login);
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
