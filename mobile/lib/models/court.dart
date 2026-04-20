class Court {
  final int id;
  final String name;
  final String surface;
  final bool isIndoor;
  final bool isAvailable;
  final String? description;
  final String? imageUrl;
  final List<Price> prices;
  final List<Schedule> schedules;

  Court({
    required this.id,
    required this.name,
    required this.surface,
    required this.isIndoor,
    required this.isAvailable,
    this.description,
    this.imageUrl,
    this.prices = const [],
    this.schedules = const [],
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      surface: json['surface'],
      isIndoor: json['is_indoor'] ?? false,
      isAvailable: json['is_available'] ?? true,
      description: json['description'],
      imageUrl: json['image_url'],
      prices: (json['prices'] as List<dynamic>?)
              ?.map((p) => Price.fromJson(p))
              .toList() ??
          [],
      schedules: (json['schedules'] as List<dynamic>?)
              ?.map((s) => Schedule.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class Price {
  final int id;
  final int courtId;
  final String priceType;
  final double price;
  final bool isActive;

  Price({
    required this.id,
    required this.courtId,
    required this.priceType,
    required this.price,
    required this.isActive,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'],
      courtId: json['court_id'],
      priceType: json['price_type'],
      price: double.parse(json['price'].toString()),
      isActive: json['is_active'] ?? true,
    );
  }
}

class Schedule {
  final int id;
  final int courtId;
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isActive;

  Schedule({
    required this.id,
    required this.courtId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.isActive,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      courtId: json['court_id'],
      dayOfWeek: json['day_of_week'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      isActive: json['is_active'] ?? true,
    );
  }
}
