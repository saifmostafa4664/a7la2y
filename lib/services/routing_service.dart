import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  static const String _baseUrl = 'router.project-osrm.org';

  static Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}',
        {'overview': 'full', 'geometries': 'geojson'},
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['code'] != 'Ok') return [];

      final routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) return [];

      final geometry = routes[0]['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;

      return coordinates
          .map<LatLng>(
            (coord) => LatLng(
              (coord[1] as num).toDouble(),
              (coord[0] as num).toDouble(),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}
