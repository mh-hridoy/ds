import 'package:discover/components/text_input.dart';
import 'package:discover/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  FormGroup form() => FormGroup({
        "fullname": FormControl(
          validators: [Validators.required, Validators.minLength(5)],
        ),
        "email": FormControl(
          validators: [Validators.required, Validators.email],
        ),
        "password": FormControl(
          validators: [Validators.required, Validators.minLength(5)],
        )
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: form,
        builder: (context, form, child) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text("Let's create your account."),
                  const SizedBox(
                    height: 30,
                  ),
                  AppTextInput(
                    label: "Full Name",
                    placeHolder: "Enter your full name",
                    formControlName: "fullname",
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          "Please enter a valid name!",
                      ValidationMessage.minLength: (error) =>
                          "Fullname requires at least 5char!"
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppTextInput(
                    label: "Email",
                    placeHolder: "Enter your email address",
                    inputType: TextInputType.emailAddress,
                    formControlName: "email",
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          "Please enter a valid email!",
                      ValidationMessage.email: (error) =>
                          "Please enter a valid email!"
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppTextInput(
                    label: "Password",
                    placeHolder: "Enter your password",
                    isPassword: true,
                    enableSuggestions: false,
                    formControlName: "password",
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          "Please enter a valid password!",
                      ValidationMessage.minLength: (error) =>
                          "A valid password is required at least 8char!"
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "By signing up you agree to our ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Terms, Privacy Policy,",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text: " and ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: "Cookie Use",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                  ])),
                  const SizedBox(
                    height: 16,
                  ),
                  ReactiveFormConsumer(
                      builder: (context, form, child) => SizedBox(
                            width: 370,
                            height: 56,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: form.valid
                                        ? MaterialStateProperty.all(
                                            AppColor.baseColor900)
                                        : MaterialStateProperty.all(
                                            AppColor.baseColor200)),
                                onPressed: () {
                                  print(form.valid);
                                },
                                child: Text("Create An Account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: AppColor.baseColor,
                                            fontWeight: FontWeight.w400))),
                          )),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: .5,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        "Or",
                      ),
                      Expanded(
                          child: Divider(
                        thickness: .5,
                        indent: 10,
                        endIndent: 25,
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 56,
                    width: 370,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.inversePrimary)),
                        onPressed: () {},
                        icon: const Icon(FontAwesome.google),
                        label: const Text("Sign Up with Google")),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 56,
                    width: 370,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppColor.secondaryColor)),
                        onPressed: () {},
                        icon: const Icon(FontAwesome.facebook_official),
                        label: const Text("Sign Up with Facebook")),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Already have an account?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: " Log In",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ));
  }
}
