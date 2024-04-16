import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantBudget {
  final String participantId;
  double budget; // Fixed budget for each participant

  ParticipantBudget({
    required this.participantId,
    required this.budget,
  });

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'budget': budget,
  };

  static ParticipantBudget fromJson(Map<String, dynamic> json) => ParticipantBudget(
        participantId: json['participantId'],
        budget: json['budget'],
  );
}

class TravelPlanModel {
  final String id;
  final String creatorId;
  String destination;
  DateTime startDate;
  DateTime endDate;
  final List<String> participantIds;
  List<ParticipantBudget> participantBudgets; // Simplified to just include a fixed budget
  String description;

  TravelPlanModel({
    required this.id,
    required this.creatorId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.participantIds,
    required this.participantBudgets,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'creatorId': creatorId,
        'destination': destination,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'participantIds': participantIds,
        'participantBudgets': participantBudgets.map((budget) => budget.toJson()).toList(),
        'description': description,
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
  );

  factory TravelPlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    var data = document.data() ?? {};
    return TravelPlanModel(
      id: document.id,
      creatorId: data['creatorId'] ?? '',
      destination: data['destination'] ?? '',
      startDate: data['startDate'] != null ? (data['startDate'] as Timestamp).toDate() : DateTime.now(),
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : DateTime.now(),
      participantIds: data['participantIds'] != null ? List<String>.from(data['participantIds']) : [],
      participantBudgets: data['participantBudgets'] != null
          ? (data['participantBudgets'] as List).map((budget) => ParticipantBudget.fromJson(budget)).toList()
          : [],
      description: data['description'] ?? '',
    );
  }
}
