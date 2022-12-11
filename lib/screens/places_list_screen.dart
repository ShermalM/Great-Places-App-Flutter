import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import './place_detail_screen.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (_, greatPlaces, child) => greatPlaces.items.isEmpty
                    ? child
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 5,
                        ),
                        child: ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                greatPlaces.items[index].image,
                              ),
                            ),
                            title: Text(greatPlaces.items[index].title),
                            subtitle:
                                Text(greatPlaces.items[index].location.address),
                            onTap: () => Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[index].id,
                            ),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
