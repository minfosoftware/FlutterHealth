import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

void main() => runApp(HealthApp());

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double _mgdl = 10.0;

  late DateTime startDataDate, endDataDate;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    super.initState();

    updateDate('0');
  }

  updateDate(String updateBy) {
    setState(() {
      if (updateBy == '0') {
        startDataDate = DateTime.now();
        endDataDate = DateTime.now();
        startDataDate = DateTime(
          startDataDate.year,
          startDataDate.month,
          startDataDate.day,
        );
      } else if (updateBy == '+1') {
        startDataDate = startDataDate.add(const Duration(days: 1));
        startDataDate = DateTime(
          startDataDate.year,
          startDataDate.month,
          startDataDate.day,
        );
        endDataDate = DateTime(startDataDate.year, startDataDate.month,
            startDataDate.day, 23, 59, 59);
      } else if (updateBy == '-1') {
        startDataDate = startDataDate.add(const Duration(days: -1));
        startDataDate = DateTime(
          startDataDate.year,
          startDataDate.month,
          startDataDate.day,
        );
        endDataDate = DateTime(startDataDate.year, startDataDate.month,
            startDataDate.day, 23, 59, 59);
      }

      print('$startDataDate to $endDataDate');

      fetchData(startDataDate, endDataDate);
    });
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData(startDataDate, endDataDate) async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final forAndroidTypes = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
      HealthDataType.HEIGHT,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.MOVE_MINUTES,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.WATER,
      HealthDataType.WORKOUT,
    ];

    final foriOSTypes = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BASAL_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.ELECTRODERMAL_ACTIVITY,
      HealthDataType.HEART_RATE,
      HealthDataType.HEIGHT,
      HealthDataType.RESTING_HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.WAIST_CIRCUMFERENCE,
      HealthDataType.WALKING_HEART_RATE,
      HealthDataType.WEIGHT,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.FLIGHTS_CLIMBED,
      HealthDataType.MINDFULNESS,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.WATER,
      HealthDataType.EXERCISE_TIME,
      HealthDataType.WORKOUT,
      HealthDataType.HIGH_HEART_RATE_EVENT,
      HealthDataType.LOW_HEART_RATE_EVENT,
      HealthDataType.IRREGULAR_HEART_RATE_EVENT,
      HealthDataType.HEART_RATE_VARIABILITY_SDNN,
      HealthDataType.HEADACHE_NOT_PRESENT,
      HealthDataType.HEADACHE_MILD,
      HealthDataType.HEADACHE_MODERATE,
      HealthDataType.HEADACHE_SEVERE,
      HealthDataType.HEADACHE_UNSPECIFIED,
      HealthDataType.AUDIOGRAM,
    ];

    // with coresponsing permissions
    final androidPermissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    // with coresponsing permissions
    final iOSPermissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    /*final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 5));*/

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.

    bool requested = await health.requestAuthorization(Platform.isAndroid ? forAndroidTypes : foriOSTypes,
        permissions: Platform.isAndroid ? androidPermissions : iOSPermissions);

    debugPrint('requested: $requested');

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDataDate, endDataDate, Platform.isAndroid ? forAndroidTypes : foriOSTypes);

        _healthDataList.clear();
        _healthDataList.addAll(healthData);

        // filter out duplicates
        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

        // print the results
        for (var x in _healthDataList) {
          debugPrint(x.toString());
        }

        // update the UI to display the results
        setState(() {
          _state =
              _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
        });
      } catch (error) {
        debugPrint("Exception in getHealthDataFromTypes: $error");
      }
    } else {
      debugPrint("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  /// Add some random health data.
  Future addData() async {

    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.WORKOUT, // Requires Google Fit on Android
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM,
    ];
    final rights = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      // HealthDataAccess.WRITE
    ];
    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      // HealthDataAccess.READ_WRITE,
    ];
    late bool perm;
    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      perm = await health.requestAuthorization(types, permissions: permissions);
    }

    // Store a count of steps taken
    _nofSteps = Random().nextInt(10);
    bool success = await health.writeHealthData(
        _nofSteps.toDouble(), HealthDataType.STEPS, earlier, now);

    // Store a height
    success &=
        await health.writeHealthData(1.93, HealthDataType.HEIGHT, earlier, now);

    // Store a Blood Glucose measurement
    _mgdl = Random().nextInt(10) * 1.0;
    success &= await health.writeHealthData(
        _mgdl, HealthDataType.BLOOD_GLUCOSE, now, now);

    // Store a workout eg. running
    success &= await health.writeWorkoutData(
      HealthWorkoutActivityType.RUNNING, earlier, now,
      // The following are optional parameters
      // and the UNITS are functional on iOS ONLY!
      totalEnergyBurned: 230,
      totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      totalDistance: 1234,
      totalDistanceUnit: HealthDataUnit.FOOT,
    );

    // Store an Audiogram
    // Uncomment these on iOS - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];

    // success &= await health.writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData(startDataDate, endDataDate) async {

    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);

        debugPrint('Total number of steps: $steps');

        setState(() {
          _nofSteps = (steps == null) ? 0 : steps;
          _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
        });
      } catch (error) {
        debugPrint("Caught exception in getTotalStepsInInterval: $error");
      }
    } else {
      debugPrint("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              strokeWidth: 10,
            ),
        ),
        const Text('Fetching data...'),
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text(p.unitString),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          } else if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.typeToString()}"),
              trailing: Text((p.value as WorkoutHealthValue)
                  .workoutActivityType
                  .typeToString()),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          } else {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text(p.unitString),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
        });
  }

  Widget _contentNoData() {
    return const Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
    );
  }

  Widget _authorizationNotGranted() {
    return const Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return const Text('Data points inserted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return const Text('Failed to add data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) {
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA) {
      return _contentNoData();
    } else if (_state == AppState.FETCHING_DATA) {
      return _contentFetchingData();
    } else if (_state == AppState.AUTH_NOT_GRANTED) {
      return _authorizationNotGranted();
    } else if (_state == AppState.DATA_ADDED) {
      return _dataAdded();
    } else if (_state == AppState.STEPS_READY) {
      return _stepsFetched();
    } else if (_state == AppState.DATA_NOT_ADDED) {
      return _dataNotAdded();
    }

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Health Example'),
            actions: <Widget>[
              /*IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: () {
                  fetchData();
                },
              ),*/
              /*IconButton(
                onPressed: () {
                  addData();
                },
                icon: const Icon(Icons.add),
              ),*/
              IconButton(
                onPressed: () {
                  fetchStepData(startDataDate, endDataDate);
                },
                icon: const Icon(Icons.nordic_walking),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'icons/back_arrow.png',
                        height: 15,
                        width: 25,
                      ),
                      onPressed: () {
                        updateDate('-1');
                      },
                    ),
                    Text(DateFormat('dd MMM yyyy').format(startDataDate),
                        style: const TextStyle(fontSize: 20)),
                    IconButton(
                      icon: Image.asset(
                        'icons/right_arrow_icon.png',
                        height: 15,
                        width: 25,
                      ),
                      onPressed: () {
                        if(endDataDate.compareTo(DateTime.now()) < 0){
                          updateDate('+1');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: _content(),
                ),
              ],
            ),
          )),
    );
  }
}
