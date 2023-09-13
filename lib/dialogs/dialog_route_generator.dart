import 'package:cloaky/dialogs/message_dialog.dart';
import 'package:cloaky/dialogs/hide_message_dialog.dart';
import 'package:cloaky/dialogs/processing_dialog.dart';
import 'package:cloaky/dialogs/reveal_message_dialog.dart';
import 'package:cloaky/models/generic_dialog_message.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

class DialogRouteGenerator {
  static Widget? onGenerateDialog(DialogSettings settings) {
    return switch (settings.name) {
      == DialogRoutes.hideMessage => const HideMessageDialog(),
      == DialogRoutes.revealMessage => const RevealMessageDialog(),
      == DialogRoutes.processing => const ProcessingDialog(),
      == DialogRoutes.message => MessageDialog(
          message: settings.arguments as GenericDialogMessage,
        ),
      _ => null,
    };
  }
}

class DialogRoutes {
  static const hideMessage = "/hideMessage";
  static const revealMessage = "/revealMessage";
  static const message = "/message";
  static const processing = "/processing";
}
