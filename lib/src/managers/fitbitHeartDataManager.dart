import 'package:logger/logger.dart';

import 'package:fitbitter/src/utils/formats.dart';

import 'package:fitbitter/src/urls/fitbitAPIURL.dart';

import 'package:fitbitter/src/data/fitbitData.dart';
import 'package:fitbitter/src/data/fitbitHeartData.dart';

import 'package:fitbitter/src/managers/fitbitDataManager.dart';

/// [FitbitHeartDataManager] is a class the manages the requests related to
/// [FitbitHeartData].
class FitbitHeartDataManager extends FitbitDataManager {
  FitbitHeartDataManager({String clientID, String clientSecret})
      : super(
          clientID: clientID,
          clientSecret: clientSecret,
        );

  @override
  Future<List<FitbitData>> fetch(FitbitAPIURL fitbitUrl) async {
    // Get the response
    final response = await getResponse(fitbitUrl);

    // Debugging
    final logger = Logger();
    logger.i('$response');

    //Extract data and return them
    List<FitbitData> ret = _extractFitbitHeartData(response, fitbitUrl.userID);
    return ret;
  } // fetch

  /// A private method that extracts [FitbitHeartData] from the given response.
  List<FitbitHeartData> _extractFitbitHeartData(
      dynamic response, String userId) {
    final data = response['activities-heart'];
    List<FitbitHeartData> heartDataPoints =
        List<FitbitHeartData>.empty(growable: true);

    for (var record = 0; record < data.length; record++) {
      heartDataPoints.add(FitbitHeartData(
        encodedId: userId,
        dateOfMonitoring:
            Formats.onlyDayDateFormatTicks.parse(data[record]['dateTime']),
        caloriesOutOfRange: data[record]['value']['heartRateZones'][0]
                ['caloriesOut']
            .toDouble(),
        minimumOutOfRange: data[record]['value']['heartRateZones'][0]['min'],
        minutesOutOfRange: data[record]['value']['heartRateZones'][0]
            ['minutes'],
        caloriesFatBurn: data[record]['value']['heartRateZones'][1]
                ['caloriesOut']
            .toDouble(),
        minimumFatBurn: data[record]['value']['heartRateZones'][1]['min'],
        minutesFatBurn: data[record]['value']['heartRateZones'][1]['minutes'],
        caloriesCardio: data[record]['value']['heartRateZones'][2]
                ['caloriesOut']
            .toDouble(),
        minimumCardio: data[record]['value']['heartRateZones'][2]['min'],
        minutesCardio: data[record]['value']['heartRateZones'][2]['minutes'],
        caloriesPeak: data[record]['value']['heartRateZones'][3]['caloriesOut']
            .toDouble(),
        minimumPeak: data[record]['value']['heartRateZones'][3]['min'],
        minutesPeak: data[record]['value']['heartRateZones'][3]['minutes'],
        restingHeartRate: data[record]['value']['restingHeartRate'],
      ));
    } // for entry
    return heartDataPoints;
  } // _extractFitbitHeartData

} // FitbitAccountDataManager
