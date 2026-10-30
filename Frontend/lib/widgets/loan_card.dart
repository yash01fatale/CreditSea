import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/loan_model.dart';
import 'status_chip.dart';

class LoanCard extends StatelessWidget {
  final LoanModel loan;
  final VoidCallback? onTap;

  const LoanCard({super.key, required this.loan, this.onTap});

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row – amount & status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currencyFormat.format(loan.amount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  StatusChip(status: loan.status ?? 'submitted'),
                ],
              ),
              const SizedBox(height: 12),

              // Details row
              Row(
                children: [
                  _detail(context, Icons.calendar_today_outlined, '${loan.tenure} months'),
                  const SizedBox(width: 20),
                  _detail(context, Icons.payment, 'EMI ${_currencyFormat.format(loan.emi)}'),
                ],
              ),
              const SizedBox(height: 8),

              // Bottom row – purpose & date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (loan.purpose != null)
                    Chip(
                      label: Text(
                        loan.purpose!,
                        style: const TextStyle(fontSize: 11),
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  if (loan.appliedAt != null)
                    Text(
                      _dateFormat.format(loan.appliedAt!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
