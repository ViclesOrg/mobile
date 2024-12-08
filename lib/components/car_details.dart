import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/preferences_helper.dart';
import 'package:vicles/remix_icon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CarDetails extends StatefulWidget {
  final dynamic _car;
  const CarDetails({super.key, dynamic car}) : _car = car;
  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  bool _isCarLoding = true;
  List<dynamic> _dates = [];
  List<dynamic> _images = [];
  PickerDateRange _selectedDateRange = PickerDateRange(null, null);
  int _user = 0;

  Future<void> _retriveUser() async {
    String tmp = '';
    String? token = await getValue("user");
    setState(() {
      tmp = token ?? "No token found!";
      if (tmp != "No token found!") {
        _user = int.parse(jsonDecode(tmp.toString())['user']['id'].toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _retriveUser();
    loadCarAvailabilityDates(int.parse(widget._car['id']));
    loadCarImages(int.parse(widget._car['id']));
  }

  @override
  Widget build(BuildContext context) {
    return handleState(widget._car);
  }

  // The problem here is that This function somehoe not sending the id of the car to the api
  Future<dynamic> loadCarAvailabilityDates(int id) async {
    try {
      final dates = await ApiService.post("renters/rentalDates", {
        "id": id,
      });
      if (dates != null && dates['error']['code'] == 0) {
        _dates = dates['dates'];
      }
    } catch (e) {
      setState(() {
        _isCarLoding = false;
      });
    }
  }

  Future<dynamic> loadCarImages(int id) async {
    try {
      final images = await ApiService.post("renters/CarImages", {
        "id": id,
      });
      if (images != null && images['error']['code'] == 0) {
        setState(() {
          _isCarLoding = false;
        });
        _images = images['links'];
      }
    } catch (e) {
      setState(() {
        _isCarLoding = false;
      });
    }
  }

  void showCustomSnackBar(BuildContext context, String message) {
    // Remove any existing overlays first to prevent stacking
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position at the bottom of the screen
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        // Center horizontally and add padding
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Show the overlay and remove it after duration
    overlayState?.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  Widget handleState(dynamic car) {
    if (_isCarLoding) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 253, 111, 0),
          ),
        ),
      );
    }
    _images.insert(0, {'link': car["cover"], 'car': car["id"]});
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: SizedBox(
                height: 300.0, // Specify the desired height
                child: PageView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _images[index]['link'],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Keep the first row as it is
                  Row(
                    children: [
                      Text(
                        '${car["cbrand"]} ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${car["cmodel"]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // Use GridView for the remaining rows
                  GridView(
                    shrinkWrap:
                        true, // Important to avoid infinite height error
                    physics:
                        NeverScrollableScrollPhysics(), // Prevent scrolling within the modal
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 4, // Adjust based on design
                    ),
                    children: [
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xEB0F,
                            color: Colors.grey,
                          ),
                          Text(
                            ' ${car["owner"]}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xEF0A,
                            color: Colors.grey,
                          ),
                          Text(
                            locale: Locale('fr', 'FR'),
                            ' ${utf8.decode(car["city"].toString().codeUnits)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xEF65,
                            color: Colors.grey,
                          ),
                          Text(
                            locale: Locale('fr', 'FR'),
                            ' ${car['price']} DH/Jours',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xEEE0,
                            color: Colors.grey,
                          ),
                          Text(
                            ' ${car["trunksize"]} Litres',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xF3EB,
                            color: Colors.grey,
                          ),
                          Text(
                            ' ${car["seats"]} Places',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RemixIcon(
                            icon: 0xF326,
                            color: Colors.grey,
                          ),
                          Text(
                            ' ${car["gear"]}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ADD DATE RANGE PICKER HERE
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.start,
                    "Sélectionnez la période de location",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(32)),
                      border: Border.all(color: Colors.grey, width: .2),
                    ),
                    child: SfDateRangePicker(
                      backgroundColor: Colors.white,
                      view: DateRangePickerView.month,
                      selectionMode: DateRangePickerSelectionMode.range,
                      startRangeSelectionColor:
                          Color.fromARGB(255, 253, 111, 0),
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 10,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        showTrailingAndLeadingDates: true,
                      ),
                      headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            color: Colors.black,
                          )),
                      // Determine which dates should be disabled
                      selectableDayPredicate: (DateTime date) {
                        for (var range in _dates) {
                          if (date.isAfter(DateTime.parse(range['start_date'])
                                  .subtract(const Duration(days: 1))) &&
                              date.isBefore(DateTime.parse(range['end_date'])
                                  .add(const Duration(days: 1)))) {
                            return false;
                          }
                        }
                        return true;
                      },
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) async {
                        if (args.value is PickerDateRange) {
                          setState(() {
                            _selectedDateRange = args.value as PickerDateRange;
                          });
                        }
                      },
                      // Customize the appearance
                      selectionColor: Color.fromARGB(255, 253, 111, 0),
                      endRangeSelectionColor: Color.fromARGB(255, 253, 111, 0),
                      rangeSelectionColor:
                          Color.fromARGB(255, 253, 111, 0).withOpacity(0.1),
                      todayHighlightColor: Color.fromARGB(255, 253, 111, 0),
                    ),
                  ),
                  SizedBox(height: 20),
                  // PUT HERE A TIME PICKER WIDGET
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      DateTime? startDate = _selectedDateRange.startDate;
                      DateTime? endDate = _selectedDateRange.endDate;
                      if (startDate != null && endDate != null) {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 253, 111, 0),
                                  backgroundColor: Colors.white,
                                ),
                              );
                            },
                          );

                          final rentResponse =
                              await ApiService.post('renters/rentCar', {
                            "car": car['id'],
                            "renter": _user,
                            "start": startDate.toString(),
                            "end": endDate.toString(),
                          });
                          if (rentResponse['code'] == 0) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Réservation réussie',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          } else {
                            showCustomSnackBar(context, "Something went wrong");
                          }
                        } catch (e) {
                          showCustomSnackBar(context, "Something went wrong");
                        }
                      } else {
                        showCustomSnackBar(
                          context,
                          "Sélectionez une plage de dates",
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 253, 111, 0),
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Réserver",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

Future<dynamic> carDatils(BuildContext context, dynamic car) {
  return showModalBottomSheet(
    clipBehavior: Clip.hardEdge,
    backgroundColor: Colors.white,
    isScrollControlled: true, // For a larger popup
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: 300,
        maxHeight: MediaQuery.of(context).size.height * 0.75),
    context: context,
    builder: (context) => CarDetails(
      car: car,
    ),
  );
}
