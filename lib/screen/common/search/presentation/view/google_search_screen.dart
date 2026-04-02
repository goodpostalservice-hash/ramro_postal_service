import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/common/profile/controller/profile_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import 'package:ramro_postal_service/screen/common/search/controller/search_controller.dart';
import 'package:ramro_postal_service/screen/common/search/model/place_prediction_model.dart';
import '../../../../qr/presentation/view/show_qr_screen.dart';
import '../../../../saved_address/presentation/pages/saved_address_screen.dart';
import 'show_search_on_map_screen.dart';

class GoogleSearchScreen extends StatefulWidget {
  const GoogleSearchScreen({super.key, this.pickLocation});
  final int? pickLocation;
  @override
  State<GoogleSearchScreen> createState() => _GoogleSearchScreenState();
}

class _GoogleSearchScreenState extends State<GoogleSearchScreen> {
  final FocusNode _focusNode = FocusNode();

  late GoogleMapController _mapController;
  final searchController = TextEditingController();
  List<PlacePrediction> googlePredictions = [];
  List<MapModel> predictions = [];
  Timer? _timer;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultController = Get.put(SearchMapController());
    final profileControlelr = Get.put(ProfileController());
    final savedAddressController = Get.put(SavedAddressController());
    return Scaffold(
      backgroundColor: appTheme.white,
      appBar: AppBar(
        backgroundColor: appTheme.white,
        elevation: 0,
        foregroundColor: appTheme.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SearchPanel(
              onChanged: (String value) async {
                predictions.clear();
                if (searchController.text.isNotEmpty) {
                  await searchResultController.getSearchAddresses(value);
                  await searchPlace(value);
                }
                if (mounted) {
                  setState(() {
                    predictions = searchResultController.searchResultList
                        .toList();
                  });
                }
              },
              controller: searchController,
            ),
          ),

          // CONTENT
          Expanded(
            child: (predictions.isEmpty && googlePredictions.isEmpty)
                ? const _EmptyStateSections()
                : _PredictionLists(
                    predictions: predictions,
                    googlePredictions: googlePredictions,
                    pickLocation: widget.pickLocation,
                    onPickLocal: (MapModel m) {
                      final myList = [
                        m.longitude!,
                        m.latitude!,
                        m.cordinate!,
                        m.zipCode!,
                        m.area!,
                        m.zone!,
                        m.subZone!,
                        m.street!,
                        m.houseNum!,
                        m.fullAddressDetail!,
                      ];
                      if (widget.pickLocation == 0) {
                        // usrController.dropInfo = myList;
                        // usrController.dropLocationController.text =
                        //     splitCoordinateString(myList[9]);
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context);
                      } else if (widget.pickLocation == 1) {
                        // usrController.pickUpInfo = myList;
                        // usrController.pickUpLocationController.text =
                        //     splitCoordinateString(myList[9]);
                        Navigator.pop(context);
                      } else if (widget.pickLocation == 2) {
                        // profileControlelr.addressController.text = myList[9];
                        // usrController.pickUpInfo = myList;
                        Navigator.pop(context);
                      } else if (widget.pickLocation == 3) {
                        savedAddressController.saveQR(
                          m.longitude!,
                          m.latitude!,
                          m.fullAddressDetail!,
                          'ramro',
                          true,
                        );
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowSearchOnMapScreen(
                              longitude: double.parse(m.longitude!),
                              latitude: double.parse(m.latitude!),
                              address: m.fullAddressDetail!,
                              houseno: m.houseNum ?? '',
                              street: m.street ?? '',
                              zone: m.zone ?? '',
                              sub: m.subZone ?? '',
                            ),
                          ),
                        );
                      }
                    },
                    onPickGoogle: (PlacePrediction p) async {
                      final LatLng? ll = await getPlaceCoordinates(p.placeId);
                      if (ll == null) return;
                      if (widget.pickLocation == 0) {
                        // usrController.dropLocationController.text = p.description;
                        // usrController.pickUpInfo = [ll.longitude.toString(), ll.latitude.toString()];
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context);
                      } else if (widget.pickLocation == 1) {
                        // usrController.pickUpLocationController.text = p.description;
                        // usrController.dropInfo = [ll.longitude.toString(), ll.latitude.toString()];
                        Navigator.pop(context);
                      } else {
                        Get.to(
                          ShowSearchOnMapScreen(
                            latitude: ll.latitude,
                            longitude: ll.longitude,
                            address: p.description,
                            houseno: '',
                            street: '',
                            zone: '',
                            sub: '',
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  searchPlace(String input) async {
    final apiKey = AppConstant.googleMapAPI;
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await dio.get(apiUrl);
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    googlePredictions.clear();
    final predictionsList = data['predictions'] as List;
    final List<PlacePrediction> newPredictions = predictionsList.map((
      prediction,
    ) {
      return PlacePrediction(
        description: prediction['description'],
        placeId: prediction['place_id'],
      );
    }).toList();
    if (mounted) {
      setState(() {
        googlePredictions = newPredictions;
      });
    }
  }

  /// google map coordinate work
  void onPlaceSelected(String placeId, String description) async {
    final coordinates = await getPlaceCoordinates(placeId);
    if (coordinates != null) {
      // Use the coordinates as needed
      final lat = coordinates.latitude;
      final lng = coordinates.longitude;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowQRScreen(
            location_detail: description,
            latitude: lat.toString(),
            longitude: lng.toString(),
          ),
        ),
      );
    }
  }

  Future<LatLng?> getPlaceCoordinates(String placeId) async {
    final apiKey = AppConstant.googleMapAPI;
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    try {
      final response = await Dio().get(apiUrl);
      final json = response.data;

      final lat = json['result']['geometry']['location']['lat'];
      final lng = json['result']['geometry']['location']['lng'];

      return LatLng(lat, lng);
    } catch (e) {
      // Handle error
      print(e);
      return null;
    }
  }
}

/* =================== EMPTY STATE: matches the screenshot =================== */
class _EmptyStateSections extends StatelessWidget {
  const _EmptyStateSections();

