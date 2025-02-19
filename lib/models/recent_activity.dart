class Activity {
  // description, date
  final String description;
  final DateTime date;

  Activity({required this.description, required this.date});
}

class RecentActivity {
  List<Activity> activities = [];

  static final RecentActivity instance = RecentActivity._internal();

  factory RecentActivity() => instance;

  RecentActivity._internal() {
    init();
  }

  void init() {
    activities.add(
      Activity(description: 'New Flutter Quiz Added', date: DateTime.now()),
    );
    activities.add(
      Activity(description: 'Java Category Updated', date: DateTime.now()),
    );
  }

  // add activity
  void addActivity(Activity activity) {
    activities.removeLast();
    // add at first
    activities.insert(0, activity);
  }

  // get all activities
  List<Activity> getAllActivities() {
    return activities;
  }

  void removeActivity() {
    // remove first activity
    activities.removeAt(0);
  }
}
