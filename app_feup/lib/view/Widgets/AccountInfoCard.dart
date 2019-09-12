import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';

import 'GenericCard.dart';

class AccountInfoCard extends GenericCard {

  AccountInfoCard({Key key, this.feesBalance, this.nextFeeLimitData});

  String feesBalance, nextFeeLimitData;

  @override
  Widget buildCardContent(BuildContext context) {
    return Table(
        columnWidths: {1: FractionColumnWidth(.4)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Text("Saldo: ",
                  style: TextStyle(
                      color: greyTextColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w100
                  )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
              child: getInfoText(feesBalance, context),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
              child: Text("Data limite próxima prestação: ",
                  style: TextStyle(
                      color: greyTextColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w100
                  )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 30.0),
              child: getInfoText(nextFeeLimitData, context),
            )
          ])
        ]
    );
  }

  @override
  String getTitle() => "Conta Corrente";

  @override
  onClick(BuildContext context) {}

}