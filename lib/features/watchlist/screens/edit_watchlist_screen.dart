import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/watchlist_bloc.dart';
import '../widgets/edit_stock_tile.dart';
import '../widgets/rename_watchlist_dialog.dart';

class EditWatchlistScreen extends StatelessWidget {
  final int watchlistIndex;

  const EditWatchlistScreen({super.key, required this.watchlistIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state.watchlists.isEmpty ||
            watchlistIndex >= state.watchlists.length) {
          return const Scaffold(body: Center(child: Text('Not found')));
        }

        final watchlist = state.watchlists[watchlistIndex];

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 22),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Edit ${watchlist.name}'),
            elevation: 0,
          ),
          body: Column(
            children: [
              // Watchlist name field
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    watchlist.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      final newName = await showDialog<String>(
                        context: context,
                        builder: (_) => RenameWatchlistDialog(
                          currentName: watchlist.name,
                        ),
                      );
                      if (newName != null && context.mounted) {
                        context.read<WatchlistBloc>().add(
                              WatchlistRenamed(
                                watchlistId: watchlist.id,
                                newName: newName,
                              ),
                            );
                      }
                    },
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // Reorderable stock list
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    itemCount: watchlist.stocks.length,
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Material(
                            elevation: 6 * animation.value,
                            color: AppTheme.background,
                            shadowColor:
                                Colors.black.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                            child: child,
                          );
                        },
                        child: child,
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      context.read<WatchlistBloc>().add(
                            WatchlistStockReordered(
                              watchlistId: watchlist.id,
                              oldIndex: oldIndex,
                              newIndex: newIndex,
                            ),
                          );
                    },
                    itemBuilder: (context, index) {
                      final stock = watchlist.stocks[index];
                      return Column(
                        key: ValueKey(stock.id),
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            child: EditStockTile(
                              stock: stock,
                              onDelete: () {
                                context.read<WatchlistBloc>().add(
                                      WatchlistStockRemoved(
                                        watchlistId: watchlist.id,
                                        stockId: stock.id,
                                      ),
                                    );
                              },
                            ),
                          ),
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit other watchlists button
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side:
                          const BorderSide(color: AppTheme.divider, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit other watchlists',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Save button
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WatchlistBloc>()
                          .add(const WatchlistSaved());
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Watchlist',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
