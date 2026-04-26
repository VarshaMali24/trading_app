import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/market_index.dart';
import '../../../data/models/watchlist.dart';
import '../../../data/repositories/watchlist_repository.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _repository;

  WatchlistBloc({required WatchlistRepository repository})
      : _repository = repository,
        super(const WatchlistState()) {
    on<WatchlistInitialized>(_onInitialized);
    on<WatchlistTabChanged>(_onTabChanged);
    on<WatchlistEditModeToggled>(_onEditModeToggled);
    on<WatchlistStockReordered>(_onStockReordered);
    on<WatchlistStockRemoved>(_onStockRemoved);
    on<WatchlistRenamed>(_onRenamed);
    on<WatchlistSaved>(_onSaved);
  }

  Future<void> _onInitialized(
    WatchlistInitialized event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(state.copyWith(status: WatchlistStatus.loading));

    try {
      final results = await Future.wait([
        _repository.getWatchlists(),
        _repository.getMarketIndices(),
      ]);

      emit(state.copyWith(
        status: WatchlistStatus.success,
        watchlists: results[0] as List<Watchlist>,
        marketIndices: results[1] as List<MarketIndex>,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WatchlistStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onTabChanged(
    WatchlistTabChanged event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(
      activeTabIndex: event.tabIndex,
      isEditMode: false,
    ));
  }

  void _onEditModeToggled(
    WatchlistEditModeToggled event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  Future<void> _onStockReordered(
    WatchlistStockReordered event,
    Emitter<WatchlistState> emit,
  ) async {
    // Optimistic update: reorder in-memory immediately for snappy UI
    final watchlistIndex =
        state.watchlists.indexWhere((w) => w.id == event.watchlistId);
    if (watchlistIndex == -1) return;

    final watchlist = state.watchlists[watchlistIndex];
    final stocks = List.of(watchlist.stocks);
    final adjustedNewIndex =
        event.newIndex > event.oldIndex
            ? event.newIndex - 1
            : event.newIndex;

    final stock = stocks.removeAt(event.oldIndex);
    stocks.insert(adjustedNewIndex, stock);

    final updatedWatchlist = watchlist.copyWith(stocks: stocks);
    final updatedWatchlists = List.of(state.watchlists)
      ..[watchlistIndex] = updatedWatchlist;

    emit(state.copyWith(watchlists: updatedWatchlists));

    // Persist to repository
    try {
      await _repository.reorderStock(
        watchlistId: event.watchlistId,
        oldIndex: event.oldIndex,
        newIndex: event.newIndex,
      );
    } catch (e) {
      // Rollback on failure by re-fetching
      final freshWatchlists = await _repository.getWatchlists();
      emit(state.copyWith(
        watchlists: freshWatchlists,
        errorMessage: 'Reorder failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStockRemoved(
    WatchlistStockRemoved event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      final updatedWatchlist = await _repository.removeStock(
        watchlistId: event.watchlistId,
        stockId: event.stockId,
      );

      final watchlistIndex =
          state.watchlists.indexWhere((w) => w.id == event.watchlistId);
      if (watchlistIndex == -1) return;

      final updatedWatchlists = List.of(state.watchlists)
        ..[watchlistIndex] = updatedWatchlist;

      emit(state.copyWith(watchlists: updatedWatchlists));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRenamed(
    WatchlistRenamed event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      final updatedWatchlist = await _repository.renameWatchlist(
        watchlistId: event.watchlistId,
        newName: event.newName,
      );

      final watchlistIndex =
          state.watchlists.indexWhere((w) => w.id == event.watchlistId);
      if (watchlistIndex == -1) return;

      final updatedWatchlists = List.of(state.watchlists)
        ..[watchlistIndex] = updatedWatchlist;

      emit(state.copyWith(watchlists: updatedWatchlists));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onSaved(
    WatchlistSaved event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(isEditMode: false));
  }
}
