/// A city the user can pick prayer times for. v1 ships a small hardcoded
/// list (see [AppConstants.availableCities]) — no geolocation or free-text
/// city search yet (see docs/architecture.md for why).
class SelectedCity {
  const SelectedCity({
    required this.id,
    required this.name,
    required this.country,
  });

  final String id;
  final String name;
  final String country;

  String get displayLabel => '$name, $country';
}

class AppConstants {
  AppConstants._();

  static const defaultCity = SelectedCity(id: 'mecca_sa', name: 'Mecca', country: 'Saudi Arabia');

  static const availableCities = [
    defaultCity,
    SelectedCity(id: 'medina_sa', name: 'Medina', country: 'Saudi Arabia'),
    SelectedCity(id: 'dubai_ae', name: 'Dubai', country: 'United Arab Emirates'),
    SelectedCity(id: 'istanbul_tr', name: 'Istanbul', country: 'Turkey'),
    SelectedCity(id: 'london_gb', name: 'London', country: 'United Kingdom'),
    SelectedCity(id: 'jakarta_id', name: 'Jakarta', country: 'Indonesia'),
    SelectedCity(id: 'newyork_us', name: 'New York', country: 'United States'),
  ];
}
