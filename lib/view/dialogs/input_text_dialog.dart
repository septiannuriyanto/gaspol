import 'package:flutter/material.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';
import 'package:gaspol/view/utils/string_formatter.dart';

class InputTextDialog extends StatefulWidget {
  const InputTextDialog({
    super.key,
  });

  @override
  State<InputTextDialog> createState() => _InputTextDialogState();
}

class _InputTextDialogState extends State<InputTextDialog> {
  final inputTextController = TextEditingController();

  @override
  void dispose() {
    inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Material(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              textCapitalization: TextCapitalization.characters,
                              txtController: inputTextController,
                              autoFocus: true,
                              onFieldSubmitted: (p0) =>
                                  Navigator.pop(context, p0),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.send,
                                  size: 32,
                                  color: MainColor.brandColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(
                                    context, inputTextController.text);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
