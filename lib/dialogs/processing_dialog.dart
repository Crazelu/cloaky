import 'package:cloaky/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

const _color = Color(0xff2b1a30);

class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      builder: (key) {
        return Container(
          key: key,
          child: Column(
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
                  MediaQuery.of(context).size.width * .4,
                  MediaQuery.of(context).size.width * .55
                ).resolve,
                height: (
                  MediaQuery.of(context).size.height * .25,
                  MediaQuery.of(context).size.height * .18,
                ).resolve,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0, 10.0).resolve),
                  color: _color,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Your request is processing.\nThis should only take a moment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontWeight: FontWeight.w400,
                        fontSize: (18.0, 14.0).resolve,
                      ),
                    ),
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
