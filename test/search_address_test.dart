import 'package:flutter_test/flutter_test.dart';
import 'package:ramro_postal_service/features/search/data/models/search_response.dart';

void main() {
  group('SearchAddress', () {
    test('backend results default to Ramro source', () {
      final address = SearchAddress.fromJson({
        'id': 1,
        'latitude': '27.7',
        'longitude': '85.3',
      });

      expect(address.source, SearchAddressSource.ramro);
      expect(address.isRamro, isTrue);
      expect(address.hasCoordinates, isTrue);
    });

    test('old Google history is inferred from place id', () {
      final address = SearchAddress.fromJson({
        'place_id': 'google-place',
        'full_address_detail': 'Kathmandu, Nepal',
      });

      expect(address.source, SearchAddressSource.google);
      expect(address.isRamro, isFalse);
      expect(address.hasCoordinates, isFalse);
    });

    test('source survives history serialization', () {
      final original = SearchAddress(
        latitude: '27.7',
        longitude: '85.3',
        placeId: 'google-place',
        source: SearchAddressSource.google,
      );

      final restored = SearchAddress.fromJson(original.toJson());

      expect(restored.source, SearchAddressSource.google);
      expect(restored.hasCoordinates, isTrue);
    });
  });
}
