import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class not extends StatefulWidget {
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<not> {
  @override
  var scheduleTime;
  void initState() {
    super.initState();
    var sig = Supabase.instance.client.channel('custom-update-channel').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          event: 'update',
          schema: 'public',
          table: 'signalement',
        ), (payload, [ref]) async {
      print('update');

      Map<String, dynamic> newRow = payload['new'];

      // Access the values of the new row using the keys in the newRow map
      if (newRow['etat'] as String == 'traitée') {
        var now = DateTime.now();
        debugPrint('Notification  $now');

        var scheduleTime = now.add(const Duration(seconds: 5));

        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);

        print(newRow['etat']);
      }
      print(payload);

      // Do something fun or interesting when there is an change on the database
    }).subscribe();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.deepPurple[900], title: Text("not")),
      body: Center(
        child: TextButton(
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              onChanged: (date) => scheduleTime = date,
              onConfirm: (date) {},
            );
          },
          child: const Text(
            'Select Date Time',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  void sendNotification() async {
    await OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: ['9876543210'], // Specify the recipient player ID
      content: 'anomalie traitée !', // Notification message
    ));
  }
}
