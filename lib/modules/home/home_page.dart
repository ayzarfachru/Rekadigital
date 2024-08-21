import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart' as dropDown;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../data/models/provice.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff87CEFA),
      body: Obx(() {
        return (homeController.isLoading.value)
            ? loadingComponent()
            : Container(
                color: homeController.isDayTime.value == 0
                    ? const Color(0xffffca7c)
                    : homeController.isDayTime.value == 1
                        ? const Color(0xff87CEFA)
                        : homeController.isDayTime.value == 2
                            ? const Color(0xfffd9a73)
                            : const Color(0xff0b0b2e),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      buildDropdown(context),
                      buildCarouselSlider(context),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  CarouselSlider buildCarouselSlider(BuildContext context) {
    bool firstBuild = true;
    return CarouselSlider.builder(
      itemCount: homeController.data.length,
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1.0,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        height: MediaQuery.of(context).size.height / 1.1,
        enableInfiniteScroll: true,
        initialPage: 0,
        onPageChanged: (index, reason) {
          if (reason == CarouselPageChangedReason.manual) {
            homeController.getAllDataByIndex(index);
          }
        },
      ),
      itemBuilder: (context, index, realIdx) {
        if (firstBuild && homeController.data.isNotEmpty) {
          firstBuild = false;
          homeController.getAllDataByIndex(index);
        }
        return Obx(() {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTopData(index),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    buildWaveWidget(),
                    Column(
                      children: [
                        buildTabText(context, index),
                        (homeController.allTimeranges.isEmpty)
                            ? const SizedBox(
                                height: 15,
                              )
                            : const SizedBox(
                                height: 30,
                              ),
                        buildBottomData(context),
                        (homeController.allTimeranges.isEmpty)
                            ? const SizedBox(
                                height: 15,
                              )
                            : const SizedBox(),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Expanded buildTopData(int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            homeController.data[index].name.toString(),
            style: GoogleFonts.poppins(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (homeController.showT.value.value.toString().contains('Data'))
                    ? Image.asset(
                        alignment: Alignment.bottomCenter,
                        width: 180,
                        height: 180,
                        'assets/404.png',
                        fit: BoxFit.contain,
                      )
                    : buildTopCelciusText(),
                (homeController.showT.value.value.toString().contains('Data'))
                    ? Text(
                        homeController.showT.value.value.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: (homeController.showT.value.value
                                    .toString()
                                    .contains('Data'))
                                ? 20
                                : 76,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      )
                    : Column(
                        children: [
                          Text(
                            homeController.showDateNow.value.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            homeController.showWeatherText.value.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (homeController.showT.value.value.toString().contains('Data'))
              ? const SizedBox()
              : Image.asset(
                  alignment: Alignment.bottomCenter,
                  width: 130,
                  height: 130,
                  'assets/icons/${homeController.showWeather.value.value}.png',
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      alignment: Alignment.bottomCenter,
                      width: 130,
                      height: 130,
                      'assets/icons/3.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  SizedBox buildBottomData(BuildContext context) {
    return SizedBox(
      height: 165,
      width: MediaQuery.of(context).size.width,
      child: (homeController.allTimeranges.isEmpty)
          ? Container(
              width: MediaQuery.of(context).size.width / 4,
              alignment: Alignment.center,
              child: Text(
                'Data belum tersedia.',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: const Color(0xffc2c2c2),
                    fontWeight: FontWeight.w400),
              ),
            )
          : ListView.builder(
              itemCount: homeController.allTimeranges.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${homeController.allTimeranges[index].datetime.substring(8, 12).substring(0, 2)}:${homeController.allTimeranges[index].datetime.substring(8, 12).substring(2, 4)}',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Image.asset(
                        width: 40,
                        height: 40,
                        'assets/bw_icons/${homeController.allWeathers[index].values.first.value}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            width: 40,
                            height: 40,
                            'assets/bw_icons/3.png',
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                      Text(
                        '${homeController.allTimeranges[index].values.first.value}\u00B0C',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Container buildTabText(BuildContext context, index) {
    return (homeController.showT.value.value.toString().contains('Data'))
        ? Container()
        : Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffc2c2c2)))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      homeController.changeNow(index);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: homeController.isTomorrow.value
                                      ? Colors.transparent
                                      : Colors.black))),
                      child: Text(
                        'Hari ini',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: homeController.isTomorrow.value
                                ? const Color(0xffc2c2c2)
                                : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      homeController.changeTomorrow(index);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: homeController.isTomorrow.value
                                      ? Colors.black
                                      : Colors.transparent))),
                      child: Text(
                        'Besok',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: homeController.isTomorrow.value
                                ? Colors.black
                                : const Color(0xffc2c2c2),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Text buildTopCelciusText() {
    return Text(
      (homeController.isLoadingCarousel.value == true)
          ? 'Tunggu...'
          : '${homeController.showT.value.value.toString()}\u00B0C',
      style: GoogleFonts.poppins(
          fontSize:
              (homeController.showT.value.value.toString().contains('Data'))
                  ? 20
                  : 76,
          color: Colors.white,
          fontWeight: FontWeight.w400),
    );
  }

  DropdownButtonHideUnderline buildDropdown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: dropDown.DropdownButton2<ProvinceModel>(
        isExpanded: true,
        alignment: Alignment.center,
        customButton: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              homeController.provinceNow.value.toString(),
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            )
          ],
        ),
        items: homeController.provinceData.map((ProvinceModel item) {
          return DropdownMenuItem<ProvinceModel>(
            value: item,
            child: Text(
              textAlign: TextAlign.center,
              item.name,
              style: const TextStyle(
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        // value: homeController.provinceSelected,
        onChanged: (ProvinceModel? value) {
          homeController.fetchData(value!);
        },
        dropdownStyleData: dropDown.DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height / 2.5,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const dropDown.MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }

  WaveWidget buildWaveWidget() {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(1.0),
        ],
        durations: [4000, 5000, 7000],
        heightPercentages: [0.01, 0.05, 0.03],
        blur: const MaskFilter.blur(BlurStyle.solid, 5),
      ),
      waveAmplitude: 20.00,
      waveFrequency: 3,
      size: const Size(
        double.infinity,
        325,
      ),
    );
  }

  Center loadingComponent() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.white,
    ));
  }
}
