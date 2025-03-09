import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/net_asset_list_model.dart';
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

  Future<NetAssetListModel> getNetAssetList() async {
    try {
      final res = await http.get(Uri.parse('$apiUrl/net-asset/net-asset-list'));
      if (res.statusCode == 200) {
        final decode = jsonDecode(utf8.decode(res.bodyBytes));
        return NetAssetListModel.fromJson(decode);
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> updateNetAsset({
    required NetAssetListModel data,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$apiUrl/net-asset/net-asset-update'),
        body: jsonEncode(data),
      );
      debugPrint(jsonEncode(data));
      if (res.statusCode != 200) throw Exception(res.body);
      return true;
    } catch (e) {
      return false;
    }
  }
}
