import 'package:flutter/material.dart';
import 'package:trade_task/core/theme/app_theme.dart';
import 'package:trade_task/data/models/stock.dart';

class EditStockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback onDelete;

  const EditStockTile({
    super.key,
    required this.stock,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.drag_handle_rounded,
              color: AppTheme.dragHandle,
              size: 22,
            ),
          ),
          // Stock name
          Expanded(
            child: Text(
              stock.symbol,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
