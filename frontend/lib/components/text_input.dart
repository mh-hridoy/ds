import 'dart:ui';

import 'package:discover/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTextInput extends StatefulWidget {
  final String label;
  final String placeHolder;
  final TextInputType inputType;
  final bool isPassword;
  final bool enableSuggestions;
  final String formControlName;
  final Map<String, String Function(Object)> validationMessages;

  const AppTextInput({
    super.key,
    required this.label,
    required this.placeHolder,
    required this.formControlName,
     this.validationMessages = const {},
    this.isPassword = false,
    this.enableSuggestions = true,
    this.inputType = TextInputType.text,
  });

  @override
  _AppTextInputState createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  void togglePassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(
        height: 8,
      ),
      ReactiveTextField(
        key: Key(widget.formControlName),
        validationMessages: widget.validationMessages,
        formControlName: widget.formControlName,
        keyboardType: widget.inputType,
        obscureText: obscureText,
        autocorrect: false,
        enableSuggestions: widget.enableSuggestions,
        style: Theme.of(context).textTheme.headlineSmall,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,
        selectionControls: MaterialTextSelectionControls(),
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        decoration: InputDecoration(
          errorStyle: const TextStyle(height: .5 ),
          suffixIcon:  widget.isPassword
                ? IconButton(
                    onPressed: togglePassword,
                    iconSize: 22,
                    icon: Icon(
                        obscureText ? AntDesign.eyeo : CupertinoIcons.eye_slash),
                  )
                : null,

          constraints: const BoxConstraints(
            maxWidth: 370,
          ),
          alignLabelWithHint: true,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: widget.placeHolder,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColor.baseColor200)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColor.baseColor200)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColor.baseColor200)),
        ),
      ),
    ]);
  }
}