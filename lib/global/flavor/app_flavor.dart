
enum Flavor {
  development,
  release,
}

class AppFlavor {
  static Flavor appFlavor = Flavor.development;
  static String openAIApiKey = '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';

  static String get baseApi {
    switch (appFlavor) {
      case Flavor.release:
        return 'https://api.openai.com/v1';
      case Flavor.development:
        return 'https://api.openai.com/v1';
      default:
        return 'https://api.openai.com/v1';
    }
  }
}