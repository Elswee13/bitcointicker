import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String SelectedCurrency = 'USD';

//method for the loop list of currencies.
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currencies in currenciesList) {
      var newitem = DropdownMenuItem(
        child: Text(currencies),
        value: currencies,
      );
      dropdownItems.add(newitem);
    }

    return DropdownButton<String>(
      value: SelectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          SelectedCurrency = value!;
        });
      },
    );
  }

  // method created to create a loop list to get our currencies being used.
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currencies in currenciesList) {
      pickerItems.add(Text(
        currencies,
        style: TextStyle(color: Colors.white),
      ));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

//other way to implement this method in the widget child is:
// Platform.isIOS? iOSPicker(): androidDropdown;
  Widget? getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  //This variable is to hold the value and use in our Text Widget.
  // Giving the variable a starting value of '?' before the data comes back from the async methods.
  String value = '?';

  //This is the async method here await the coin data from coin_data.dart
  void getData() async {
    try {
      double data = await CoinData().getCoinData(SelectedCurrency);
      //Can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        value = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //This is to call getData() when the screen loads up.
    // We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  //Update the Text Widget with the data in bitcoinValueInUSD.
                  '1 BTC = $value USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
