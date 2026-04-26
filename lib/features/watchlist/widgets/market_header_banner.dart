import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/market_index.dart';

class MarketHeaderBanner extends StatelessWidget {
  final List<MarketIndex> indices;

  const MarketHeaderBanner({super.key, required this.indices});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(color: AppTheme.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < indices.length; i++) ...[
            Expanded(
              child: _IndexTile(index: indices[i]),
            ),
            if (i < indices.length - 1)
              const VerticalDivider(
                color: AppTheme.divider,
                width: 1,
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
          ],
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexTile extends StatelessWidget {
  final MarketIndex index;

  const _IndexTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final isPositive = index.isPositive;
    final valueColor =
        isPositive ? AppTheme.positiveGreen : AppTheme.negativeRed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  index.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                index.exchange,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                index.formattedValue,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                index.formattedChange,
                style: TextStyle(
                  fontSize: 11,
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
