import 'package:cloaky/widgets/custom_text_field.dart';
import 'package:cloaky/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

const _color = Color(0xff2b1a30);

class RevealMessageDialog extends StatefulWidget {
  const RevealMessageDialog({super.key});

  @override
  State<RevealMessageDialog> createState() => _RevealMessageDialogState();
}

class _RevealMessageDialogState extends State<RevealMessageDialog> {
  final _messageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      builder: (key) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            key: key,
            child: Column(
              children: [
                Container(
                  height: (70.0, 80.0).resolve,
                  width: (70.0, 80.0).resolve,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/happy_ghost.jpeg"),
                    ),
                  ),
                ),
                SizedBox(
                  height: (30.0, 15.0).resolve,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (30.0, 20.0).resolve,
                      vertical: (40.0, 20.0).resolve,
                    ),
                    width: (
                      MediaQuery.of(context).size.width * .4,
                      MediaQuery.of(context).size.width * .85
                    ).resolve,
                    height: (
                      MediaQuery.of(context).size.height * .4,
                      MediaQuery.of(context).size.height * .3,
                    ).resolve,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((20.0, 10.0).resolve),
                      color: _color,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        CustomTextField(
                          controller: _passwordController,
                          hint: "Enter password",
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: (8.0, 4.0).resolve,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "* ",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: (16.0, 14.0).resolve,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Ask your friend for a password to read secret message 🤭",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.7),
                                  fontSize: (14.0, 12.0).resolve,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 2),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(.9),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _color.withOpacity(.7),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                DialogManager.of(context)
                                    .dismissDialog(_passwordController.text);
                              }
                            },
                            child: Text(
                              "Reveal Message",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: (16.0, 14.0).resolve,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
