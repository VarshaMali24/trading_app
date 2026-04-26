import 'package:equatable/equatable.dart';

enum StockType { equity, futures, options }

enum Exchange { nse, bse }

enum InstrumentType { eq, idx, monthly, annual }

class Stock extends Equatable {
  final String id;
  final String symbol;
  final Exchange exchange;
  final InstrumentType instrumentType;
  final double ltp; // Last Traded Price
  final double change;
  final double changePercent;

  const Stock({
    required this.id,
    required this.symbol,
    required this.exchange,
    required this.instrumentType,
    required this.ltp,
    required this.change,
    required this.changePercent,
  });

  bool get isPositive => change >= 0;

  String get exchangeLabel => exchange.name.toUpperCase();

  String get instrumentLabel => switch (instrumentType) {
        InstrumentType.eq => 'EQ',
        InstrumentType.idx => 'IDX',
        InstrumentType.monthly => 'Monthly',
        InstrumentType.annual => 'Annual',
      };

  String get subtitle => instrumentType == InstrumentType.idx
      ? exchangeLabel
      : '$exchangeLabel | $instrumentLabel';

  String get formattedLtp => _formatPrice(ltp);

  String get formattedChange {
    final sign = isPositive ? '+' : '';
    return '$sign${_formatPrice(change)} (${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%)';
  }

  String _formatPrice(double value) {
    if (value.abs() >= 1000) {
      return value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{2})+(\d{3})\.|\d{3}\.|\d{3}$)'),
            (m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(2);
  }

  Stock copyWith({
    String? id,
    String? symbol,
    Exchange? exchange,
    InstrumentType? instrumentType,
    double? ltp,
    double? change,
    double? changePercent,
  }) {
    return Stock(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      instrumentType: instrumentType ?? this.instrumentType,
      ltp: ltp ?? this.ltp,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
    );
  }

  @override
  List<Object?> get props =>
      [id, symbol, exchange, instrumentType, ltp, change, changePercent];
}
