import '../datasources/watchlist_data_source.dart';
import '../models/market_index.dart';
import '../models/stock.dart';
import '../models/watchlist.dart';

abstract interface class WatchlistRepository {
  Future<List<Watchlist>> getWatchlists();
  Future<List<MarketIndex>> getMarketIndices();
  Future<Watchlist> reorderStock({
    required String watchlistId,
    required int oldIndex,
    required int newIndex,
  });
  Future<Watchlist> removeStock({
    required String watchlistId,
    required String stockId,
  });
  Future<Watchlist> renameWatchlist({
    required String watchlistId,
    required String newName,
  });
}

class WatchlistRepositoryImpl implements WatchlistRepository {
  // In-memory state to simulate persistence
  late List<Watchlist> _watchlists;
  late List<MarketIndex> _marketIndices;

  WatchlistRepositoryImpl() {
    _watchlists = WatchlistDataSource.sampleWatchlists;
    _marketIndices = WatchlistDataSource.sampleMarketIndices;
  }

  @override
  Future<List<Watchlist>> getWatchlists() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_watchlists);
  }

  @override
  Future<List<MarketIndex>> getMarketIndices() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_marketIndices);
  }

  @override
  Future<Watchlist> reorderStock({
    required String watchlistId,
    required int oldIndex,
    required int newIndex,
  }) async {
    final watchlistIndex =
        _watchlists.indexWhere((w) => w.id == watchlistId);

    if (watchlistIndex == -1) {
      throw Exception('Watchlist not found: $watchlistId');
    }

    final watchlist = _watchlists[watchlistIndex];
    final stocks = List<Stock>.from(watchlist.stocks);

    // Adjust newIndex when dragging downward
    final adjustedNewIndex =
        newIndex > oldIndex ? newIndex - 1 : newIndex;

    final stock = stocks.removeAt(oldIndex);
    stocks.insert(adjustedNewIndex, stock);

    final updatedWatchlist = watchlist.copyWith(stocks: stocks);
    _watchlists = List<Watchlist>.from(_watchlists)
      ..[watchlistIndex] = updatedWatchlist;

    return updatedWatchlist;
  }

  @override
  Future<Watchlist> removeStock({
    required String watchlistId,
    required String stockId,
  }) async {
    final watchlistIndex =
        _watchlists.indexWhere((w) => w.id == watchlistId);

    if (watchlistIndex == -1) {
      throw Exception('Watchlist not found: $watchlistId');
    }

    final watchlist = _watchlists[watchlistIndex];
    final updatedStocks =
        watchlist.stocks.where((s) => s.id != stockId).toList();

    final updatedWatchlist =
        watchlist.copyWith(stocks: updatedStocks);
    _watchlists = List<Watchlist>.from(_watchlists)
      ..[watchlistIndex] = updatedWatchlist;

    return updatedWatchlist;
  }

  @override
  Future<Watchlist> renameWatchlist({
    required String watchlistId,
    required String newName,
  }) async {
    final watchlistIndex =
        _watchlists.indexWhere((w) => w.id == watchlistId);

    if (watchlistIndex == -1) {
      throw Exception('Watchlist not found: $watchlistId');
    }

    final updatedWatchlist =
        _watchlists[watchlistIndex].copyWith(name: newName);
    _watchlists = List<Watchlist>.from(_watchlists)
      ..[watchlistIndex] = updatedWatchlist;

    return updatedWatchlist;
  }
}
