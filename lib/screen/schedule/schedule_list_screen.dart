import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/schedule_list_model.dart';
import 'package:flutter_wallet/screen/schedule/schedule_form.dart';
import 'package:flutter_wallet/service/schedule_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  // service
  final ScheduleService _scheduleService = ScheduleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการประจำ'),
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ScheduleForm(mode: ScheduleFormMode.add),
                ),
              );
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveWidth(
          child: FutureBuilder<List<ScheduleListModel>>(
            future: _scheduleService.getScheduleList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(snapshot.error.toString()),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('ไม่พบข้อมูล'),
                  ),
                );
              }

              final scheduleList = snapshot.data!;
              return ListView.separated(
                itemBuilder: (context, index) {
                  final schedule = scheduleList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.name,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  schedule.scheduleTransactionDate,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: schedule.status == 'padding'
                                    ? Colors.red[600]
                                    : Colors.grey.shade800,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    schedule.status == 'padding'
                                        ? 'จ่าย'
                                        : 'เสร็จสิ้น',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    schedule.amount.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 1.0);
                },
                itemCount: scheduleList.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
