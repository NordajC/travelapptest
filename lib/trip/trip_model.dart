import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantBudget {
  final String participantId;
  double budget; // Fixed budget for each participant
  double spendings; // Total spendings for each participant

  ParticipantBudget({
    required this.participantId,
    required this.budget,
    this.spendings = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'budget': budget,
        'spendings': spendings,
      };

  static ParticipantBudget fromJson(Map<String, dynamic> json) =>
      ParticipantBudget(
        participantId: json['participantId'],
        budget: json['budget'],
        spendings: json['spendings']?.toDouble() ?? 0.0,
      );

  void addSpending(double amount) {
    spendings += amount;
  }

  void removeSpending(double amount) {
    spendings -= amount;
  }
}

class ItineraryItem {
  final String id;
  String name;
  DateTime startTime;
  DateTime endTime;
  String location;
  double? price;
  String? paidBy;
  Map<String, int> votes; // User IDs and their votes
  String suggestedBy;
  String status; // e.g., "pending", "approved", "rejected"
  String? category;
  String? notes;

  ItineraryItem({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.price,
    this.paidBy,
    this.votes = const {},
    this.suggestedBy = '',
    this.status = 'pending',
    this.category,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'location': location,
        'price': price,
        'paidBy': paidBy,
        'votes': votes,
        'suggestedBy': suggestedBy,
        'status': status,
        'category': category,
        'notes': notes,
      };

  static ItineraryItem fromJson(Map<String, dynamic> json) => ItineraryItem(
        id: json['id'],
        name: json['name'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        location: json['location'],
        price: json['price']?.toDouble(), // Handle optional double
        paidBy: json['paidBy'], // Optional
        votes: Map<String, int>.from(json['votes'] ?? {}),
        suggestedBy: json['suggestedBy'] ?? '',
        status: json['status'] ?? 'pending',
        category: json['category'],
        notes: json['notes'],
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
