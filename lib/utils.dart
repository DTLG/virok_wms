enum InputType { popup, textField }

extension InputTypeX on InputType {
  bool get isPopup => this == InputType.popup;
  bool get isTextField => this == InputType.textField;
}