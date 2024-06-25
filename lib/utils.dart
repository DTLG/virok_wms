enum InputType { popup, textField }

extension InputTypeX on InputType {
  bool get isPopup => this == InputType.popup;
  bool get isTextField => this == InputType.textField;
}


enum Storages { lviv, kyiv }

extension StoragesX on Storages {
  bool get isLviv => this == Storages.lviv;
  bool get isKyiv => this == Storages.kyiv;
}

extension ToStorage on String {
  Storages get toStorage {
    switch (this) {
      case 'lviv':
        return Storages.lviv;
      case 'kyiv':
        return Storages.kyiv;
      default:
        return Storages.lviv;
    }
  }
}

extension ToString on Storages {
  String get toStr {
    switch (this) {
      case Storages.lviv:
        return "Львів";
      case Storages.kyiv:
        return "Київ";
    }
  }
}
