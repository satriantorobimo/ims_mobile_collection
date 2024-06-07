import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as maps;
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.data});

  final Data data;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Position _currentPosition;
  maps.DirectionsMode directionsMode = maps.DirectionsMode.driving;
  bool isLoading = true;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  Future<void> _showBottomCall(BuildContext context, String number) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Text(
                    'Select Options',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        _launchUrl('tel://$number');
                      },
                      child: const Text(
                        'Phone',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        _launchUrlBrowser(
                            'https://api.whatsapp.com/send/?phone$number');
                      },
                      child: const Text(
                        'Whatsapp',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
  }

  Future<void> _launchUrl(String urlValue) async {
    Uri url = Uri.parse(urlValue);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchUrlBrowser(String urlValue) async {
    Uri url = Uri.parse(urlValue);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _showBottomMaps({
    required BuildContext context,
    required Function(maps.AvailableMap map) onMapTap,
  }) async {
    final availableMaps = await maps.MapLauncher.installedMaps;
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (var map in availableMaps)
                ListTile(
                  onTap: () => onMapTap(map),
                  title: Text(map.mapName),
                  leading: SvgPicture.asset(
                    map.icon,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> launchURLGmaps(String lat, String long) async {
    // final String mapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    //
    //
    //
    // Uri url = Uri.parse(mapsUrl);
    //
    // if (!await launchUrl(url)) {
    //   throw Exception('Could not launch $url');
    // }
    // final availableMaps = await maps.MapLauncher.installedMaps;
    //
    //
    // await availableMaps.first.showMarker(
    //   coords: maps.Coords(latitude, longitude),
    //   title: "Ocean Beach",
    // );
  }

  getCurrentLocation() async {
    dynamic serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return Future.error('Location services are disabled.');
    } else {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Task Detail',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BBFB6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: const Color(0xFFFBFBFB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.data.clientName!,
                              style: const TextStyle(
                                  color: Color(0xFF565656),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone No',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFBFBFB),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.data.phoneNo1!,
                                  style: const TextStyle(
                                      color: Color(0xFF565656),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomCall(
                                      context, widget.data.phoneNo1!);
                                },
                                child: const Icon(
                                  Icons.phone_outlined,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency Phone No',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                                color: const Color(0xFFFBFBFB),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.data.phoneNo2!,
                                  style: const TextStyle(
                                      color: Color(0xFF565656),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomCall(
                                      context, widget.data.phoneNo2!);
                                },
                                child: const Icon(
                                  Icons.phone_outlined,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: const Color(0xFFFBFBFB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.data.fullAddress!,
                            style: const TextStyle(
                                color: Color(0xFF565656),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Maps',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showBottomMaps(
                                    context: context,
                                    onMapTap: (map) {
                                      map.showDirections(
                                        destination: maps.Coords(
                                            widget.data.latitude != ''
                                                ? double.parse(
                                                    widget.data.latitude!)
                                                : _currentPosition.latitude,
                                            widget.data.longitude != ''
                                                ? double.parse(
                                                    widget.data.longitude!)
                                                : _currentPosition.longitude),
                                        destinationTitle:
                                            widget.data.clientName,
                                        origin: maps.Coords(
                                            _currentPosition.latitude,
                                            _currentPosition.longitude),
                                        originTitle: 'You',
                                        directionsMode: directionsMode,
                                      );
                                    });
                              },
                              child: const Text(
                                'Open Google Maps',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 173,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                              color: const Color(0xFFFBFBFB),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ]),
                          child: isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    width: double.infinity,
                                    height: 173,
                                  ),
                                )
                              : AbsorbPointer(
                                  absorbing: true,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(
                                          widget.data.latitude != ''
                                              ? double.parse(
                                                  widget.data.latitude!)
                                              : _currentPosition.latitude,
                                          widget.data.longitude != ''
                                              ? double.parse(
                                                  widget.data.longitude!)
                                              : _currentPosition.longitude),
                                      zoom: 17.0,
                                      keepAlive: false,
                                    ),
                                    layers: [
                                      // TileLayerOptions(
                                      //   urlTemplate:
                                      //       "https://api.tiles.mapbox.com/v4/"
                                      //       "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                      //   additionalOptions: {
                                      //     'accessToken':
                                      //         '31232956-93ac-41b1-aa98-c048527f8ea0',
                                      //     'id': 'mapbox.streets',
                                      //   },
                                      // ),

                                      TileLayerOptions(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          subdomains: ['a', 'b', 'c']),
                                      MarkerLayerOptions(
                                        markers: [
                                          Marker(
                                            width: 30.0,
                                            height: 30.0,
                                            point: LatLng(
                                                widget.data.latitude != ''
                                                    ? double.parse(
                                                        widget.data.latitude!)
                                                    : _currentPosition.latitude,
                                                widget.data.longitude != ''
                                                    ? double.parse(
                                                        widget.data.longitude!)
                                                    : _currentPosition
                                                        .longitude),
                                            builder: (ctx) => Image.asset(
                                              'assets/icon/pin.png',
                                              scale: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: const Color(0xFFE7E7E7),
            ),
            const SizedBox(height: 12),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invoice List',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.agreementList!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context,
                              StringRouterUtil.invoiceDetailScreenRoute,
                              arguments: widget.data.agreementList![index]);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.05)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 109,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: widget
                                                      .data
                                                      .agreementList![index]
                                                      .resultCode !=
                                                  ''
                                              ? const Color(0xFF70B96E)
                                              : const Color(0xFFFF6969),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(18.0),
                                            bottomLeft: Radius.circular(8.0),
                                          )),
                                      child: Center(
                                        child: Text(
                                          widget.data.agreementList![index]
                                                      .resultCode !=
                                                  ''
                                              ? 'Paid'
                                              : 'Not Paid',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16.0,
                                      bottom: 16.0,
                                      top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data.agreementList![index]
                                            .agreementNo!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF222222)
                                                .withOpacity(0.7)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.data.agreementList![index]
                                            .vehicleDescription!,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget
                                            .data.agreementList![index].platNo!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF222222)),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.41,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Installment',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                              0xFF222222)
                                                          .withOpacity(0.5)),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.tag_sharp,
                                                      size: 15,
                                                      color: Color(0xFF222222),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${widget.data.agreementList![index].lastPaidInstallmentNo!} / ${widget.data.agreementList![index].tenor!}',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xFF222222)),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .calendar_today_rounded,
                                                      size: 15,
                                                      color: Color(0xFF222222),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      widget
                                                          .data
                                                          .agreementList![index]
                                                          .installmentDueDate!,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xFF222222)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.41,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Overdue',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                              0xFF222222)
                                                          .withOpacity(0.5)),
                                                ),
                                                Text(
                                                  '${widget.data.agreementList![index].overdueDays!} Days',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFFF5151)),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  GeneralUtil.convertToIdr(
                                                      widget
                                                          .data
                                                          .agreementList![index]
                                                          .overdueInstallmentAmount!,
                                                      2),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFFF5151)),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
