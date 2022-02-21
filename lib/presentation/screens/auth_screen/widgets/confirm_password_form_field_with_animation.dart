import 'package:flutter/material.dart';
import '../../../../modals/auth_mode.dart';

class ConfirmPasswordFormFieldWithAnimation extends StatelessWidget {
  final AuthMode authMode;
  final Animation<Offset> slideAnimation;
  final Animation<double> opacityAnimation;
  final Function getPassword;

  ConfirmPasswordFormFieldWithAnimation(
      {@required this.authMode,
      @required this.slideAnimation,
      @required this.opacityAnimation,
      @required this.getPassword});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      constraints: BoxConstraints(
          minHeight: (authMode == AuthMode.SIGNUP) ? 60.0 : 0.0,
          maxHeight: (authMode == AuthMode.SIGNUP) ? 120.0 : 0.0),
      child: FadeTransition(
        opacity: opacityAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: TextFormField(
            enabled: authMode == AuthMode.SIGNUP,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: authMode == AuthMode.SIGNUP
                // ignore: missing_return
                ? (value) {
                    if (value != getPassword()) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
