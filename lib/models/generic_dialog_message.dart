class GenericDialogMessage {
  final String message;
  final String buttonText;

  const GenericDialogMessage({
    required this.message,
    this.buttonText = "I'm sorry",
  });
}
