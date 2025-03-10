import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/provider/notification/local_notification_provider.dart';
import 'package:restaurantapp/provider/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isScheduled = false;

  @override
  void initState() {
    super.initState();
    _loadScheduledStatus();
  }

  Future<void> _loadScheduledStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isScheduled = prefs.getBool('daily_reminder') ?? false;
    });
  }

  Future<void> _saveScheduledStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Restaurant App",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Mode Gelap"),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            SwitchListTile(
              title: const Text("Jadwalkan Notifikasi Harian"),
              value: _isScheduled,
              onChanged: (value) {
                setState(() {
                  _isScheduled = value;
                });
                _saveScheduledStatus(value);
                if (value) {
                  _scheduleDailyNotification();
                }
              },
            ),
            ListTile(
              title: const Text("Periksa Notifikasi yang Dijadwalkan"),
              trailing: const Icon(Icons.notifications_active),
              onTap: _checkPendingNotificationRequests,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleDailyNotification() async {
    if (!mounted) return;
    context.read<LocalNotificationProvider>().scheduleDailyNotification();
  }

  Future<void> _checkPendingNotificationRequests() async {
    if (!mounted) return;

    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);

    if (!mounted) return;

    _showPendingNotificationsDialog();
  }

  void _showPendingNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final pendingData = context
            .watch<LocalNotificationProvider>()
            .pendingNotificationRequests;

        return AlertDialog(
          title: Text(
            '${pendingData.length} pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: IconButton(
                    onPressed: () {
                      final provider =
                          context.read<LocalNotificationProvider>();
                      provider.cancelNotification(item.id);
                      provider.checkPendingNotificationRequests(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
