import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantBudget {
  final String participantId;
  double budget; // Fixed budget for each participant
  double spendings; // Total spendings for each participant
  Map<String, double> debts; // Debts owed by this participant to others

  ParticipantBudget({
    required this.participantId,
    required this.budget,
    this.spendings = 0.0,
    Map<String, double>? debts,
  }) : debts = debts ?? {};

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'budget': budget,
        'spendings': spendings,
        'debts': debts.map((key, value) => MapEntry(
            key, value.toString())), // Ensuring the map is serialized properly
      };

  static ParticipantBudget fromJson(Map<String, dynamic> json) =>
      ParticipantBudget(
        participantId: json['participantId'],
        budget: json['budget'],
        spendings: json['spendings']?.toDouble() ?? 0.0,
        debts: (json['debts'] as Map<String, dynamic>?)
                ?.map((key, value) => MapEntry(key, double.parse(value))) ??
            {},
      );

  void addSpending(double amount) {
    spendings += amount;
  }

  void removeSpending(double amount) {
    spendings -= amount;
  }

  void addDebt(String otherParticipantId, double amount) {
    debts.update(otherParticipantId, (existing) => existing + amount,
        ifAbsent: () => amount);
  }

  void reduceDebt(String otherParticipantId, double amount) {
    if (debts[otherParticipantId] != null) {
      debts[otherParticipantId] = debts[otherParticipantId]! - amount;
      if (debts[otherParticipantId]! <= 0) debts.remove(otherParticipantId);
    }
  }
}

class ItineraryItem {
  final String id;
  String name;
  DateTime startTime;
  DateTime endTime;
  String location;
  double? price; // Linked to specific activity
  double? generalExpenseAmount; // For unlinked general expenses
  String? paidBy; // Who paid for the linked activity
  String? generalExpensePaidBy; // Who paid for the general expense
  Map<String, int> votes;
  String suggestedBy;
  String status;
  String? category;
  String? notes;
  String? generalExpenseDescription; // Description of the general expense
  Map<String, double>? splitDetails; // Details on how the expense is split
  List<String>? participants; // IDs of participants involved in the expense
  Map<String, String>?
      paymentStatus; // Payment status for each participant involved
  String? splitType; // 'equal', 'percentage', 'custom'

  ItineraryItem({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.price,
    this.generalExpenseAmount,
    this.paidBy,
    this.generalExpensePaidBy,
    this.votes = const {},
    this.suggestedBy = '',
    this.status = 'pending',
    this.category,
    this.notes,
    this.generalExpenseDescription,
    this.splitDetails,
    this.participants,
    this.paymentStatus,
    this.splitType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'location': location,
        'price': price,
        'generalExpenseAmount': generalExpenseAmount,
        'paidBy': paidBy,
        'generalExpensePaidBy': generalExpensePaidBy,
        'votes': votes,
        'suggestedBy': suggestedBy,
        'status': status,
        'category': category,
        'notes': notes,
        'generalExpenseDescription': generalExpenseDescription,
        'splitDetails': splitDetails,
        'participants': participants,
        'paymentStatus':
            paymentStatus?.map((key, value) => MapEntry(key, value.toString())),
        'splitType': splitType,
      };

  static ItineraryItem fromJson(Map<String, dynamic> json) => ItineraryItem(
        id: json['id'],
        name: json['name'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        location: json['location'],
        price: json['price']?.toDouble(),
        generalExpenseAmount: json['generalExpenseAmount']?.toDouble(),
        paidBy: json['paidBy'],
        generalExpensePaidBy: json['generalExpensePaidBy'],
        votes: Map<String, int>.from(json['votes'] ?? {}),
        suggestedBy: json['suggestedBy'] ?? '',
        status: json['status'] ?? 'pending',
        category: json['category'],
        notes: json['notes'],
        generalExpenseDescription: json['generalExpenseDescription'],
        splitDetails: Map<String, double>.from(json['splitDetails'] ?? {}),
        participants: List<String>.from(json['participants'] ?? []),
        paymentStatus: Map<String, String>.from(json['paymentStatus'] ?? {}),
        splitType: json['splitType'],
      );
}

class DailyItinerary {
  DateTime date;
  List<ItineraryItem> items;

  DailyItinerary({
    required this.date,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'date': Timestamp.fromDate(date),
        'items': items.map((item) => item.toJson()).toList(),
      };

  static DailyItinerary fromJson(Map<String, dynamic> json) => DailyItinerary(
        date: (json['date'] as Timestamp).toDate(),
        items: (json['items'] as List)
            .map((itemJson) => ItineraryItem.fromJson(itemJson))
            .toList(),
      );
}

class TravelPlanModel {
  final String id;
  final String creatorId;
  String destination;
  DateTime startDate;
  DateTime endDate;
  final List<String> participantIds;
  List<ParticipantBudget>
      participantBudgets; // Simplified to just include a fixed budget
  String description;
  List<DailyItinerary> dailyItineraries;

  TravelPlanModel({
    required this.id,
    required this.creatorId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.participantIds,
    required this.participantBudgets,
    this.description = '',
    required this.dailyItineraries,
  });

  Map<String, dynamic> toJson() => {
        'creatorId': creatorId,
        'destination': destination,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'participantIds': participantIds,
        'participantBudgets':
            participantBudgets.map((budget) => budget.toJson()).toList(),
        'description': description,
        'dailyItineraries':
            dailyItineraries.map((daily) => daily.toJson()).toList(),
      };

  static TravelPlanModel empty() => TravelPlanModel(
        id: '',
        creatorId: '',
        destination: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        participantIds: [],
        participantBudgets: [],
        description: '',
        dailyItineraries: [],
      );

  factory TravelPlanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    var data = document.data() ?? {};
    return TravelPlanModel(
      id: document.id,
      creatorId: data['creatorId'] ?? '',
      destination: data['destination'] ?? '',
      startDate: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : DateTime.now(),
      participantIds: data['participantIds'] != null
          ? List<String>.from(data['participantIds'])
          : [],
      participantBudgets: data['participantBudgets'] != null
          ? (data['participantBudgets'] as List)
              .map((budget) => ParticipantBudget.fromJson(budget))
              .toList()
          : [],
      description: data['description'] ?? '',
      dailyItineraries: data['dailyItineraries'] != null
          ? (data['dailyItineraries'] as List)
              .map((dailyJson) => DailyItinerary.fromJson(dailyJson))
              .toList()
          : [],
    );
  }
}
