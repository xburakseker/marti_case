final class MarkerModel {
  final String id;
  final double latitude;
  final double longitude;
  final String? address;

  MarkerModel({required this.id, required this.latitude, required this.longitude, this.address});
}
