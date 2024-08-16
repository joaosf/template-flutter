enum GlobalLabel { homeMessage, homeButton }

extension GlobalLabelExtension on GlobalLabel {
  String get message {
    switch (this) {
      case GlobalLabel.homeMessage:
        return 'Label Message';
      case GlobalLabel.homeButton:
        return 'Label Button';
      default:
        return 'Message not found';
    }
  }

  String get key {
    switch (this) {
      case GlobalLabel.homeMessage:
        return 'homeMessage';
      default:
        return 'Key not found';
    }
  }
}
