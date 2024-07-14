import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:currency_converter/data/models/rates_model.dart';
import 'package:currency_converter/data/repositories/local_storage_manager.dart';
import 'package:currency_converter/data/repositories/rates_repository.dart';
import 'package:currency_converter/domain/rates.dart';
import 'package:currency_converter/presentation/components/form_drop_down_input.dart';
import 'package:currency_converter/utils/colors/color_cording.dart';
import 'package:currency_converter/utils/extensions/colors_extension.dart';
import 'package:currency_converter/utils/responsive/screen_sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController inputController = TextEditingController();
  List<TextEditingController> listController = [TextEditingController()];

  List<bool> isIconButtonPressed = [false];

  late Future<RatesModel> rateResults;
  late Future<Map> allCurrencies;
  late String currencyConverter;

  String inputDropDownValue = 'USD';
  List<String> convertedDropDownValue = ['USD'];

  List<String> favoriteCurrencies = [];

  @override
  void initState() {
    super.initState();
    rateResults =
        Rates(rateRepository: RatesServiceImpl()).fetchRatesExecution();
    allCurrencies =
        Rates(rateRepository: RatesServiceImpl()).fetchCurrenciesExecution();

    if (inputController.text.isNotEmpty) {
      inputController.addListener(updateConvertedValues);
    }

    // _loadFavorites();
  }

  @override
  void dispose() {
    inputController.dispose();
    for (var controller in listController) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateConvertedValues() {
    if (rateResults != null && allCurrencies != null) {
      rateResults.then((rateData) {
        allCurrencies.then((currencyData) {
          for (int i = 0; i < listController.length; i++) {
            currencyConverter =
                Rates(rateRepository: RatesServiceImpl()).convertExecution(
              rateData.rates,
              inputController.text,
              inputDropDownValue,
              convertedDropDownValue[i],
            );

            listController[i].text = currencyConverter;
          }
        });
      });
    }
  }

  // void _loadFavorites() async {
  //   setState(() {
  //     final storedFavorites = LocalDataStorageManager.getUserFavorite();

  //     if (storedFavorites != null) {
  //       // Parse storedFavorites into a List<dynamic>
  //       List<dynamic> favoritesList = json.decode(storedFavorites);

  //       // Extract currencies from favoritesList and convert to List<String>
  //       favoriteCurrencies = favoritesList
  //           .map<String>((fav) => fav['currency'].toString())
  //           .toList();

  //       isIconButtonPressed = List<bool>.generate(
  //         listController.length,
  //         (index) => favoriteCurrencies.contains(convertedDropDownValue[index]),
  //       );
  //     }
  //   });
  // }

  Future<void> toggledToFavorite(int index) async {
    setState(() {
      isIconButtonPressed[index] = !isIconButtonPressed[index];
      if (isIconButtonPressed[index]) {
        favoriteCurrencies.add(jsonEncode({
          'value': listController[index].text,
          'currency': convertedDropDownValue[index],
        }));
      } else {
        LocalDataStorageManager.deleteUserFavorite();
      }
    });
    await LocalDataStorageManager.setUserFavorite(
        jsonEncode(favoriteCurrencies));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = displayHeight(context);
    double screenWidth = displayWidth(context);

    return Scaffold(
      backgroundColor: backgroundColor.toColor(),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          reverse: true,
          children: [
            GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Currency Converter",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenHeight * 0.03,
                            color: titleColor.toColor())),
                  ),
                ),
          
                // Input
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.02, left: screenWidth * 0.02),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Input amount",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenHeight * 0.02,
                          color: subtitleColor.toColor()),
                    ),
                  ),
                ),
                FutureBuilder<RatesModel>(
                    future: rateResults,
                    builder: (context, rateSnapshot) {
                      if (rateSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (rateSnapshot.hasData) {
                        return FutureBuilder(
                            future: allCurrencies,
                            builder: (context, currencySnapshot) {
                              if (currencySnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (currencySnapshot.hasData) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.01),
                                  child: Row(
                                    children: [
                                      FormDropDownInput(
                                        controller: inputController,
                                        cardColor: cardColor.toColor(),
                                        textFormFieldColor:
                                            textFormFieldColor.toColor(),
                                        hintColor: hintColor.toColor(),
                                        hintText: "Input amount here",
                                        dropdownWidget: SizedBox(
                                          width: screenWidth * 0.2,
                                          child: DropdownButton<String>(
                                              dropdownColor:dropDownContainerColor.toColor(),
                                              value: inputDropDownValue,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.white,
                                              ),
                                              iconSize: 24,
                                              isExpanded: true,
                                              elevation: 16,
                                              items: currencySnapshot.data!.keys
                                                  .toSet()
                                                  .toList()
                                                  .map<DropdownMenuItem<String>>(
                                                      (val) {
                                                return DropdownMenuItem<String>(
                                                    value: val, child: Text(val));
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  inputDropDownValue = newValue!;
                                                  if (inputController
                                                      .text.isNotEmpty) {
                                                    updateConvertedValues();
                                                  }
                                                });
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
          
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.02, left: screenWidth * 0.02),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Converted amount",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenHeight * 0.02,
                          color: subtitleColor.toColor()),
                    ),
                  ),
                ),
                FutureBuilder<RatesModel>(
                    future: rateResults,
                    builder: (context, rateSnapshot) {
                      if (rateSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (rateSnapshot.hasData) {
                        return FutureBuilder(
                            future: allCurrencies,
                            builder: (context, currencySnapshot) {
                              if (currencySnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (currencySnapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: listController.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: screenHeight * 0.01),
                                        child: Row(
                                          children: [
                                            FormDropDownInput(
                                              cardColor: cardColor.toColor(),
                                              controller: listController[index],
                                              textFormFieldColor:
                                                  textFormFieldColor.toColor(),
                                              hintColor: hintColor.toColor(),
                                              readOnly: true,
                                              hintText: "Converted value",
                                              dropdownWidget: SizedBox(
                                                width: screenWidth * 0.2,
                                                child: DropdownButton<String>(
                                                    dropdownColor:
                                                        dropDownContainerColor
                                                            .toColor(),
                                                    value: convertedDropDownValue[
                                                        index],
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_drop_down_circle,
                                                      color: Colors.white,
                                                    ),
                                                    iconSize: 24,
                                                    isExpanded: true,
                                                    elevation: 16,
                                                    items: currencySnapshot
                                                        .data!.keys
                                                        .toSet()
                                                        .toList()
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((val) {
                                                      return DropdownMenuItem<
                                                              String>(
                                                          value: val,
                                                          child: Text(val));
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        convertedDropDownValue[
                                                            index] = newValue!;
                                                        updateConvertedValues();
                                                      });
                                                    }),
                                              ),
                                            ),
                                            // Adding Favorite
                                            IconButton(
                                                onPressed: () {
                                                  toggledToFavorite(index);
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  size: screenHeight * 0.035,
                                                  color:
                                                      isIconButtonPressed[index]
                                                          ? buttonColorForFavorite.toColor()
                                                          : buttonColorForNotFavorite.toColor(),
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
          
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      left: screenWidth * 0.2,
                      right: screenWidth * 0.2),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        listController.add(TextEditingController());
                        isIconButtonPressed.add(false);
                        convertedDropDownValue.add('USD');
          
                        if (inputController.text.isNotEmpty) {
                          updateConvertedValues();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor.toColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: buttonContentColor.toColor(),
                        ),
                        Text(
                          'Add Converter',
                          style: TextStyle(color: buttonContentColor.toColor()),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          ].reversed.toList(), 
        ),
      ),
    );
  }
}
