// Key for accessing theme value from shared preferences
const String themeKeyForSharedPreference = 'selected_theme';

// Icon Size
const double iconSize = 25;

// Route Name
const String login = 'login';
const String signup = 'signup';
const String mainScreen = 'main_screen';
const String appNotifications = 'notifications';
const String userProfileScreen = 'user_profile_screen';
const String chatListScreen = 'chat_list_screen';

// Route Path
const String loginPath = '/login';
const String signupPath = '/signup';
const String mainScreenPath = '/main_screen';
const String appNotificationsPath = 'notifications';
const String userProfileScreenPath = 'user_profile_screen/:user_id';
const String chatListScreenPath = 'chat_list_screen';

// User date property
class UserDataProperty {
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String userName = 'username';
}

// Months from word to number value
const Map<String, int> toNumericalMonthValue = {
  'January': 1,
  'February': 2,
  'March': 3,
  'April': 4,
  'May': 5,
  'June': 6,
  'July': 7,
  'August': 8,
  'September': 9,
  'October': 10,
  'November': 11,
  'December': 12,
};

// Enum for follow status
enum FollowStatus {
  inFollowersList,
  inFollowRequestList,
  notInAnyList,
}

// Enum for like status
enum LikeStatus { inLikeList, notInLikeList }
