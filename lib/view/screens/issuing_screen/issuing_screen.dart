import 'package:dashed_stepper/dashed_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/constants.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';

class IssuingScreen extends StatelessWidget {
  const IssuingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        hint: "Input WR",
                        onChanged: (p0) {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        hint: "Lokasi",
                        onChanged: (p0) {},
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: MainColor.brandColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: MainColor.getColor(0),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              vSpace(10),
              DashedStepper(
                indicatorColor: Colors.green,
                length: 3,
                step: 0,
                labelStyle: const TextStyle(color: Colors.black),
                labels: const ['Input\nWR', 'Issue\nFilled', 'Receive\nEmpty'],
              )
            ],
          ),
        ),
      ),
    );
  }
}
