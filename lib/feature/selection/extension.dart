extension Selection on int {
  String get statusError {
    switch (this) {
      case 0:
        return 'Штрихкод не знайдено';
      case 2:
        return 'Відсканована кількість більша ніж в накладній';
      case 3:
        return 'Кошик не знайдено';
      case 4:
        return 'Кошик пустий';
      case 5:
        return 'Кошик зайнятий';
      case 6:
        return 'Введене від’ємне число';
      case 7:
        return 'Комірку не знайдено';
      default:
        return 'Помилка';
    }
  }
}
