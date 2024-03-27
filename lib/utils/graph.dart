import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}

class Graph extends StatelessWidget {
  final List<SensorValue> data;
  const Graph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (SensorValue values, _) => values.time,
          measureFn: (SensorValue values, _) => values.value,
          data: data,
        )
      ],
      animate: false,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: charts.NoneRenderSpec(),
      ),
      domainAxis: const charts.DateTimeAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }
}
