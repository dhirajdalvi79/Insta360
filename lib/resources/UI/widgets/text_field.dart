import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utilities/colors.dart';

/// Reusable custom TextField.
class MyTextField extends StatefulWidget {
  const MyTextField(
      {Key? key,
      required this.myFieldController,
      required this.myKeyboardInputType,
      required this.myHintText,
      required this.myLabelText,
      required this.myWidth,
      this.myObscureText = false,
      this.myIcon})
      : super(key: key);

  final TextEditingController myFieldController;
  final TextInputType myKeyboardInputType;
  final String myHintText;
  final String myLabelText;
  final double myWidth;
  final bool myObscureText;
  final Widget? myIcon;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  // Bool for password obscurity on text field.
  late bool passwordObscurity;

  @override
  void initState() {
    super.initState();
    passwordObscurity = widget.myObscureText;
  }

  // Toggles between password obscurity.
  void changePasswordObscurity() {
    if (passwordObscurity == true) {
      setState(() {
        passwordObscurity = false;
      });
    } else if (passwordObscurity == false) {
      setState(() {
        passwordObscurity = true;
      });
    }
  }

  String? get errorText {
    final text = widget.myFieldController.text;
    if (text.isNotEmpty) {
      if (widget.myKeyboardInputType == TextInputType.emailAddress) {
        if (!text.contains('@')) {
          return 'Put Valid Email';
        }
      } else if (widget.myKeyboardInputType == TextInputType.visiblePassword) {
        if (text.length < 7) {
          return 'Password should be more than 7 characters';
        }
      }
    } else {
      return '${widget.myLabelText} Can\'t Be Empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.myWidth,
      child: TextFormField(
        // Validator for text field.
        validator: (value) {
          // Checks if input type is text.
          if (widget.myKeyboardInputType == TextInputType.text) {
            // If input type is text, then text string should not be empty or null.
            if (value != null && value.isEmpty) {
              return 'Enter ${widget.myLabelText}';
            }
            // Checks if input type is date time.
          } else if (widget.myKeyboardInputType == TextInputType.datetime) {
            // If input type is date time, then it should not be empty or null.
            if (value != null && value.isEmpty) {
              return 'Enter ${widget.myLabelText}';
            }
            // Checks if input type is email.
          } else if (widget.myKeyboardInputType == TextInputType.emailAddress) {
            // Checks if email is not null and is not empty.
            if (value != null && value.isNotEmpty) {
              // If email is not null and is not empty, then it should have following pattern for valid email.
              if (!RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)) {
                return 'Enter Valid Email';
              }
              // If email is not null and empty, it returns obvious message of 'Enter Email'.
            } else if (value != null && value.isEmpty) {
              return 'Enter Email';
            }
            // Checks if input type is password.
          } else if (widget.myKeyboardInputType ==
              TextInputType.visiblePassword) {
            // Checks if password is not null and is not empty.
            if (value != null && value.isNotEmpty) {
              // If password is not null and not empty, then password should be greater than 7 character length.
              if (value.length < 7) {
                return 'Password should be more than 7 characters';
              }
              // If password is not null and empty, it returns 'Enter Password' message.
            } else if (value != null && value.isEmpty) {
              return 'Enter Password';
            }
          }
          return null;
        },

        controller: widget.myFieldController,
        keyboardType: widget.myKeyboardInputType,
        obscureText: passwordObscurity,
        style: const TextStyle(
          height: 0.9,
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(width: 2, color: Colors.purpleAccent)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 2, color: Colors.red)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(width: 2, color: Colors.purpleAccent)),
          border: InputBorder.none,
          hintText: widget.myHintText,
          labelText: widget.myLabelText,
          // Shows suffix icon for password obscurity.
          suffixIcon:
              widget.myKeyboardInputType == TextInputType.visiblePassword
                  ? GestureDetector(
                      onTap: changePasswordObscurity,
                      child: const Icon(Icons.remove_red_eye_outlined))
                  : null,
          icon: widget.myIcon,
          //errorText: _errorText,
        ),
        // Sets text field to read only if input type is date time.
        readOnly: widget.myKeyboardInputType == TextInputType.datetime,
        onTap: () async {
          if (widget.myKeyboardInputType == TextInputType.datetime) {
            // If input type is date time, it shows date picker dialog to pick date.
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1985),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat().add_d().add_MMMM().add_y().format(pickedDate);
              widget.myFieldController.value =
                  TextEditingValue(text: formattedDate);
            }
          }
        },
      ),
    );
  }
}
