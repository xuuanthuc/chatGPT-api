
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