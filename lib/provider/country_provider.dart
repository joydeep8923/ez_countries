import 'dart:convert';

import 'package:countries/model/country_model.dart';
import 'package:countries/services/network.dart';
import 'package:flutter/material.dart';


class CountryProvider extends ChangeNotifier {
  Network _network = Network();
  List<CountryElements>? _countries = [];
  List<Language> _languages = [];
  CountryElements? _country;

  List<CountryElements>? get countries => _countries;
  List<Language> get languages => _languages;

  CountryElements? get country => _country;

  Future refreshScreen() async {
    notifyListeners();
  }

  Future getCountryName() async {
    final result = await _network.getAllCountries();
    final decode = jsonDecode(result);
    final parse = Data.fromJson(decode);
    _countries = parse.countries;
    _countries!.sort((a, b) => a.countryName!.compareTo(b.countryName!));

    notifyListeners();
  }

  Future getLanguages() async {
    final result = await _network.getLanguages();
    final decode = jsonDecode(result);
    for(var l in decode) {
      languages.add(Language.fromJson(l));
    }

    notifyListeners();
  }

  Future getCountryNameByCode(context, {String? code}) async {
    final result = await _network.getCountryByCode(context, code: code);
    if (result != null) {
      final decode = jsonDecode(result);
      if (decode['country'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Country Code doesn't exists"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      final parse = CountryElements.fromJson(decode['country']);
      _country = parse;

      notifyListeners();
      return parse.countryName;
    }
  }
}
