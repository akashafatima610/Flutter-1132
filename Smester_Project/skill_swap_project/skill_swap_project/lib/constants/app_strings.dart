class AppStrings {
  static const String appName = 'Skill Swap';
  static const String tagline = 'Share Skills. Grow Together.';

  // Onboarding
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Share Your Skills',
      'subtitle': 'Offer what you know and teach others in your community.',
      'image': 'assets/images/onboard1.png',
    },
    {
      'title': 'Learn Something New',
      'subtitle': 'Find experts willing to trade knowledge with you.',
      'image': 'assets/images/onboard2.png',
    },
    {
      'title': 'Grow Together',
      'subtitle': 'Build meaningful connections through skill exchange.',
      'image': 'assets/images/onboard3.png',
    },
  ];

  // Skill chip suggestions
  static const List<String> skillSuggestions = [
    'Flutter',
    'Python',
    'UI/UX',
    'Guitar',
    'Photography',
    'Cooking',
    'English',
    'Urdu',
    'Drawing',
    'Video Editing',
    'Web Dev',
    'Excel',
    'Marketing',
    'Yoga',
  ];

  // Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String skillListing = '/skill-listing';
  static const String profile = '/profile';
  static const String request = '/request';
  static const String chat = '/chat';
  static const String requestsTab = '/requests';
  static const String settings = '/settings';
}