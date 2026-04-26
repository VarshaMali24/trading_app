import '../models/stock.dart';
import '../models/watchlist.dart';
import '../models/market_index.dart';

class WatchlistDataSource {
  static List<MarketIndex> get sampleMarketIndices => const [
        MarketIndex(
          name: 'SENSEX 18TH SEP 8…',
          exchange: 'BSE',
          value: 1225.55,
          change: 144.50,
          changePercent: 13.35,
        ),
        MarketIndex(
          name: 'NIFTY BANK',
          exchange: 'NSE',
          value: 54170.15,
          change: -16.75,
          changePercent: -0.03,
        ),
      ];

  static List<Watchlist> get sampleWatchlists => [
        Watchlist(
          id: 'watchlist_1',
          name: 'Watchlist 1',
          stocks: [
            const Stock(
              id: 'stock_reliance',
              symbol: 'RELIANCE',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 1374.10,
              change: -4.40,
              changePercent: -0.32,
            ),
            const Stock(
              id: 'stock_hdfcbank',
              symbol: 'HDFCBANK',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 966.85,
              change: 0.85,
              changePercent: 0.09,
            ),
            const Stock(
              id: 'stock_asianpaint',
              symbol: 'ASIANPAINT',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 2537.40,
              change: 6.60,
              changePercent: 0.26,
            ),
            const Stock(
              id: 'stock_niftyit',
              symbol: 'NIFTY IT',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.idx,
              ltp: 35187.30,
              change: 876.86,
              changePercent: 2.56,
            ),
            const Stock(
              id: 'stock_reliance_sep_ce',
              symbol: 'RELIANCE SEP 1880 CE',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.monthly,
              ltp: 0.00,
              change: 0.00,
              changePercent: 0.00,
            ),
            const Stock(
              id: 'stock_reliance_sep_pe',
              symbol: 'RELIANCE SEP 1370 PE',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.monthly,
              ltp: 19.20,
              change: 1.00,
              changePercent: 5.49,
            ),
            const Stock(
              id: 'stock_mrf_nse',
              symbol: 'MRF',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 147625.00,
              change: 550.00,
              changePercent: 0.37,
            ),
            const Stock(
              id: 'stock_mrf_bse',
              symbol: 'MRF',
              exchange: Exchange.bse,
              instrumentType: InstrumentType.eq,
              ltp: 147439.45,
              change: 463.80,
              changePercent: 0.32,
            ),
          ],
        ),
        Watchlist(
          id: 'watchlist_5',
          name: 'Watchlist 5',
          stocks: [
            const Stock(
              id: 'stock_tcs',
              symbol: 'TCS',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 3845.20,
              change: 42.15,
              changePercent: 1.11,
            ),
            const Stock(
              id: 'stock_infy',
              symbol: 'INFY',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 1672.45,
              change: -8.30,
              changePercent: -0.49,
            ),
            const Stock(
              id: 'stock_wipro',
              symbol: 'WIPRO',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 478.90,
              change: 3.25,
              changePercent: 0.68,
            ),
          ],
        ),
        Watchlist(
          id: 'watchlist_6',
          name: 'Watchlist 6',
          stocks: [
            const Stock(
              id: 'stock_sbi',
              symbol: 'SBIN',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 782.30,
              change: 5.60,
              changePercent: 0.72,
            ),
            const Stock(
              id: 'stock_axisbank',
              symbol: 'AXISBANK',
              exchange: Exchange.nse,
              instrumentType: InstrumentType.eq,
              ltp: 1023.75,
              change: -12.40,
              changePercent: -1.20,
            ),
          ],
        ),
      ];
}
