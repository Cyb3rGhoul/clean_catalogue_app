import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGuage extends StatelessWidget {
  final double aggregateScore;
  const RadialGuage({super.key, required this.aggregateScore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 100, pointers: <GaugePointer>[
            NeedlePointer(value: aggregateScore, enableAnimation: true)
          ], ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 33.3, color: Colors.red),
            GaugeRange(startValue: 33.3, endValue: 66.7, color: Colors.orange),
            GaugeRange(startValue: 66.7, endValue: 100, color: Colors.green),
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                aggregateScore.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              positionFactor: 0.5,
              angle: 90,
            )
          ])
        ],
      ),
    );
  }
}
