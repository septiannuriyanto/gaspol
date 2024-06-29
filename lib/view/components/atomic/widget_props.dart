import 'package:flutter/material.dart';
import 'package:gaspol/view/components/themes/constants.dart';

Radius kDefaultBorderRadius = Radius.circular(kDefaultRadius);
BorderRadius kDefaultBorderRadiusAll = BorderRadius.all(kDefaultBorderRadius);

//SPACING
vSpace(double space) {
  return SizedBox(
    height: space,
  );
}

cWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

cHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

EdgeInsets kDefaultEdgeInsets = EdgeInsets.all(kDefaultPadding);

//BOX SHADOWS
//REFERENCE : https://x.com/romashkin_dev/status/1431935031749062657

BoxShadow kDefaultBoxShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.16),
    offset: Offset(0, 1),
    blurRadius: 4,
    spreadRadius: 0);

BoxShadow kSpreadBoxShadow = BoxShadow(
    color: Color.fromRGBO(17, 12, 46, 0.15),
    offset: Offset(0, 48),
    blurRadius: 100,
    spreadRadius: 0);
