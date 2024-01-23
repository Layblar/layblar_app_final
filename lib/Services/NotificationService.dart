import 'package:ass/WIdgets/StopwatchItem.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {

  static void updateNotification(List<StopWatchItem> stopwatchItems) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  
    if (isAllowed) {
      int runningStopwatches =
          stopwatchItems.where((sw) => !sw.isPaused).length;
      
      if(runningStopwatches > 0){
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            channelKey: 'stopwatch',
            title: 'Running Stopwatches',
            body: '$runningStopwatches stopwatch(s) are currently running.',
            payload: {"name": "LayblarApp"},
          ),
        );
      }
    }
  }
}
