import 'package:discover/components/sign_up_form.dart';

import 'package:discover/layout/page_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageLayout(
        page: Padding(
            padding:  EdgeInsets.all(20), child: SignUpForm()));
  }
}
