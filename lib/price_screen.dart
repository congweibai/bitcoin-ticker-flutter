import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'dart:io' show Platform;
import 'networking.dart';

const apiKey = '';
const CoinApiURL = 'https://rest.coinapi.io/v1/exchangerate';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    getResult();
  }

  String selectedCurrency = 'USD';
  String currentBTCRate = '?';
  String currentETHRate = '?';
  String currentLTCRate = '?';
  void getResult() async {
    NetworkHelper networkHelper =
        NetworkHelper('$CoinApiURL/BTC/$selectedCurrency?apikey=$apiKey');
    var resultBTC = await networkHelper.getData();

    NetworkHelper networkHelper2 =
        NetworkHelper('$CoinApiURL/ETH/$selectedCurrency?apikey=$apiKey');
    var resultETH = await networkHelper2.getData();

    NetworkHelper networkHelper3 =
        NetworkHelper('$CoinApiURL/LTC/$selectedCurrency?apikey=$apiKey');
    var resultLTC = await networkHelper3.getData();

    setState(() {
      currentBTCRate = resultBTC['rate'].toInt().toString();
      currentETHRate = resultETH['rate'].toInt().toString();
      currentLTCRate = resultLTC['rate'].toInt().toString();
    });
  }

  CupertinoPicker iOSPicker() {
    List<Text> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      dropdownItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getResult();
        });
      },
      children: dropdownItems,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getResult();
        });
      },
    );
  }

  dynamic whichRate(type) {
    if (type == 'BTC') {
      return currentBTCRate;
    } else if (type == 'ETH') {
      return currentETHRate;
    } else {
      return currentLTCRate;
    }
  }

  List<Card> getCyptoCards() {
    List<Card> cardItems = [];
    for (String cyptoItem in cryptoList) {
      var newItem = Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cyptoItem = ${whichRate(cyptoItem)} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
      cardItems.add(newItem);
    }
    return cardItems;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCyptoCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
