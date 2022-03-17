import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const coinAPIURL = 'rest.coinapi.io';
const apiKey = '855916BE-0949-4221-B77B-764F0EDC87AE';

class CoinData {
  //3. Create the Asynchronous method getCoinData() that returns a Future (the price data).
  Future getCoinData(SelectedCurrency) async {
    //4. Create a url combining the coinAPIURL with the currencies we're interested, BTC to USD.
    var requestURL = Uri.http('$coinAPIURL',
        '/v1/exchangerate/BTC/USD?apikey=$apiKey', {'q': '{http}'});
    //creating a GET request to the URL and wait for the response.
    var response = await http.get(requestURL);
    // http.Response response = await http.get(requestURL);

    //Check that the request was successful.
    if (response.statusCode == 200) {
      // Using the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
      var decodedData = jsonDecode(response.body);
      // Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['rate'];
      // Output the lastPrice from the method.
      return lastPrice;
    } else {
      // Handle any errors that occur during the request.
      print(response.statusCode);
      //throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
