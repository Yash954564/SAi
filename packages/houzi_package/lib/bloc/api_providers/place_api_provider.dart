import 'package:dio/dio.dart';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:houzi_package/common/constants.dart';


class Suggestion {
  final String? placeId;
  final String? description;

  Suggestion(this.placeId, this.description);

}

class PlaceApiProvider {
  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final options = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),
    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error but for statuses 401 & 403.
    // Also allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to [null].
    hitCacheOnErrorExcept: [401, 403],
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to [null].
    maxStale: const Duration(minutes: 60),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended when [true].
    allowPostMethod: false,
  );

  final apiKey = GOOGLE_MAP_API_KEY;
  // final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    String request = '';
    if(LOCK_PLACES_API && PLACES_API_COUNTRIES.isNotEmpty){
      request = 'https://maps.googleapis.com/maps/api/place/autocomplete/'
          'json?input=$input&types=address&components=$PLACES_API_COUNTRIES&key=$apiKey&sessiontoken=$sessionToken';
    }else{
      request = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&key=$apiKey&sessiontoken=$sessionToken';
    }
    Dio dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    final response = await dio.get(request) as Response;
    if (response.statusCode == 200) {
      var result = response.data['predictions'] as List;
      return result.map<Suggestion>((p) {
        return Suggestion(p['place_id'], p['description']);
      }).toList();
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  static Future<Response> getPlaceGeocodeDetailsFromCoordinates(String coordinates) async {
    final request = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$coordinates&key=$GOOGLE_MAP_API_KEY';
    // final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    Dio dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    final response = await dio.get(request);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  static Future<Response> getPlaceDetailFromPlaceId(String placeId) async {
    print(placeId);
    final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAP_API_KEY';
    // final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    Dio dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    final response = await dio.get(request);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<Place> getPlaceDetailFromId(String placeId) async {
  //   final request = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY';
  //   // final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
  //   final response = await getDio().get(request) as Response;
  //   print(response);
  //
  //   if (response.statusCode == 200) {
  //     var result = response.data['result']['address_components'] as List;
  //     // final place = Place();
  //     Map placeMap = {};
  //
  //     result.forEach((c) {
  //       final List type = c['types'];
  //       if (type.contains('street_number')) {
  //         placeMap.streetNumber = c['long_name'];
  //       }
  //       if (type.contains('route')) {
  //         placeMap.street = c['long_name'];
  //       }
  //       if (type.contains('locality')) {
  //         placeMap.city = c['long_name'];
  //       }
  //       if (type.contains('postal_code')) {
  //         placeMap.zipCode = c['long_name'];
  //       }
  //     });
  //     return place;
  //   } else {
  //     throw Exception('Failed to fetch suggestion');
  //   }
  // }
}
