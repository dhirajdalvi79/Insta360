import 'package:flutter/material.dart';
import 'package:insta360/bussiness_logic/providers/progress_indicator_status.dart';
import 'package:insta360/resources/utilities/colors.dart';
import 'package:provider/provider.dart';

/// TODO: Implement circular progress indicator.
class CircularProgressBar extends StatelessWidget {
  const CircularProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200,
        child: Consumer<ProgressIndicatorStatus>(
          builder: (context, obj, __) {
            return CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: primaryColor,
              semanticsValue: obj.valuePercentage,
              value: obj.value,
            );
          },
        ),
      ),
    );
  }
}
