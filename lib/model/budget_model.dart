class BudgetModel {
  int? id;
  String? name;
  String? amount;
  String? balance;
  String? createdAt;
  String? updatedAt;
  List<Category>? category;

  BudgetModel({
    this.id,
    this.name,
    this.amount,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  BudgetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    balance = json['balance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? budgetId;
  int? categoryId;
  String? categoryName;

  Category({
    this.budgetId,
    this.categoryId,
    this.categoryName,
  });

  Category.fromJson(Map<String, dynamic> json) {
    budgetId = json['budget_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['budget_id'] = budgetId;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    return data;
  }
}
