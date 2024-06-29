import 'package:flutter/material.dart';

class FakeTextField extends StatelessWidget {
  const FakeTextField({
    this.caption,
    this.height,
    this.radius,
    this.onPress,
    this.fillColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
    this.readOnly,
    super.key,
  });

  final double? height;
  final String? caption;
  final Color? fillColor;
  final Color? borderColor;
  final double? radius;
  final void Function()? onPress;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? iconColor;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.maxFinite,
        height: height ?? 36,
        decoration: BoxDecoration(
            color: fillColor ?? Colors.white,
            border: Border.all(color: borderColor ?? Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 8))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              prefixIcon == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        size: 18,
                        prefixIcon,
                        color: iconColor ?? Colors.grey,
                      ),
                    ),
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  caption ?? "",
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: readOnly == true ? null : onPress,
    );
  }
}
