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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/${cardModel.routeName}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(cardModel.url),
              SizedBox(height: 8),
              Padding(
                child: Text(
                  cardModel.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              SizedBox(height: 4),
              Padding(
                child: Text(cardModel.subtitle),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
