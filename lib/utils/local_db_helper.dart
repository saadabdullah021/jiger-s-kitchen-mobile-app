import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences _preferences;
  static late SharedPref _sharedPref;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _sharedPref = this;
  }

  static SharedPref getInstance() {
    return _sharedPref;
  }

  //add value  in shared pref
  Future<void> addStringToSF(String key, String value) async {
    await _preferences.setString(key, value);
  }

  Future<void> addIntToSF(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  Future<void> addDoubleToSF(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  Future<void> addBoolToSF(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  //get values for shared pref
  String getStringValuesSF(String key) {
    return _preferences.getString(key) ?? '';
  }

  //19 Dec
  String? getLangStringValuesSF(String key) {
    return _preferences.getString(key);
  }

  bool? getBoolValuesSF(String key) {
    //Return bool
    return _preferences.getBool(key);
  }

  int getIntValuesSF(String value) {
    //Return int
    return _preferences.getInt(value) ?? 0;
  }

  double getDoubleValuesSF(String value) {
    //Return double
    return _preferences.getDouble(value) ?? 0.0;
  }

  // String getAccessToken() {
  //   return getStringValuesSF(AppKeys.userToken);
  // }

  // Future<void> setUserToken(String token) async {
  //   await addStringToSF(AppKeys.userToken, token);
  // }

  Future<void> clearSF() async {
    await _preferences.clear();
  }
}
