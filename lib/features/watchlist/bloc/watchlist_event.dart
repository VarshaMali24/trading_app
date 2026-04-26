part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

final class WatchlistInitialized extends WatchlistEvent {
  const WatchlistInitialized();
}

final class WatchlistTabChanged extends WatchlistEvent {
  final int tabIndex;

  const WatchlistTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

final class WatchlistEditModeToggled extends WatchlistEvent {
  const WatchlistEditModeToggled();
}

final class WatchlistStockReordered extends WatchlistEvent {
  final String watchlistId;
  final int oldIndex;
  final int newIndex;

  const WatchlistStockReordered({
    required this.watchlistId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [watchlistId, oldIndex, newIndex];
}

final class WatchlistStockRemoved extends WatchlistEvent {
  final String watchlistId;
  final String stockId;

  const WatchlistStockRemoved({
    required this.watchlistId,
    required this.stockId,
  });

  @override
  List<Object?> get props => [watchlistId, stockId];
}

final class WatchlistRenamed extends WatchlistEvent {
  final String watchlistId;
  final String newName;

  const WatchlistRenamed({
    required this.watchlistId,
    required this.newName,
  });

  @override
  List<Object?> get props => [watchlistId, newName];
}

final class WatchlistSaved extends WatchlistEvent {
  const WatchlistSaved();
}
