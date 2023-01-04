
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