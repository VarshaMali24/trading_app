import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_task/data/models/market_index.dart';
import 'package:trade_task/data/models/stock.dart';
import 'package:trade_task/data/models/watchlist.dart';
import 'package:trade_task/data/repositories/watchlist_repository.dart';
import 'package:trade_task/features/watchlist/bloc/watchlist_bloc.dart';

// ---------------------------------------------------------------------------
// Fake repository for testing — no real async I/O
// ---------------------------------------------------------------------------
class FakeWatchlistRepository implements WatchlistRepository {
  static const _stocks = [
    Stock(
      id: 's1',
      symbol: 'RELIANCE',
      exchange: Exchange.nse,
      instrumentType: InstrumentType.eq,
      ltp: 1374.10,
      change: -4.40,
      changePercent: -0.32,
    ),
    Stock(
      id: 's2',
      symbol: 'HDFCBANK',
      exchange: Exchange.nse,
      instrumentType: InstrumentType.eq,
      ltp: 966.85,
      change: 0.85,
      changePercent: 0.09,
    ),
    Stock(
      id: 's3',
      symbol: 'ASIANPAINT',
      exchange: Exchange.nse,
      instrumentType: InstrumentType.eq,
      ltp: 2537.40,
      change: 6.60,
      changePercent: 0.26,
    ),
  ];

  List<Watchlist> _watchlists = [
    const Watchlist(id: 'w1', name: 'Watchlist 1', stocks: _stocks),
  ];

  @override
  Future<List<Watchlist>> getWatchlists() async => List.of(_watchlists);

  @override
  Future<List<MarketIndex>> getMarketIndices() async => const [
        MarketIndex(
          name: 'SENSEX',
          exchange: 'BSE',
          value: 80000,
          change: 100,
          changePercent: 0.12,
        ),
      ];

  @override
  Future<Watchlist> reorderStock({
    required String watchlistId,
    required int oldIndex,
    required int newIndex,
  }) async {
    final wIdx = _watchlists.indexWhere((w) => w.id == watchlistId);
    final stocks = List<Stock>.from(_watchlists[wIdx].stocks);
    final adj = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final s = stocks.removeAt(oldIndex);
    stocks.insert(adj, s);
    final updated = _watchlists[wIdx].copyWith(stocks: stocks);
    _watchlists = List.of(_watchlists)..[wIdx] = updated;
    return updated;
  }

  @override
  Future<Watchlist> removeStock({
    required String watchlistId,
    required String stockId,
  }) async {
    final wIdx = _watchlists.indexWhere((w) => w.id == watchlistId);
    final updated = _watchlists[wIdx].copyWith(
      stocks: _watchlists[wIdx].stocks.where((s) => s.id != stockId).toList(),
    );
    _watchlists = List.of(_watchlists)..[wIdx] = updated;
    return updated;
  }

  @override
  Future<Watchlist> renameWatchlist({
    required String watchlistId,
    required String newName,
  }) async {
    final wIdx = _watchlists.indexWhere((w) => w.id == watchlistId);
    final updated = _watchlists[wIdx].copyWith(name: newName);
    _watchlists = List.of(_watchlists)..[wIdx] = updated;
    return updated;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late FakeWatchlistRepository repository;

  setUp(() => repository = FakeWatchlistRepository());

  group('WatchlistBloc initialization', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'emits [loading, success] on WatchlistInitialized',
      build: () => WatchlistBloc(repository: repository),
      act: (bloc) => bloc.add(const WatchlistInitialized()),
      expect: () => [
        isA<WatchlistState>()
            .having((s) => s.status, 'status', WatchlistStatus.loading),
        isA<WatchlistState>()
            .having((s) => s.status, 'status', WatchlistStatus.success)
            .having((s) => s.watchlists.length, 'watchlists count', 1)
            .having((s) => s.marketIndices.length, 'indices count', 1),
      ],
    );
  });

  group('WatchlistBloc tab switching', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'switches active tab',
      build: () => WatchlistBloc(repository: repository),
      seed: () => const WatchlistState(
        status: WatchlistStatus.success,
        activeTabIndex: 0,
      ),
      act: (bloc) => bloc.add(const WatchlistTabChanged(1)),
      expect: () => [
        isA<WatchlistState>()
            .having((s) => s.activeTabIndex, 'tab', 1)
            .having((s) => s.isEditMode, 'edit mode', false),
      ],
    );
  });

  group('WatchlistBloc reorder', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'reorders stock from index 0 to 2 (optimistic update)',
      build: () => WatchlistBloc(repository: repository),
      act: (bloc) async {
        bloc.add(const WatchlistInitialized());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const WatchlistStockReordered(
          watchlistId: 'w1',
          oldIndex: 0,
          newIndex: 2,
        ));
      },
      verify: (bloc) {
        final stocks = bloc.state.watchlists.first.stocks;
        // After moving index 0 to newIndex 2 (adjusted to 1):
        expect(stocks[0].symbol, 'HDFCBANK');
        expect(stocks[1].symbol, 'RELIANCE');
      },
    );
  });

  group('WatchlistBloc remove stock', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'removes stock by id',
      build: () => WatchlistBloc(repository: repository),
      act: (bloc) async {
        bloc.add(const WatchlistInitialized());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const WatchlistStockRemoved(watchlistId: 'w1', stockId: 's1'));
      },
      verify: (bloc) {
        final stocks = bloc.state.watchlists.first.stocks;
        expect(stocks.any((s) => s.id == 's1'), isFalse);
        expect(stocks.length, 2);
      },
    );
  });

  group('WatchlistBloc rename', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'renames watchlist',
      build: () => WatchlistBloc(repository: repository),
      act: (bloc) async {
        bloc.add(const WatchlistInitialized());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const WatchlistRenamed(
          watchlistId: 'w1',
          newName: 'My Portfolio',
        ));
      },
      verify: (bloc) {
        expect(bloc.state.watchlists.first.name, 'My Portfolio');
      },
    );
  });

  group('WatchlistBloc edit mode', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'toggles edit mode',
      build: () => WatchlistBloc(repository: repository),
      seed: () => const WatchlistState(status: WatchlistStatus.success),
      act: (bloc) => bloc.add(const WatchlistEditModeToggled()),
      expect: () => [
        isA<WatchlistState>().having((s) => s.isEditMode, 'edit mode', true),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'WatchlistSaved turns off edit mode',
      build: () => WatchlistBloc(repository: repository),
      seed: () => const WatchlistState(
        status: WatchlistStatus.success,
        isEditMode: true,
      ),
      act: (bloc) => bloc.add(const WatchlistSaved()),
      expect: () => [
        isA<WatchlistState>().having((s) => s.isEditMode, 'edit mode', false),
      ],
    );
  });
}
