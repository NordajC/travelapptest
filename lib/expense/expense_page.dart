import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/expense/expense_controller.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_repository.dart';

class ExpenseOverviewPage extends StatelessWidget {
  final String tripId;
  final String currentUserId = Get.find<UserController>().user.value.id;
  final ExpenseController expenseController = Get.find();
  final TripController tripController = Get.find();
  final TripRepository tripRepository = Get.find();

  ExpenseOverviewPage({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap UI with Obx to make it reactive
    return Obx(() {
      tripController.loadBudgetsForUserTrips(currentUserId);

      double totalExpenses =
          tripController.userTripBudgets.value[tripId]?.budget ?? 0.0;
      double totalBudget =
          tripController.userTripBudgets.value[tripId]?.spendings ?? 0.0;
      double remainingBudget = totalExpenses - totalBudget;

      if (expenseController.categoryExpenses.isEmpty) {
        return const CircularProgressIndicator(); // loading indicator you prefer
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Overview'),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Remaining Budget',
                          style:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${remainingBudget.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: remainingBudget < 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Expense',
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${totalExpenses.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Budget',
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${totalBudget.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: expenseController.categoryExpenses.length,
                  itemBuilder: (context, index) {
                    String category = expenseController.categoryExpenses.keys
                        .elementAt(index);
                    double expense = expenseController.categoryExpenses.values
                        .elementAt(index);
                    return ExpenseCategoryWidget(
                      category: category,
                      totalExpense: expense,
                      totalExpenses: totalExpenses,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class ExpenseCategoryWidget extends StatelessWidget {
  final String category;
  final double totalExpense;
  final double totalExpenses;

  ExpenseCategoryWidget({
    Key? key,
    required this.category,
    required this.totalExpense,
    required this.totalExpenses,
  }) : super(key: key);

  // Helper method to get the icon for the category.
  IconData getIconForCategory(String category) {
    // Return the icon associated with the category or a default one.
    return categoryIcons[category] ?? Icons.help_outline;
  }

  // Helper method to get the color for the category.
  Color? getColorForCategory(String category) {
    // Return the color associated with the category or dark grey for custom categories.
    return categoryColors[category] ??
        Colors.grey[850]; // Using dark grey for custom categories.
  }

  @override
  Widget build(BuildContext context) {
    final IconData icon = getIconForCategory(category);
    final Color? color = getColorForCategory(category);

    // Calculate the percentage of total expenses used by this category
    double expensePercentage =
        (totalExpenses > 0) ? totalExpense / totalExpenses : 0.0;
    expensePercentage = expensePercentage.clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(width: 10),
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
              Spacer(),
              Text(
                "\$${totalExpense.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: expensePercentage,
            backgroundColor: Colors.grey[100],
            color: color,
            minHeight: 20,
          ),
        ],
      ),
    );
  }
}

// Helper method to calculate the total expenses from a Map of category expenses.
double calculateTotalExpenses(Map<String, double> categoryExpenses) {
  double totalExpenses = 0.0;
  categoryExpenses.forEach((category, expense) {
    totalExpenses += expense;
  });
  return totalExpenses;
}

// Define a Map for category icons.
const Map<String, IconData> categoryIcons = {
  'Transportation': Icons.directions_bus,
  'Meals': Icons.local_dining,
  'Activities': Icons.run_circle,
  'Accommodation': Icons.hotel,
  'Shopping': Icons.shopping_bag,
  'Personal Time': Icons.person,
  'Other': Icons.more_horiz,
};

// Define a Map for category colors. Update this as needed.
const Map<String, Color> categoryColors = {
  'Transportation': Colors.blue,
  'Meals': Colors.green,
  'Activities': Colors.orange,
  'Accommodation': Color.fromARGB(255, 255, 120, 165),
  'Shopping': Colors.purple,
  'Personal Time': Colors.red,
  'Other': Colors.black,
};
