import 'package:cloaky/models/generic_dialog_message.dart';
import 'package:cloaky/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

const _color = Color(0xff2b1a30);

class MessageDialog extends StatelessWidget {
  const MessageDialog({super.key, required this.message});

  final GenericDialogMessage message;

  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      builder: (key) {
        return Container(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: (70.0, 60.0).resolve,
                width: (70.0, 60.0).resolve,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/colorful_ghost.jpeg"),
                  ),
                ),
              ),
              SizedBox(
                height: (30.0, 15.0).resolve,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (30.0, 20.0).resolve,
                  vertical: (20.0, 10.0).resolve,
                ),
                width: (
                  MediaQuery.of(context).size.width * .5,
                  MediaQuery.of(context).size.width * .65
                ).resolve,
                height: (
                  MediaQuery.of(context).size.height * .3,
                  MediaQuery.of(context).size.height * .35,
                ).resolve,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0, 10.0).resolve),
                  color: _color,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      message.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        color: Colors.white.withOpacity(.8),
                        fontWeight: FontWeight.w400,
                        fontSize: (18.0, 14.0).resolve,
                      ),
                    ),
                    SizedBox(
                      height: (48.0, 32.0).resolve,
                    ),
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
                          DialogManager.of(context).dismissDialog();
                        },
                        child: Text(
                          message.buttonText,
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
            ],
          ),
        );
      },
    );
  }
}
