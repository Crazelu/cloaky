import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloaky/dialogs/dialog_route_generator.dart';
import 'package:cloaky/models/generic_dialog_message.dart';
import 'package:cloaky/models/hide_message_request.dart';
import 'package:cloaky/widgets/footer.dart';
import 'package:cloaky/widgets/responsive_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:steganograph/steganograph.dart';
import 'package:universal_html/html.dart' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _selectedImageBytes;
  String _imageExtension = "";

  void _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!["image/png", "image/jpeg"].contains(image.mimeType)) {
        DialogManager.of(context).showDialog(
          routeName: DialogRoutes.message,
          arguments: const GenericDialogMessage(
            message:
                "FML 😭\nDo you even read?\nOnly PNG and JPEG images are supported.",
          ),
        );

        if (_selectedImageBytes != null) {
          _resetState();
        }
        return;
      }

      if (!_checkImageSize(await image.length())) {
        if (_selectedImageBytes != null) {
          _resetState();
        }
        return;
      }
      _selectedImageBytes = await image.readAsBytes();
      _imageExtension = image.mimeType!.split("/").last;
      setState(() {});
    }
  }

  bool _checkImageSize(int size) {
    if (size <= 2000000) {
      return true;
    }

    DialogManager.of(context).showDialog(
      routeName: DialogRoutes.message,
      arguments: const GenericDialogMessage(
        message:
            "I won't blame you this time.\nThis one is hard for not-so-smart people.\nMake sure your image size doesn't exceed 2MB 🙂",
      ),
    );
    return false;
  }

  void _resetState() {
    setState(() {
      _imageExtension = "";
      _selectedImageBytes = null;
    });
  }

  ///Ensures image is a png to take advantage of the tEXt chunk.
  ///Encodes to png if necessary.
  Future<Uint8List?> _encodeToPng(Uint8List bytes) async {
    try {
      switch (_imageExtension) {
        case "png":
          return bytes;
        case "jpg":
        case "jpeg":
          final jpgImage = im.decodeJpg(bytes);
          final size = ImageSizeGetter.getSize(MemoryInput(bytes));

          final img = im.Image.fromBytes(
            size.width,
            size.height,
            jpgImage!.getBytes(),
          );

          final pngBytes = im.encodePng(img);

          return Uint8List.fromList(pngBytes);
      }
    } catch (e, trace) {
      print(e);
      print(trace);
    }
    return null;
  }

  Future<bool> _embedMessage(HideMessageRequest request) async {
    try {
      final imageBytes = await _encodeToPng(_selectedImageBytes!);

      final bytes = await Steganograph.encodeBytes(
        bytes: imageBytes!,
        message: request.message,
        encryptionKey: request.password,
      );
      if (bytes == null) {
        return false;
      }
      _downloadImage(bytes);
      return true;
    } catch (e, trace) {
      print(e);
      print(trace);
      return false;
    }
  }

  void _downloadImage(Uint8List bytes) {
    var blob = html.Blob([bytes], 'image/png');
    html.AnchorElement()
      ..href = html.Url.createObjectUrlFromBlob(blob).toString()
      ..download =
          'Cloaky-${DateTime.now().toIso8601String().replaceAll(RegExp(r':'), '-')}.png'
      ..style.display = 'none'
      ..click();
  }

  Future<String?> _decodeMessage(String password) async {
    try {
      if (_imageExtension != "png") return null;

      return await Steganograph.decodeBytes(
        bytes: _selectedImageBytes!,
        encryptionKey: password,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _onMessageEmbedded(Object? value) {
    DialogManager.of(context).dismissDialog();

    if (value == null || value is bool && !value) {
      DialogManager.of(context).showDialog(
        routeName: DialogRoutes.message,
        arguments: const GenericDialogMessage(
          message:
              "Cloaky was unable to embed your secret message in the image",
          buttonText: "Got it",
        ),
      );
      return;
    }

    if (value is bool) {
      _resetState();
      DialogManager.of(context).showDialog(
        routeName: DialogRoutes.message,
        arguments: const GenericDialogMessage(
          message:
              "Cloaky has hidden your secret message in the image 🙃\nThe cloaked image has been downloaded to your device.\nShare with your friends!",
          buttonText: "Got it",
        ),
      );
    }
  }

  void _onMessageDecoded(Object? value) {
    DialogManager.of(context).dismissDialog();

    if (value == null || value is String && value.isEmpty) {
      DialogManager.of(context).showDialog(
        routeName: DialogRoutes.message,
        arguments: const GenericDialogMessage(
          message: "Cloaky didn't find any secret message in your image",
          buttonText: "Got it",
        ),
      );
      return;
    }
    if (value is String) {
      DialogManager.of(context).showDialog(
        routeName: DialogRoutes.message,
        arguments: GenericDialogMessage(
          message: "Here's your secret message 🤗👇\n$value",
          buttonText: "Got it",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: (20.0, 20.0).resolve) +
            EdgeInsets.only(bottom: (10.0, 5.0).resolve),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const MouseDraggableScrollBehavior(),
                child: ListView(
                  children: [
                    SizedBox(
                      height: (20.0, 10.0).resolve,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo.jpeg",
                          height: (50.0, 40.0).resolve,
                          width: (50.0, 40.0).resolve,
                        ),
                        Text(
                          "Cloaky",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: (30.0, 20.0).resolve,
                          ),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                            fontSize: (30.0, 20.0).resolve,
                          ),
                        ),
                        SizedBox(
                          width: (8.0, 4.0).resolve,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: (4.0, 2.0).resolve,
                            ),
                            Row(
                              children: [
                                Text(
                                  "A new kind of",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: (22.0, 18.0).resolve,
                                  ),
                                ),
                                SizedBox(
                                  width: (4.0, 2.0).resolve,
                                ),
                                AnimatedTextKit(
                                  repeatForever: true,
                                  pause: const Duration(milliseconds: 1600),
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'secrecy',
                                      speed: const Duration(milliseconds: 250),
                                      textStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: (22.0, 18.0).resolve,
                                      ),
                                    ),
                                    TyperAnimatedText(
                                      'fun',
                                      speed: const Duration(milliseconds: 120),
                                      textAlign: TextAlign.center,
                                      textStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: (22.0, 18.0).resolve,
                                      ),
                                    ),
                                    TyperAnimatedText(
                                      'privacy',
                                      speed: const Duration(milliseconds: 120),
                                      textAlign: TextAlign.center,
                                      textStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: (22.0, 18.0).resolve,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (20.0, 10.0).resolve,
                    ),
                    Text(
                      "Hide secret messages for your friends in images 🫣",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: (24.0, 18.0).resolve,
                      ),
                    ),
                    SizedBox(
                      height: (50.0, 30.0).resolve,
                    ),
                    Align(
                      alignment:
                          (Alignment.center, Alignment.centerLeft).resolve,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _pickImage,
                        child: Container(
                          width: (size.width * .5, size.width).resolve,
                          height: (size.height * .45, size.height * .5).resolve,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular((20.0, 10.0).resolve),
                            border: Border.all(color: Colors.grey.shade300),
                            image: _selectedImageBytes == null
                                ? null
                                : DecorationImage(
                                    image: MemoryImage(_selectedImageBytes!),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          child: _selectedImageBytes != null
                              ? null
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: (50.0, 30.0).resolve,
                                        color: Colors.grey.shade500,
                                      ),
                                      SizedBox(
                                        height: (12.0, 8.0).resolve,
                                      ),
                                      Text(
                                        "Upload image",
                                        style: TextStyle(
                                          fontSize: (16.0, 14.0).resolve,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      SizedBox(
                                        height: (4.0, 2.0).resolve,
                                      ),
                                      Text(
                                        "Max 2MB\n[Only PNG and JPEG images are supported]",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: (14.0, 12.0).resolve,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (_selectedImageBytes != null) ...{
                      SizedBox(
                        height: (30.0, 15.0).resolve,
                      ),
                      Align(
                        child: OutlinedButton.icon(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide.none),
                          ),
                          onPressed: _pickImage,
                          icon: const Icon(Icons.refresh_outlined),
                          label: const Text("Replace Image"),
                        ),
                      ),
                    },
                    SizedBox(
                      height: (48.0, 32.0).resolve,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_selectedImageBytes == null) {
                              DialogManager.of(context).showDialog(
                                routeName: DialogRoutes.message,
                                arguments: const GenericDialogMessage(
                                  message:
                                      "Sighs\nUpload a friggin image to continue 🙄",
                                ),
                              );
                              return;
                            }

                            DialogManager.of(context)
                                .showDialog(
                              routeName: DialogRoutes.hideMessage,
                            )
                                .then(
                              (value) async {
                                if (value is HideMessageRequest) {
                                  DialogManager.of(context).showDialog(
                                    routeName: DialogRoutes.processing,
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 400),
                                  );
                                  _embedMessage(value).then(_onMessageEmbedded);
                                }
                              },
                            );
                          },
                          child: Text(
                            "Hide Message",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: (16.0, 14.0).resolve,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (50.0, 30.0).resolve,
                        ),
                        TextButton(
                          onPressed: () {
                            if (_selectedImageBytes == null) {
                              DialogManager.of(context).showDialog(
                                routeName: DialogRoutes.message,
                                arguments: const GenericDialogMessage(
                                  message:
                                      "Just look at you 🤦\nUpload a friggin image to continue!",
                                ),
                              );
                              return;
                            }
                            DialogManager.of(context)
                                .showDialog(
                              routeName: DialogRoutes.revealMessage,
                            )
                                .then(
                              (value) async {
                                if (value is String) {
                                  DialogManager.of(context).showDialog(
                                    routeName: DialogRoutes.processing,
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 400),
                                  );
                                  _decodeMessage(value).then(_onMessageDecoded);
                                }
                              },
                            );
                          },
                          child: Text(
                            "Reveal Message",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: (16.0, 14.0).resolve,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}

class MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  const MouseDraggableScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
