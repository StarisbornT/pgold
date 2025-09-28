class GiftCardResponse {
  final String? status;
  final GiftCardData? data;

  GiftCardResponse({this.status, this.data});

  factory GiftCardResponse.fromMap(Map<String, dynamic> map) {
    return GiftCardResponse(
      status: map['status'] as String?,
      data: map['data'] != null ? GiftCardData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data?.toMap(),
    };
  }
}

class GiftCardData {
  final List<GiftCard>? allGiftcards;

  GiftCardData({this.allGiftcards});

  factory GiftCardData.fromMap(Map<String, dynamic> map) {
    return GiftCardData(
      allGiftcards: map['all_giftcards'] != null
          ? List<GiftCard>.from(
          (map['all_giftcards'] as List).map((x) => GiftCard.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'all_giftcards': allGiftcards?.map((x) => x.toMap()).toList(),
    };
  }
}

class GiftCard {
  final int? id;
  final String? title;
  final String? image;
  final String? brandLogo;
  final String? status;
  final String? createdAt;
  final int? confirmMin;
  final int? confirmMax;
  final List<GiftCardCountry>? countries;

  GiftCard({
    this.id,
    this.title,
    this.image,
    this.brandLogo,
    this.status,
    this.createdAt,
    this.confirmMin,
    this.confirmMax,
    this.countries,
  });

  factory GiftCard.fromMap(Map<String, dynamic> map) {
    return GiftCard(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      brandLogo: map['brand_logo'],
      status: map['status'],
      createdAt: map['created_at'],
      confirmMin: map['confirm_min'],
      confirmMax: map['confirm_max'],
      countries: map['countries'] != null
          ? List<GiftCardCountry>.from(
          (map['countries'] as List).map((x) => GiftCardCountry.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'brand_logo': brandLogo,
      'status': status,
      'created_at': createdAt,
      'confirm_min': confirmMin,
      'confirm_max': confirmMax,
      'countries': countries?.map((x) => x.toMap()).toList(),
    };
  }
}

class GiftCardCountry {
  final int? id;
  final String? status;
  final String? name;
  final String? image;
  final String? iso;
  final Currency? currency;
  final List<GiftCardRange>? ranges;

  GiftCardCountry({
    this.id,
    this.status,
    this.name,
    this.image,
    this.iso,
    this.currency,
    this.ranges,
  });

  factory GiftCardCountry.fromMap(Map<String, dynamic> map) {
    return GiftCardCountry(
      id: map['id'],
      status: map['status'],
      name: map['name'],
      image: map['image'],
      iso: map['iso'],
      currency:
      map['currency'] != null ? Currency.fromMap(map['currency']) : null,
      ranges: map['ranges'] != null
          ? List<GiftCardRange>.from(
          (map['ranges'] as List).map((x) => GiftCardRange.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'name': name,
      'image': image,
      'iso': iso,
      'currency': currency?.toMap(),
      'ranges': ranges?.map((x) => x.toMap()).toList(),
    };
  }
}

class Currency {
  final int? id;
  final String? name;
  final String? symbol;
  final String? symbolNative;
  final int? decimalDigits;
  final int? rounding;
  final String? code;
  final String? namePlural;
  final String? createdAt;
  final String? updatedAt;

  Currency({
    this.id,
    this.name,
    this.symbol,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
    this.code,
    this.namePlural,
    this.createdAt,
    this.updatedAt,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      symbolNative: map['symbolNative'],
      decimalDigits: map['decimalDigits'],
      rounding: map['rounding'],
      code: map['code'],
      namePlural: map['namePlural'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'symbolNative': symbolNative,
      'decimalDigits': decimalDigits,
      'rounding': rounding,
      'code': code,
      'namePlural': namePlural,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class GiftCardRange {
  final int? id;
  final String? giftCardId;
  final String? giftCardCountryId;
  final String? status;
  final String? min;
  final String? max;
  final String? updatedBy;
  final List<ReceiptCategory>? receiptCategories;

  GiftCardRange({
    this.id,
    this.giftCardId,
    this.giftCardCountryId,
    this.status,
    this.min,
    this.max,
    this.updatedBy,
    this.receiptCategories,
  });

  factory GiftCardRange.fromMap(Map<String, dynamic> map) {
    return GiftCardRange(
      id: map['id'],
      giftCardId: map['gift_card_id'],
      giftCardCountryId: map['gift_card_country_id'],
      status: map['status'],
      min: map['min'],
      max: map['max'],
      updatedBy: map['updated_by'],
      receiptCategories: map['receipt_categories'] != null
          ? List<ReceiptCategory>.from((map['receipt_categories'] as List)
          .map((x) => ReceiptCategory.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gift_card_id': giftCardId,
      'gift_card_country_id': giftCardCountryId,
      'status': status,
      'min': min,
      'max': max,
      'updated_by': updatedBy,
      'receipt_categories': receiptCategories?.map((x) => x.toMap()).toList(),
    };
  }
}

class ReceiptCategory {
  final int? id;
  final String? name;

  ReceiptCategory({this.id, this.name});

  factory ReceiptCategory.fromMap(Map<String, dynamic> map) {
    return ReceiptCategory(
      id: map['id'],
      name: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
    };
  }
}
