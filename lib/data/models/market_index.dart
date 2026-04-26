import 'package:equatable/equatable.dart';

class MarketIndex extends Equatable {
  final String name;
  final String exchange;
  final double value;
  final double change;
  final double changePercent;

  const MarketIndex({
    required this.name,
    required this.exchange,
    required this.value,
    required this.change,
    required this.changePercent,
  });

  bool get isPositive => change >= 0;

  String get formattedValue => value.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{2})+(\d{3})\.|\d{3}\.|\d{3}$)'),
        (m) => '${m[1]},',
      );

  String get formattedChange {
    final sign = isPositive ? '' : '';
    return '$sign${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)';
  }

  @override
  List<Object?> get props => [name, exchange, value, change, changePercent];
}
