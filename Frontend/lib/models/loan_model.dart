import 'dart:convert';

class LoanModel {
  String? id;
  String? purpose;
  String? status;
  String? rejectionReason;
  double amount;
  double emi;
  double totalPayable;
  double interestRate;
  int tenure;
  DateTime? appliedAt;
  DateTime? updatedAt;
  List<StatusHistory> statusHistory;

  LoanModel({
    this.id,
    this.purpose,
    this.status,
    this.rejectionReason,
    this.amount = 0,
    this.emi = 0,
    this.totalPayable = 0,
    this.interestRate = 12.0,
    this.tenure = 12,
    this.appliedAt,
    this.updatedAt,
    List<StatusHistory>? statusHistory,
  }) : statusHistory = statusHistory ?? [];

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['_id'] ?? json['id'],
      purpose: json['purpose'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      amount: (json['amount'] ?? 0).toDouble(),
      emi: (json['emi'] ?? 0).toDouble(),
      totalPayable: (json['totalPayable'] ?? 0).toDouble(),
      interestRate: (json['interestRate'] ?? 12).toDouble(),
      tenure: json['tenure'] ?? 12,
      appliedAt:
          json['appliedAt'] != null ? DateTime.tryParse(json['appliedAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      statusHistory: json['statusHistory'] != null
          ? (json['statusHistory'] as List)
              .map((e) => StatusHistory.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'tenure': tenure,
      'interestRate': interestRate,
      'emi': emi,
      'totalPayable': totalPayable,
      if (purpose != null) 'purpose': purpose,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (appliedAt != null) 'appliedAt': appliedAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'statusHistory': statusHistory.map((e) => e.toJson()).toList(),
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory LoanModel.fromRawJson(String str) =>
      LoanModel.fromJson(jsonDecode(str));

  /// Returns the display-friendly status text.
  String get displayStatus {
    if (status == null) return 'Unknown';
    return status!
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

class StatusHistory {
  String status;
  DateTime date;
  String? note;

  StatusHistory({
    required this.status,
    required this.date,
    this.note,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      status: json['status'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'date': date.toIso8601String(),
      if (note != null) 'note': note,
    };
  }
}
