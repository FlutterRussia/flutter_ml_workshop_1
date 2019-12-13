import 'package:flutter/material.dart';

import '../main.dart';

class CustomCard extends StatelessWidget {
  CustomCard(this.cardModel);

  final CardModel cardModel;

  @override
  Widget build(BuildContext context) {
    /// Step 2
    /// Реализуем внешнийвид карточки для списка всех функций в MlKit
    /// Так же тут нужно обработать переход на экран с распознованием.
    /// Для это существует [GestureDetector] который позволяет слушать нажатие на child [Widget]
  }
}
