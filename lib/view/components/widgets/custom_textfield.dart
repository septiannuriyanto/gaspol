import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';

class CustomTextField extends StatelessWidget {
  void Function(String)? onChanged;
  void Function()? onTap;
  void Function(String)? onFieldSubmitted;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? hint;
  bool? enable;
  bool? readonly;
  TextEditingController? txtController;
  bool? autoFocus;
  List<TextInputFormatter>? inputFormatters;
  TextCapitalization? textCapitalization;

  CustomTextField({
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.hint,
    this.enable,
    this.readonly,
    this.onTap,
    this.txtController,
    this.autoFocus,
    super.key,
    this.inputFormatters,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [],
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      autofocus: autoFocus ?? false,
      controller: txtController,
      readOnly: readonly ?? false,
      enabled: enable,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MainColor.getColor(1)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MainColor.brandColor),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
    );
  }
}
