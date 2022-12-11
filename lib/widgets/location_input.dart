import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageURL;

  void _showPreview({double lat, double lng}) {
    final staticMapImageURL = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageURL = staticMapImageURL;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locationData = await Location().getLocation();
      _showPreview(
        lat: locationData.latitude,
        lng: locationData.longitude,
      );
      widget.onSelectPlace(
        lat: locationData.latitude,
        lng: locationData.longitude,
      );
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    print('entered function');
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) return;
    _showPreview(
      lat: selectedLocation.latitude,
      lng: selectedLocation.longitude,
    );
    widget.onSelectPlace(
      lat: selectedLocation.latitude,
      lng: selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageURL == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
