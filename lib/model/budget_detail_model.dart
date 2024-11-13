class BudgetDetailModel {
  Budget? budget;
  List<Category>? category;

  BudgetDetailModel({this.budget, this.category});

  BudgetDetailModel.fromJson(Map<String, dynamic> json) {
    budget = json['budget'] != null ? Budget.fromJson(json['budget']) : null;
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (budget != null) {
      data['budget'] = budget!.toJson();
    }
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Budget {
  int? id;
  String? name;
  String? amount;
  int? startDate;
  String? createdAt;
  String? updatedAt;

  Budget(
      {this.id,
      this.name,
      this.amount,
      this.startDate,
      this.createdAt,
      this.updatedAt});

  Budget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    startDate = json['start_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['start_date'] = startDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Category {
  int? budgetId;
  int? categoryId;

  Category({this.budgetId, this.categoryId});

  Category.fromJson(Map<String, dynamic> json) {
    budgetId = json['budget_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['budget_id'] = budgetId;
    data['category_id'] = categoryId;
    return data;
  }
}
