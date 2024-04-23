// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class OpenCageService {
//   final String apiKey =
//       '4f309cbef9f6498e9431173496241f82'; // Replace with your actual API key

//   Future<List<String>> getSuggestions(String input) async {
//     var url = Uri.parse('https://api.opencagedata.com/geocode/v1/json'
//         '?q=$input&key=$apiKey&limit=5&no_annotations=1&min_confidence=3');

//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       List<String> suggestions = [];
//       for (var item in data['results']) {
//         // Assuming 'results' is the correct key in the response
//         // Construct the suggestion string with checks for null or empty fields
//         String city = item['components']['city'] ?? '';
//         String state = item['components']['state'] ?? '';
//         String country = item['components']['country'] ?? '';

//         String suggestion = city;
//         if (city.isNotEmpty && state.isNotEmpty) {
//           suggestion += ', $state';
//         } else if (state.isNotEmpty) {
//           suggestion = state;
//         }
//         if (suggestion.isNotEmpty && country.isNotEmpty) {
//           suggestion += ', $country';
//         } else if (country.isNotEmpty) {
//           suggestion = country;
//         }

//         suggestions.add(suggestion);
//       }
//       return suggestions;
//     } else {
//       throw Exception('Failed to fetch suggestions');
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenCageService {
  final String apiKey = '4f309cbef9f6498e9431173496241f82';  // Replace with your actual API key

  Future<List<String>> getSuggestions(String input) async {
    // Include only certain types of results in the query
    var url = Uri.parse('https://api.opencagedata.com/geocode/v1/json'
                        '?q=$input&key=$apiKey&limit=5&no_annotations=1&min_confidence=3'
                        '&pretty=1');  // 'pretty' is optional; makes JSON response more readable

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<String> suggestions = [];
      for (var item in data['results']) {
        var components = item['components'];
        var formatted = item['formatted'];
        
        // Use formatted string but filter out unwanted details
        // For example, if formatted string contains "Tokyo, Tokyo, Japan", reduce it to "Tokyo, Japan"
        var addressParts = formatted.split(', ');
        if (addressParts.length > 2) {
          // This assumes that the city/town name is in the first part, and the country is the last part
          suggestions.add('${addressParts.first}, ${addressParts.last}');
        } else {
          suggestions.add(formatted);
        }
      }
      return suggestions.where((s) => s.isNotEmpty).toList(); // Filter out any empty strings
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}
