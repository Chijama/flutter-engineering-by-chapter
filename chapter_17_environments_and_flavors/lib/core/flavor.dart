enum Flavor { dev, staging, prod, beta }

String flavorLabel(Flavor f) {
  switch (f) {
    case Flavor.dev:
      return 'Development';
    case Flavor.staging:
      return 'Staging';
    case Flavor.prod:
      return 'Production';
    case Flavor.beta:
      return 'Beta';
  }
}
