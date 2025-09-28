class CryptoResponse {
  final String? status;
  final CryptoData? data;

  CryptoResponse({this.status, this.data});

  factory CryptoResponse.fromMap(Map<String, dynamic> map) {
    return CryptoResponse(
      status: map['status'] as String?,
      data: map['data'] != null ? CryptoData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data?.toMap(),
    };
  }
}

class CryptoData {
  final List<CryptoCurrency>? data;

  CryptoData({this.data});

  factory CryptoData.fromMap(Map<String, dynamic> map) {
    return CryptoData(
      data: map['data'] != null
          ? List<CryptoCurrency>.from(
          (map['data'] as List).map((x) => CryptoCurrency.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }
}

class CryptoCurrency {
  final int? id;
  final String? name;
  final String? code;
  final String? icon;
  final List<CryptoNetwork>? networks;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? isStable;
  final String? color;
  final String? minimumDeposit;
  final int? maximumDecimalPlaces;
  final bool? showBuy;
  final String? buyRate;
  final String? sellRate;
  final String? usdRate;

  CryptoCurrency({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.networks,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isStable,
    this.color,
    this.minimumDeposit,
    this.maximumDecimalPlaces,
    this.showBuy,
    this.buyRate,
    this.sellRate,
    this.usdRate,
  });

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      icon: map['icon'],
      networks: map['networks'] != null
          ? List<CryptoNetwork>.from(
          (map['networks'] as List).map((x) => CryptoNetwork.fromMap(x)))
          : [],
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      isStable: map['is_stable'],
      color: map['color'],
      minimumDeposit: map['minimumDeposit'],
      maximumDecimalPlaces: map['maximumDecimalPlaces'],
      showBuy: map['show_buy'],
      buyRate: map['buy_rate'],
      sellRate: map['sell_rate'],
      usdRate: map['usd_rate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
      'networks': networks?.map((x) => x.toMap()).toList(),
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_stable': isStable,
      'color': color,
      'minimumDeposit': minimumDeposit,
      'maximumDecimalPlaces': maximumDecimalPlaces,
      'show_buy': showBuy,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'usd_rate': usdRate,
    };
  }
}

class CryptoNetwork {
  final int? id;
  final String? addressRegex;
  final String? memoRegex;
  final String? name;
  final String? code;
  final String? fee;
  final String? feeType;
  final String? minimum;
  final String? contractAddress;
  final String? explorerLink;
  final String? createdAt;
  final String? updatedAt;

  CryptoNetwork({
    this.id,
    this.addressRegex,
    this.memoRegex,
    this.name,
    this.code,
    this.fee,
    this.feeType,
    this.minimum,
    this.contractAddress,
    this.explorerLink,
    this.createdAt,
    this.updatedAt,
  });

  factory CryptoNetwork.fromMap(Map<String, dynamic> map) {
    return CryptoNetwork(
      id: map['id'],
      addressRegex: map['addressRegex'],
      memoRegex: map['memoRegex'],
      name: map['name'],
      code: map['code'],
      fee: map['fee'],
      feeType: map['feeType'],
      minimum: map['minimum'],
      contractAddress: map['contractAddress'],
      explorerLink: map['explorerLink'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addressRegex': addressRegex,
      'memoRegex': memoRegex,
      'name': name,
      'code': code,
      'fee': fee,
      'feeType': feeType,
      'minimum': minimum,
      'contractAddress': contractAddress,
      'explorerLink': explorerLink,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}