  Color get border => const Color(0xFFE6E6E6);
  Color get title => const Color(0xFF101010);
  Color get subtitle => const Color(0xFF6C6C6C);
  Color get orange => const Color(0xFFFF910D);
  Color get orangeBg => const Color(0xFFFFF1E2);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current location card (peach background)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: orangeBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current location',
                        style: TextStyle(
                          color: title,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '41 Ca service road, kathmandu 44600',
                        style: TextStyle(
                          color: subtitle,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Favourites header
          Text(
            'Favourites',
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // Home tile (outlined)
          _OutlinedTile(
            border: border,
            leading: const Icon(Icons.home_outlined, color: Color(0xFF101010)),
            title: 'Home',
            subtitle: 'Set your home address',
          ),
          const SizedBox(height: 10),

          // Work tile (outlined)
          _OutlinedTile(
            border: border,
            leading: const Icon(Icons.work_outline, color: Color(0xFF101010)),
            title: 'Work',
            subtitle: 'Set your home address',
          ),

          const SizedBox(height: 18),

          // Nearby locations header
          Text(
            'Nearby locations',
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // Chips row
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _FilterChip(label: 'Petrol pump'),
              _FilterChip(label: 'Park near me'),
              _FilterChip(label: 'Bus station'),
            ],
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _OutlinedTile extends StatelessWidget {
  const _OutlinedTile({
    required this.border,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final Color border;
  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textPrimary = const Color(0xFF101010);
    final textSecondary = const Color(0xFF6C6C6C);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: leading,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: const Color(0xFFE6E6E6))),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF101010),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _PredictionLists extends StatelessWidget {
  const _PredictionLists({
    required this.predictions,
    required this.googlePredictions,
    required this.pickLocation,
    required this.onPickLocal,
    required this.onPickGoogle,
  });

  final List<MapModel> predictions;
  final List<PlacePrediction> googlePredictions;
  final int? pickLocation;
  final void Function(MapModel) onPickLocal;
  final void Function(PlacePrediction) onPickGoogle;

  @override
  Widget build(BuildContext context) {
    if (predictions.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: predictions.length,
        itemBuilder: (context, i) {
          final m = predictions[i];
          return InkWell(
            onTap: () => onPickLocal(m),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Text(
                _splitAddress(m.fullAddressDetail ?? ''),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          );
        },
      );
    }

    // else google predictions
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: googlePredictions.length,
      itemBuilder: (context, i) {
        final p = googlePredictions[i];
        return InkWell(
          onTap: () => onPickGoogle(p),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Text(
              _splitAddress(p.description),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        );
      },
    );
  }

  String _splitAddress(String address) {
    final parts = address.split(',');
    if (parts.length <= 2) return address;
    return parts.sublist(0, parts.length - 2).join(',');
  }
}
