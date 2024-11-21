class ScheduleListModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String amount;
  final int transactionTypeId;
  final String transactionTypeName;
  final String status;
  final int? transactionId;
  final String scheduleTransactionDate;

  ScheduleListModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.transactionTypeId,
    required this.transactionTypeName,
    required this.status,
    this.transactionId,
    required this.scheduleTransactionDate,
  });

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) {
    return ScheduleListModel(
      id: json['id'],
      name: json['name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      amount: json['amount'],
      transactionTypeId: json['transaction_type_id'],
      transactionTypeName: json['transaction_type_name'],
      status: json['status'],
      transactionId: json['transaction_id'],
      scheduleTransactionDate: json['schedule_transaction_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'amount': amount,
      'transaction_type_id': transactionTypeId,
      'transaction_type_name': transactionTypeName,
      'status': status,
      'transaction_id': transactionId,
      'schedule_transaction_date': scheduleTransactionDate,
    };
  }
}
