import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../helpers/constants.dart' as app_constants;

class EmptyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           SvgPicture.asset(app_constants.noData, height: 160, width: 80,),
          SizedBox(height: 20,),
          Text("Nothing to show here!", style: Theme.of(context).textTheme.subtitle1,),
        ],
      ),
    );
  }
}