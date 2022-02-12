import 'package:countries/provider/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountrySearch extends StatefulWidget {
  @override
  _CountrySearchState createState() => _CountrySearchState();
}

class _CountrySearchState extends State<CountrySearch> {
  late CountryProvider countryProvider;
  TextEditingController _countryCodeController = TextEditingController();
  String? name;

  @override
  Widget build(BuildContext context) {
    countryProvider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search by country code'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (name != null)
              Column(
                children: [
                  Card(
                    elevation: 10.0,
                    child: ListTile(
                      title: Text(name!),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            TextFormField(
              controller: _countryCodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Enter country code',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Colors.green[900],
              minWidth: double.infinity,
              elevation: 10.0,
              height: 50,
              onPressed: () async {
                name = await (countryProvider.getCountryNameByCode(context,
                    code: _countryCodeController.text.trim().toUpperCase()));
                _countryCodeController.clear();
              },
              child: Text('Search',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countryCodeController.dispose();
    super.dispose();
  }
}
