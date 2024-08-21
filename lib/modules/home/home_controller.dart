import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

import '../../data/models/provice.dart';
import '../../data/models/xml.dart';
import '../../data/network.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  List<ProvinceModel> provinceData = [
    ProvinceModel(
      name: 'Indonesia',
      xml: 'DigitalForecast-Indonesia.xml',
    ),
    ProvinceModel(
      name: 'Aceh',
      xml: 'DigitalForecast-Aceh.xml',
    ),
    ProvinceModel(
      name: 'Bali',
      xml: 'DigitalForecast-Bali.xml',
    ),
    ProvinceModel(
      name: 'Bangka Belitung',
      xml: 'DigitalForecast-BangkaBelitung.xml',
    ),
    ProvinceModel(
      name: 'Banten',
      xml: 'DigitalForecast-Banten.xml',
    ),
    ProvinceModel(
      name: 'Bengkulu',
      xml: 'DigitalForecast-Bengkulu.xml',
    ),
    ProvinceModel(
      name: 'D.I. Yogyakarta',
      xml: 'DigitalForecast-DIYogyakarta.xml',
    ),
    ProvinceModel(
      name: 'DKI Jakarta',
      xml: 'DigitalForecast-DKIJakarta.xml',
    ),
    ProvinceModel(
      name: 'Gorontalo',
      xml: 'DigitalForecast-Gorontalo.xml',
    ),
    ProvinceModel(
      name: 'Jambi',
      xml: 'DigitalForecast-Jambi.xml',
    ),
    ProvinceModel(
      name: 'Jawa Barat',
      xml: 'DigitalForecast-JawaBarat.xml',
    ),
    ProvinceModel(
      name: 'Jawa Tengah',
      xml: 'DigitalForecast-JawaTengah.xml',
    ),
    ProvinceModel(
      name: 'Jawa Timur',
      xml: 'DigitalForecast-JawaTimur.xml',
    ),
    ProvinceModel(
      name: 'Kalimantan Barat',
      xml: 'DigitalForecast-KalimantanBarat.xml',
    ),
    ProvinceModel(
      name: 'Kalimantan Selatan',
      xml: 'DigitalForecast-KalimantanSelatan.xml',
    ),
    ProvinceModel(
      name: 'Kalimantan Tengah',
      xml: 'DigitalForecast-KalimantanTengah.xml	',
    ),
    ProvinceModel(
      name: 'Kalimantan Timur',
      xml: 'DigitalForecast-KalimantanTimur.xml',
    ),
    ProvinceModel(
      name: 'Kalimantan Utara',
      xml: 'DigitalForecast-KalimantanUtara.xml',
    ),
    ProvinceModel(
      name: 'Kepulauan Riau',
      xml: 'DigitalForecast-KepulauanRiau.xml',
    ),
    ProvinceModel(
      name: 'Lampung',
      xml: 'DigitalForecast-Lampung.xml',
    ),
    ProvinceModel(
      name: 'Maluku',
      xml: 'DigitalForecast-Maluku.xml',
    ),
    ProvinceModel(
      name: 'Maluku Utara',
      xml: 'DigitalForecast-MalukuUtara.xml',
    ),
    ProvinceModel(
      name: 'Nusa Tenggara Barat',
      xml: 'DigitalForecast-NusaTenggaraBarat.xml',
    ),
    ProvinceModel(
      name: 'Nusa Tenggara Timur',
      xml: 'DigitalForecast-NusaTenggaraTimur.xml',
    ),
    ProvinceModel(
      name: 'Papua',
      xml: 'DigitalForecast-Papua.xml',
    ),
    ProvinceModel(
      name: 'Papua Barat',
      xml: 'DigitalForecast-PapuaBarat.xml',
    ),
    ProvinceModel(
      name: 'Riau',
      xml: 'DigitalForecast-Riau.xml',
    ),
    ProvinceModel(
      name: 'Sulawesi Barat',
      xml: 'DigitalForecast-SulawesiBarat.xml',
    ),
    ProvinceModel(
      name: 'Sulawesi Selatan',
      xml: 'DigitalForecast-SulawesiSelatan.xml',
    ),
    ProvinceModel(
      name: 'Sulawesi Tengah',
      xml: 'DigitalForecast-SulawesiTengah.xml',
    ),
    ProvinceModel(
      name: 'Sulawesi Tenggara',
      xml: 'DigitalForecast-SulawesiTenggara.xml',
    ),
    ProvinceModel(
      name: 'Sulawesi Utara',
      xml: 'DigitalForecast-SulawesiUtara.xml',
    ),
    ProvinceModel(
      name: 'Sumatera Barat',
      xml: 'DigitalForecast-SumateraBarat.xml',
    ),
    ProvinceModel(
      name: 'Sumatera Selatan',
      xml: 'DigitalForecast-SumateraSelatan.xml',
    ),
    ProvinceModel(
      name: 'Sumatera Utara',
      xml: 'DigitalForecast-SumateraUtara.xml',
    ),
  ].obs;

  var isLoading = true.obs;
  var isLoadingCarousel = true.obs;

  // Show name of province now
  var provinceNow = ''.obs;

  // List of City Dropdown
  List<AreaData> data = <AreaData>[].obs;

  // Background
  var isDayTime = 0.obs;

  // logic getAllDataByIndex()
  var dateNow = ''.obs;
  var dateTomorrow = ''.obs;

  // Show UI
  var showDateNow = ''.obs;

  // logic for change celcius
  var isCelcius = true.obs;

  // Show t
  Rx<ValueData> showT = ValueData('', '').obs;

  // Show weather
  Rx<ValueData> showWeather = ValueData('', '').obs;
  var showWeatherText = ''.obs;

  RxList<TimerangeData> allTimeranges = <TimerangeData>[].obs;
  RxList<TimerangeData> allWeathers = <TimerangeData>[].obs;

  var isTomorrow = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity().then((_) {
      fetchData(provinceData[0]);
      _checkTime();
      Timer.periodic(const Duration(seconds: 1), (timer) => _checkTime());
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connected to the internet
        print('Connected to the internet!');
      } else {
        // No internet connection
        Get.toNamed('/check_connectivity');
        print('No internet connection.');
      }
    } on SocketException catch (_) {
      // No internet connection
      Get.toNamed('/check_connectivity');
      print('No internet connection.');
    }
  }

  void _checkTime() {
    DateTime now = DateTime.now();
    DateTime setDate =
        DateTime(now.year, 7, now.day, now.hour, now.minute, now.second);
    DateTime setDateTomorrow =
    DateTime(now.year, 7, now.day+1, now.hour, now.minute, now.second);
    dateNow.value = DateFormat('yyyyMMddHHmm').format(setDate).toString();
    dateTomorrow.value = DateFormat('yyyyMMddHHmm').format(setDateTomorrow).toString();

    String setShowDateNow = DateFormat('EEEE, dd MMMM hh:mm').format(setDate);

    showDateNow.value = setShowDateNow.toString();

    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 6) {
      isDayTime.value = 0;
    } else if (hour >= 6 && hour < 17) {
      isDayTime.value = 1;
    } else if (hour >= 17 && hour < 18) {
      isDayTime.value = 2;
    } else {
      isDayTime.value = 3;
    }
  }

  void changeNow(index) {
    isTomorrow(false);
    getAllDataByIndex(index);
  }

  void changeTomorrow(index) {
    isTomorrow(true);
    getAllDataByIndex(index);
  }

  void getAllDataByIndex(index) {
    isLoadingCarousel(true);

    if (data[index].parameters.isEmpty) {
      showT.value = ValueData('Data Tidak Ditemukan', '');
      allTimeranges.value = [];
      isLoadingCarousel(false);
    } else {
      ParameterData? temperatureParameter = data[index]
          .parameters
          .firstWhereOrNull((parameter) => parameter.id == 't');

      ParameterData? weatherParameter = data[index]
          .parameters
          .firstWhereOrNull((parameter) => parameter.id == 'weather');

      if (temperatureParameter != null) {
        List<TimerangeData> timeranges = temperatureParameter.timeranges;
        allTimeranges.value = timeranges.where((timerange) {
          String datePart = timerange.datetime.substring(0, 8);
          if (isTomorrow.value) {
            return datePart == dateTomorrow.toString().substring(0, 8);
          } else {
            return datePart == dateNow.toString().substring(0, 8);
          }
        }).toList();
        int indexWhereConditionMet = -1;

        for (int i = 0; i < timeranges.length; i++) {
          TimerangeData timerange = timeranges[i];
          if (int.parse(dateNow.toString()) <
              int.parse(timerange.datetime.toString())) {
            indexWhereConditionMet = i;
            showT.value = timeranges[indexWhereConditionMet - 1].values.first;
            isLoadingCarousel(false);
            break;
          }
        }

        if (indexWhereConditionMet == -1) {
          print('No match found where the condition t is met.');
        }
      } else {
        print('No parameter with id "t" found.');
      }

      if (weatherParameter != null) {
        final hour = DateTime.now().hour;

        List<TimerangeData> timeranges = weatherParameter.timeranges;
        allWeathers.value = timeranges.where((timerange) {
          String datePart = timerange.datetime.substring(0, 8);
          if (isTomorrow.value) {
            return datePart == dateTomorrow.toString().substring(0, 8);
          } else {
            return datePart == dateNow.toString().substring(0, 8);
          }
        }).toList();
        int indexWhereConditionMet = -1;

        for (int i = 0; i < timeranges.length; i++) {
          TimerangeData timerange = timeranges[i];

          if (int.parse(dateNow.toString()) <
              int.parse(timerange.datetime.toString())) {
            indexWhereConditionMet = i;
            if (timeranges[
                            indexWhereConditionMet - 1]
                        .values
                        .first
                        .value
                        .toString() ==
                    '0' ||
                timeranges[indexWhereConditionMet - 1]
                        .values
                        .first
                        .value
                        .toString() ==
                    '1' ||
                timeranges[indexWhereConditionMet - 1]
                        .values
                        .first
                        .value
                        .toString() ==
                    '2') {
              if (hour >= 5 && hour < 18) {
                showWeather.value =
                    timeranges[indexWhereConditionMet - 1].values.first;
              } else {
                showWeather.value = ValueData(
                    '${timeranges[indexWhereConditionMet - 1].values.first.value}n',
                    timeranges[indexWhereConditionMet - 1].values.first.unit);
              }
            } else {
              showWeather.value =
                  timeranges[indexWhereConditionMet - 1].values.first;
            }

            if (showWeather.value.value.toString().replaceAll('n', '') == '0') {
              showWeatherText.value = 'Cerah';
            } else if (showWeather.value.value.toString().replaceAll('n', '') ==
                    '1' ||
                showWeather.value.value.toString().replaceAll('n', '') == '2') {
              showWeatherText.value = 'Cerah Berawan';
            } else if (showWeather.value.value.toString() == '3') {
              showWeatherText.value = 'Berawan';
            } else if (showWeather.value.value.toString() == '4') {
              showWeatherText.value = 'Berawan Tebal';
            } else if (showWeather.value.value.toString() == '5') {
              showWeatherText.value = 'Udara Kabur';
            } else if (showWeather.value.value.toString() == '10') {
              showWeatherText.value = 'Asap';
            } else if (showWeather.value.value.toString() == '45') {
              showWeatherText.value = 'Kabut';
            } else if (showWeather.value.value.toString() == '60') {
              showWeatherText.value = 'Hujan Ringan';
            } else if (showWeather.value.value.toString() == '61') {
              showWeatherText.value = 'Hujan Sedang';
            } else if (showWeather.value.value.toString() == '63') {
              showWeatherText.value = 'Hujan Lebat';
            } else if (showWeather.value.value.toString() == '80') {
              showWeatherText.value = 'Hujan Lokal';
            } else {
              showWeatherText.value = 'Hujan Petir';
            }
            break;
          }
        }

        if (indexWhereConditionMet == -1) {
          print('No match found where the condition weather is met.');
        }
      } else {
        print('No parameter with id "weather" found.');
      }
    }
  }

  void fetchData(ProvinceModel list) async {
    isLoading(true);
    provinceNow.value = list.name;
    var enpoint = '/DataMKG/MEWS/DigitalForecast/${list.xml}';

    try {
      final response = await apiService.fetchData(enpoint);

      if (response.statusCode == 200) {
        final xmlDoc = XmlDocument.parse(response.body.toString());
        final forecastElement =
            xmlDoc.rootElement.findElements('forecast').first;
        final areaElements = forecastElement.findElements('area');

        data = areaElements.map((areaElement) {
          final areaId = areaElement.getAttribute('id')!;
          final areaName = areaElement.findElements('name').last.innerText;
          final parameters =
              areaElement.findElements('parameter').map((parameterElement) {
            final parameterId = parameterElement.getAttribute('id')!;
            final parameterDescription =
                parameterElement.getAttribute('description')!;
            final parameterType = parameterElement.getAttribute('type')!;
            final timeranges = parameterElement
                .findElements('timerange')
                .map((timerangeElement) {
              final timerangeType = timerangeElement.getAttribute('type')!;
              final datetime = timerangeElement.getAttribute('datetime')!;
              final values =
                  timerangeElement.findElements('value').map((valueElement) {
                final value = valueElement.text;
                final unit = valueElement.getAttribute('unit')!;
                return ValueData(value, unit);
              }).toList();
              return TimerangeData(timerangeType, datetime, values);
            }).toList();
            return ParameterData(
                parameterId, parameterDescription, parameterType, timeranges);
          }).toList();
          return AreaData(areaId, areaName, parameters);
        }).toList();
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
