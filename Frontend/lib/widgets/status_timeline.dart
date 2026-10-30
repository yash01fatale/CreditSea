import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/theme/app_colors.dart';
import '../models/loan_model.dart';

class StatusTimeline extends StatelessWidget {
  final List<StatusHistory> history;
  final String? currentStatus;

  const StatusTimeline({
    super.key,
    required this.history,
    this.currentStatus,
  });

  static final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  /// Default timeline steps if history is empty.
  static const _defaultSteps = [
    'Submitted',
    'Under Review',
    'Approved',
    'Disbursed',
  ];

  @override
  Widget build(BuildContext context) {
    if (history.isNotEmpty) {
      return _buildFromHistory();
    }
    return _buildFromDefault();
  }

  Widget _buildFromHistory() {
    return Column(
      children: List.generate(history.length, (i) {
        final item = history[i];
        final isLast = i == history.length - 1;
        return _TimelineStep(
          title: _formatStatus(item.status),
          subtitle: _dateFormat.format(item.date),
          note: item.note,
          isCompleted: true,
          isCurrent: isLast,
          isLast: isLast,
          color: AppColors.statusColor(item.status),
        );
      }),
    );
  }

  Widget _buildFromDefault() {
    final normalized = (currentStatus ?? '')
        .toLowerCase()
        .replaceAll('_', ' ');
    final steps = normalized == 'rejected'
        ? const ['Submitted', 'Under Review', 'Rejected']
        : _defaultSteps;
    final currentIdx = steps.indexWhere(
      (step) => step.toLowerCase() == normalized,
    );

    return Column(
      children: List.generate(steps.length, (i) {
        final isCompleted = i <= currentIdx;
        final isCurrent = i == currentIdx;
        final isLast = i == steps.length - 1;

        return _TimelineStep(
          title: steps[i],
          subtitle: isCurrent
              ? 'Current'
              : (isCompleted ? 'Completed' : 'Pending'),
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isLast: isLast,
          color: isCompleted
              ? AppColors.statusColor(steps[i])
              : Colors.grey.shade400,
        );
      }),
    );
  }

  String _formatStatus(String status) {
    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? note;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final Color color;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    this.note,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? color : Colors.grey.shade300,
                    border: isCurrent
                        ? Border.all(color: color, width: 3)
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? color.withValues(alpha: 0.4) : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                      color: isCompleted ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      note!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
