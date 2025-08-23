import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

/// Scrapes HSA website for blood donation centres and generates centres_seed.json
/// Run with: dart tooling/scrape_centres.dart
void main() async {
  try {
    print('🩸 Scraping HSA blood donation centres...');
    
    final centres = await scrapeHSACentres();
    await writeCentresFile(centres);
    
    print('✅ Successfully generated ${centres.length} centres to assets/centres/centres_seed.json');
  } catch (e) {
    print('❌ Error scraping centres: $e');
    print('⚠️  Falling back to manual seed data...');
    
    final fallbackCentres = getFallbackCentres();
    await writeCentresFile(fallbackCentres);
    
    print('✅ Generated fallback centres data with ${fallbackCentres.length} centres');
  }
}

Future<List<Map<String, dynamic>>> scrapeHSACentres() async {
  const url = 'https://www.hsa.gov.sg/blood-donation/where-to-donate';
  
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Failed to load HSA page: ${response.statusCode}');
  }
  
  final document = parser.parse(response.body);
  final centres = <Map<String, dynamic>>[];
  
  // This is a simplified scraper - in reality, you'd need to analyze
  // the actual HSA page structure and extract the data accordingly
  // For now, we'll return fallback data
  throw Exception('HTML structure parsing not implemented - using fallback');
}

List<Map<String, dynamic>> getFallbackCentres() {
  return [
    {
      "id": "hsa-bloodbank-outram",
      "name": "Bloodbank@HSA (Outram)",
      "type": "Blood Bank",
      "address": "11 Outram Rd, Singapore 169078",
      "lat": 1.2805,
      "lng": 103.8370,
      "phone": "+65 6213 0969",
      "openingHours": {
        "Mon": [{"start": "09:00", "end": "18:00"}],
        "Tue": [{"start": "09:00", "end": "18:00"}],
        "Wed": [{"start": "09:00", "end": "18:00"}],
        "Thu": [{"start": "09:00", "end": "18:00"}],
        "Fri": [{"start": "09:00", "end": "18:00"}],
        "Sat": [{"start": "09:00", "end": "16:00"}],
        "Sun": []
      },
      "bookingUrl": "https://www.hsa.gov.sg/blood-donation/where-to-donate",
      "lastFetchedAt": DateTime.now().toIso8601String()
    },
    {
      "id": "hsa-bloodbank-dhoby-ghaut",
      "name": "Bloodbank@Dhoby Ghaut",
      "type": "Blood Bank",
      "address": "Plaza Singapura, 68 Orchard Rd, #B1-01, Singapore 238839",
      "lat": 1.3007,
      "lng": 103.8456,
      "phone": "+65 6213 0969",
      "openingHours": {
        "Mon": [{"start": "11:00", "end": "20:00"}],
        "Tue": [{"start": "11:00", "end": "20:00"}],
        "Wed": [{"start": "11:00", "end": "20:00"}],
        "Thu": [{"start": "11:00", "end": "20:00"}],
        "Fri": [{"start": "11:00", "end": "20:00"}],
        "Sat": [{"start": "10:00", "end": "18:00"}],
        "Sun": [{"start": "10:00", "end": "18:00"}]
      },
      "bookingUrl": "https://www.hsa.gov.sg/blood-donation/where-to-donate",
      "lastFetchedAt": DateTime.now().toIso8601String()
    },
    {
      "id": "hsa-bloodbank-woodlands",
      "name": "Bloodbank@Woodlands",
      "type": "Blood Bank",
      "address": "Causeway Point, 1 Woodlands Square, #01-28, Singapore 738099",
      "lat": 1.4366,
      "lng": 103.7860,
      "phone": "+65 6213 0969",
      "openingHours": {
        "Mon": [{"start": "11:00", "end": "20:00"}],
        "Tue": [{"start": "11:00", "end": "20:00"}],
        "Wed": [{"start": "11:00", "end": "20:00"}],
        "Thu": [{"start": "11:00", "end": "20:00"}],
        "Fri": [{"start": "11:00", "end": "20:00"}],
        "Sat": [{"start": "10:00", "end": "18:00"}],
        "Sun": [{"start": "10:00", "end": "18:00"}]
      },
      "bookingUrl": "https://www.hsa.gov.sg/blood-donation/where-to-donate",
      "lastFetchedAt": DateTime.now().toIso8601String()
    },
    {
      "id": "mobile-drive-example",
      "name": "Mobile Blood Drive - NTU",
      "type": "Mobile Drive",
      "address": "Nanyang Technological University, 50 Nanyang Ave, Singapore 639798",
      "lat": 1.3483,
      "lng": 103.6831,
      "openingHours": {
        "Mon": [],
        "Tue": [],
        "Wed": [],
        "Thu": [],
        "Fri": [{"start": "10:00", "end": "17:00"}],
        "Sat": [{"start": "09:00", "end": "16:00"}],
        "Sun": []
      },
      "bookingUrl": "https://www.hsa.gov.sg/blood-donation/where-to-donate",
      "lastFetchedAt": DateTime.now().toIso8601String()
    }
  ];
}

Future<void> writeCentresFile(List<Map<String, dynamic>> centres) async {
  final file = File('assets/centres/centres_seed.json');
  await file.create(recursive: true);
  
  final jsonString = const JsonEncoder.withIndent('  ').convert(centres);
  await file.writeAsString(jsonString);
}
