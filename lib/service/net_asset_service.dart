import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/net_asset_model.dart';
import 'package:http/http.dart' as http;

class NetAssetService {
  final apiUrl = dotenv.env['API_URL'];

  Future<NetAssetModel> getNetAsset() async {
    try {
      final res = await http.get(Uri.parse('$apiUrl/net-asset/net-asset'));
      if (res.statusCode == 200) {
        return NetAssetModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
