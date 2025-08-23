import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme/dexter_theme.dart';

class DexGoogleMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String centreName;
  final String centreAddress;
  final VoidCallback? onDirectionsPressed;
  final double height;
  final bool showControls;

  const DexGoogleMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.centreName,
    required this.centreAddress,
    this.onDirectionsPressed,
    this.height = 250,
    this.showControls = true,
  });

  @override
  State<DexGoogleMap> createState() => _DexGoogleMapState();
}

class _DexGoogleMapState extends State<DexGoogleMap> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('blood_centre'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.centreName,
          snippet: widget.centreAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
        child: Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 16.0,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              mapType: MapType.normal,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
            ),
            
            // Custom Controls Overlay
            if (widget.showControls) ...[
              // Zoom Controls
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    _buildControlButton(
                      icon: Icons.add,
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildControlButton(
                      icon: Icons.remove,
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // My Location Button
              Positioned(
                right: 16,
                top: 120,
                child: _buildControlButton(
                  icon: Icons.my_location,
                  onPressed: () => _mapController?.animateCamera(
                    CameraUpdate.newLatLng(LatLng(widget.latitude, widget.longitude)),
                  ),
                ),
              ),
              
              // Directions Button
              if (widget.onDirectionsPressed != null)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildDirectionsButton(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
            ),
            child: Icon(
              icon,
              color: DexterTokens.dexGreen,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionsButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DexterTokens.dexGreen,
            DexterTokens.dexLeaf,
          ],
        ),
        borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: DexterTokens.dexGreen.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onDirectionsPressed,
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.directions,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Directions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
