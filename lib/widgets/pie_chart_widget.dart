import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget createPieChart( List<charts.Series<dynamic, String>> seriesPieData){
  return charts.PieChart(
    seriesPieData,
    animate: true,
    animationDuration: Duration(milliseconds: 200),
    behaviors: [
      charts.DatumLegend(
        outsideJustification: charts.OutsideJustification.startDrawArea,
        horizontalFirst: false,
        position: charts.BehaviorPosition.bottom,
        cellPadding: EdgeInsets.only(top: 4, bottom: 4, right: 4),
        entryTextStyle: charts.TextStyleSpec(
          color: charts.MaterialPalette.black,
          fontSize: 22,
          fontFamily: 'Rome'
        ),
      ),
    ],
    defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 50,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            insideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontSize: 14,
            ),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontSize: 14,
            ),
            labelPosition: charts.ArcLabelPosition.auto,
          ),
        ]
    ),
  );
}