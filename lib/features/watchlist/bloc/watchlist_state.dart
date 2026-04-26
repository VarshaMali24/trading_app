part of 'watchlist_bloc.dart';

enum WatchlistStatus { initial, loading, success, failure }

final class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<Watchlist> watchlists;
  final List<MarketIndex> marketIndices;
  final int activeTabIndex;
  final bool isEditMode;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.watchlists = const [],
    this.marketIndices = const [],
    this.activeTabIndex = 0,
    this.isEditMode = false,
    this.errorMessage,
  });

  Watchlist? get activeWatchlist =>
      watchlists.isEmpty ? null : watchlists[activeTabIndex];

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<Watchlist>? watchlists,
    List<MarketIndex>? marketIndices,
    int? activeTabIndex,
    bool? isEditMode,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      watchlists: watchlists ?? this.watchlists,
      marketIndices: marketIndices ?? this.marketIndices,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      isEditMode: isEditMode ?? this.isEditMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        watchlists,
        marketIndices,
        activeTabIndex,
        isEditMode,
        errorMessage,
      ];
}
