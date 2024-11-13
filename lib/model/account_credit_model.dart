class AccountCreditModel {
  String? startDate;
  String? endDate;
  String? expense;
  String? income;
  String? balance;

  AccountCreditModel({
    this.startDate,
    this.endDate,
    this.expense,
    this.income,
    this.balance,
  });

  AccountCreditModel.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    expense = json['expense'];
    income = json['income'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['expense'] = expense;
    data['income'] = income;
    data['balance'] = balance;
    return data;
  }
}
