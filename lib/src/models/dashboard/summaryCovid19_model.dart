// To parse this JSON data, do
//
//     final summaryCovid19Model = summaryCovid19ModelFromJson(jsonString);

import 'dart:convert';

SummaryCovid19Model summaryCovid19ModelFromJson(String str) =>
    SummaryCovid19Model.fromJson(json.decode(str));

String summaryCovid19ModelToJson(SummaryCovid19Model data) =>
    json.encode(data.toJson());

class SummaryCovid19Model {
  SummaryCovid19Model({
    this.global,
    this.countries,
    this.date,
  });

  Global global;
  List<Country> countries;
  DateTime date;

  factory SummaryCovid19Model.fromJson(Map<String, dynamic> json) =>
      SummaryCovid19Model(
        global: Global.fromJson(json["Global"]),
        countries: List<Country>.from(
            json["Countries"].map((x) => Country.fromJson(x))),
        date: DateTime.parse(json["Date"]),
      );

  Map<String, dynamic> toJson() => {
        "Global": global.toJson(),
        "Countries": List<dynamic>.from(countries.map((x) => x.toJson())),
        "Date": date.toIso8601String(),
      };
}

class Country {
  Country({
    this.country,
    this.countryCode,
    this.slug,
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
    this.date,
    this.premium,
  });

  String country;
  String countryCode;
  String slug;
  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;
  DateTime date;
  Premium premium;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["Country"],
        countryCode: json["CountryCode"],
        slug: json["Slug"],
        newConfirmed: json["NewConfirmed"],
        totalConfirmed: json["TotalConfirmed"],
        newDeaths: json["NewDeaths"],
        totalDeaths: json["TotalDeaths"],
        newRecovered: json["NewRecovered"],
        totalRecovered: json["TotalRecovered"],
        date: DateTime.parse(json["Date"]),
        premium: Premium.fromJson(json["Premium"]),
      );

  Map<String, dynamic> toJson() => {
        "Country": country,
        "CountryCode": countryCode,
        "Slug": slug,
        "NewConfirmed": newConfirmed,
        "TotalConfirmed": totalConfirmed,
        "NewDeaths": newDeaths,
        "TotalDeaths": totalDeaths,
        "NewRecovered": newRecovered,
        "TotalRecovered": totalRecovered,
        "Date": date.toIso8601String(),
        "Premium": premium.toJson(),
      };
}

class Premium {
  Premium();

  factory Premium.fromJson(Map<String, dynamic> json) => Premium();

  Map<String, dynamic> toJson() => {};
}

class Global {
  Global({
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
  });

  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;

  factory Global.fromJson(Map<String, dynamic> json) => Global(
        newConfirmed: json["NewConfirmed"],
        totalConfirmed: json["TotalConfirmed"],
        newDeaths: json["NewDeaths"],
        totalDeaths: json["TotalDeaths"],
        newRecovered: json["NewRecovered"],
        totalRecovered: json["TotalRecovered"],
      );

  Map<String, dynamic> toJson() => {
        "NewConfirmed": newConfirmed,
        "TotalConfirmed": totalConfirmed,
        "NewDeaths": newDeaths,
        "TotalDeaths": totalDeaths,
        "NewRecovered": newRecovered,
        "TotalRecovered": totalRecovered,
      };
}
