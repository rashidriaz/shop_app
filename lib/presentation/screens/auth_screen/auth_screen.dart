import 'package:flutter/material.dart';
import 'package:shop_app/presentation/screens/auth_screen/widgets/auth_card.dart';
import '../../widgets/main_logo.dart' as app_logo;

class AuthScreen extends StatelessWidget {
  static const routeName = './auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              app_logo.MainLogo(),
              SizedBox(
                height: 20,
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
