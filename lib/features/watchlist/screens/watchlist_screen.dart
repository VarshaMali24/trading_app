import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_task/core/theme/app_theme.dart';
import 'package:trade_task/features/watchlist/bloc/watchlist_bloc.dart';
import 'package:trade_task/features/watchlist/widgets/market_header_banner.dart';
import 'package:trade_task/features/watchlist/widgets/stock_list_tile.dart';

import 'edit_watchlist_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: _buildBody(context, state),
          ),
          bottomNavigationBar: _BottomNavBar(),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WatchlistState state) {
    if (state.status == WatchlistStatus.loading ||
        state.status == WatchlistStatus.initial) {
      return const Center(
        child:
            CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
      );
    }

    if (state.status == WatchlistStatus.failure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppTheme.negativeRed),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Something went wrong',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<WatchlistBloc>()
                  .add(const WatchlistInitialized()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Market index banner
        if (state.marketIndices.isNotEmpty)
          MarketHeaderBanner(indices: state.marketIndices),

        // Search bar
        const SearchBar(),

        // Watchlist tab bar
        _WatchlistTabBar(
          watchlists: state.watchlists,
          activeIndex: state.activeTabIndex,
          onTabChanged: (i) =>
              context.read<WatchlistBloc>().add(WatchlistTabChanged(i)),
        ),

        // Sort by bar
        _SortByBar(
          activeWatchlistIndex: state.activeTabIndex,
          watchlistId: state.activeWatchlist?.id ?? '',
        ),

        const Divider(height: 1),

        // Stock list
        Expanded(
          child: state.activeWatchlist == null ||
                  state.activeWatchlist!.stocks.isEmpty
              ? const _EmptyWatchlist()
              : ListView.separated(
                  itemCount: state.activeWatchlist!.stocks.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 0),
                  itemBuilder: (context, index) {
                    final stock = state.activeWatchlist!.stocks[index];
                    return StockListTile(stock: stock);
                  },
                ),
        ),
      ],
    );
  }
}

class _WatchlistTabBar extends StatelessWidget {
  final List<dynamic> watchlists;
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const _WatchlistTabBar({
    required this.watchlists,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: watchlists.length,
        itemBuilder: (context, i) {
          final isActive = i == activeIndex;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isActive ? AppTheme.tabIndicator : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                watchlists[i].name as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive ? AppTheme.textPrimary : AppTheme.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SortByBar extends StatelessWidget {
  final int activeWatchlistIndex;
  final String watchlistId;

  const _SortByBar({
    required this.activeWatchlistIndex,
    required this.watchlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to edit screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<WatchlistBloc>(),
                    child: EditWatchlistScreen(
                        watchlistIndex: activeWatchlistIndex),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.divider, width: 1.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: AppTheme.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border_rounded,
              size: 52, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          const Text(
            'No stocks in watchlist',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Use the search bar to add instruments',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_rounded),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined),
            label: 'GTT+',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline_rounded),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Funds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
