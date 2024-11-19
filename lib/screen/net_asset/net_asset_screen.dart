import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/net_asset_list_model.dart';
import 'package:flutter_wallet/service/net_asset_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class NetAssetScreen extends StatefulWidget {
  const NetAssetScreen({super.key});

  @override
  State<NetAssetScreen> createState() => _NetAssetScreenState();
}

class _NetAssetScreenState extends State<NetAssetScreen> {
  // service
  final _netAssetService = NetAssetService();

  // state
  bool _isLoading = true;
  NetAssetListModel _netAssetList = NetAssetListModel(
    propertyList: [],
    debtList: [],
  );

  _getNetAssetList() async {
    final netAssetList = await _netAssetService.getNetAssetList();
    setState(() {
      _netAssetList = netAssetList;
      _isLoading = false;
    });
  }

  _updateNetAsset() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final res = await _netAssetService.updateNetAsset(
        data: _netAssetList,
      );
      if (res) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        throw Exception('ทำรายการไม่สำเร็จ');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ทำรายการไม่สำเร็จ',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getNetAssetList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการทรัพย์สุทธิ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _updateNetAsset();
            },
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ResponsiveWidth(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'เลือกทรัพย์สิน',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          final property = _netAssetList.propertyList![index];
                          return Column(
                            children: [
                              CheckboxListTile(
                                title: Text(property.accountName!),
                                value: property.status,
                                onChanged: (value) {
                                  setState(() {
                                    property.status = value!;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1.0);
                        },
                        itemCount: _netAssetList.propertyList!.length,
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'เลือกหนี้สิน',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          final debt = _netAssetList.debtList![index];
                          return Column(
                            children: [
                              CheckboxListTile(
                                title: Text(debt.accountName!),
                                value: debt.status,
                                onChanged: (value) {
                                  setState(() {
                                    debt.status = value!;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1.0);
                        },
                        itemCount: _netAssetList.debtList!.length,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
