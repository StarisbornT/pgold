import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pgold/utils/appcolors.dart';

import '../../components/widgets.dart';
import 'package:pgold/lib/provider/gitcard_provider.dart';
import 'package:pgold/lib/provider/crypo_provider.dart';
import '../../model/crytpo_model.dart';
import '../../model/giftcard_model.dart';

const Color _primaryBlue = AppColors.PRIMARYCOLOR;

class Rates extends ConsumerStatefulWidget {
  const Rates({super.key});

  @override
  ConsumerState<Rates> createState() => _RatesScreenState();
}

class _RatesScreenState extends ConsumerState<Rates> {
  // Tab state
  bool _isGiftcardTab = true;
  String? _selectedGiftcardAction;
  String? _selectedGiftcardId;
  List<SelectionOption> _giftcardCountryOptions = [];
  String? _selectedGiftcardCountryIso;
  String? _selectedGiftcardCategory;
  List<SelectionOption> _giftcardRangeOptions = [];
  List<SelectionOption> _giftcardCategoryOptions = [];
  String? _selectedGiftcardRange;
  String? _giftcardCardValue;

  // Separate state for Crypto tab
  String? _selectedCryptoId;
  String? _selectedCryptoAction;
  String? _cryptoValue;

  CryptoCurrency? _selectedCryptoCurrency;
  double? _calculatedRate;
  double? _calculatedTotalValue;

  GiftCard? _selectedGiftCard;
  GiftCardCountry? _selectedGiftCardCountry;
  GiftCardRange? _selectedGiftCardRange;
  double? _calculatedGiftcardTotalValue;
  double? _giftcardRatePercentage;

  final List<SelectionOption> _cryptoActionOptions = [
    SelectionOption(
      title: 'Buy Crypto',
      subtitle: 'Buy Crypto at the best market rate',
      icon: Icons.currency_bitcoin,
      iconColor: const Color(0xFF09311C),
      value: 'buy',
    ),
    SelectionOption(
      title: 'Sell Crypto',
      subtitle: 'Sell Crypto at the best market rate',
      icon: Icons.currency_bitcoin,
      iconColor: const Color(0xFF09311C),
      value: 'sell',
    ),
  ];

  final List<SelectionOption> _giftcardOptions = [
    SelectionOption(
      title: 'Sell Giftcards',
      subtitle: 'Sell Giftcards to cash Instantly',
      icon: Icons.card_giftcard,
      iconColor: const Color(0xFF8038E8),
      value: 'sell_gift_card',
    ),
    SelectionOption(
      title: 'Buy Giftcards',
      subtitle: 'Buy Giftcards with cash',
      icon: Icons.card_giftcard,
      iconColor: const Color(0xFF8038E8),
      value: 'buy_gift_card',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(giftcardProvider.notifier).getGiftCard();
      await ref.read(cryptoProvider.notifier).getCryptos();
    });
  }

  // Method to switch tabs and reset dependent fields
  void _switchTab(bool isGiftcard) {
    setState(() {
      _isGiftcardTab = isGiftcard;
      // Reset dependent fields when switching tabs
      if (isGiftcard) {
        // Reset crypto-specific fields when switching to giftcard
        _selectedCryptoId = null;
        _selectedCryptoAction = null;
        _cryptoValue = null;
      } else {
        // Reset giftcard-specific fields when switching to crypto
        _selectedGiftcardId = null;
        _selectedGiftcardAction = null;
        _selectedGiftcardCountryIso = null;
        _selectedGiftcardCategory = null;
        _selectedGiftcardRange = null;
        _giftcardCountryOptions = [];
        _giftcardRangeOptions = [];
        _giftcardCategoryOptions = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final giftcardState = ref.watch(giftcardProvider);
    final cryptoState = ref.watch(cryptoProvider);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF7F9FC),
      foregroundColor: Colors.grey.shade700,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    // The primary selected button style
    final selectedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rates',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF1A202C), size: 24,),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tab Switcher
            Container(
              width: 355,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE0E9FC),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: _isGiftcardTab ? selectedButtonStyle : buttonStyle,
                      onPressed: () => _switchTab(true),
                      icon: Icon(
                        Icons.card_giftcard,
                        size: 20,
                        color: _isGiftcardTab ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Giftcard',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isGiftcardTab ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: !_isGiftcardTab ? selectedButtonStyle : buttonStyle,
                      onPressed: () => _switchTab(false),
                      icon: Icon(
                        Icons.currency_bitcoin,
                        size: 20,
                        color: !_isGiftcardTab ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Crypto',
                        style: TextStyle(
                          fontSize: 16,
                          color: !_isGiftcardTab ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content based on selected tab
            _isGiftcardTab
                ? _buildGiftcardContent(giftcardState)
                : _buildCryptoContent(cryptoState),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftcardContent(AsyncValue<GiftCardResponse> giftcardState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        giftcardState.when(
          data: (giftcardResponse) {
            final giftcardOptions = giftcardResponse.data?.allGiftcards?.map((card) {
              return SelectionOption(
                title: card.title ?? '',
                subtitle: "Tap to select ${card.title}",
                imageUrl: card.brandLogo,
                value: card.id.toString(),
              );
            }).toList();

            return CustomDropdownSelect(
              label: "Giftcard",
              hintText: "Select Giftcard",
              options: giftcardOptions ?? [],
              bottomSheetTitle: "Giftcards",
              bottomSheetSubtitle: "",
              initialValue: _selectedGiftcardId != null && (giftcardOptions ?? []).isNotEmpty
                  ? giftcardOptions!.firstWhere(
                    (option) => option.value == _selectedGiftcardId,
                orElse: () => SelectionOption(title: '', value: '', subtitle: ''),
              ).title
                  : null,
              onOptionSelected: (value) {
                // Find the selected giftcard
                final selectedCard = giftcardResponse.data?.allGiftcards
                    ?.firstWhere((card) => card.id.toString() == value);

                setState(() {
                  _selectedGiftcardId = value;
                  _selectedGiftCard = selectedCard;

                  // Map its countries to SelectionOption
                  _giftcardCountryOptions = (selectedCard?.countries ?? []).map((country) {
                    return SelectionOption(
                      title: country.name ?? '',
                      imageUrl: country.image,
                      subtitle: "Tap to select ${country.name}",
                      value: country.iso,
                    );
                  }).toList();

                  // Reset dependent fields
                  _selectedGiftcardCountryIso = null;
                  _selectedGiftcardRange = null;
                  _selectedGiftcardCategory = null;
                  _selectedGiftCardCountry = null;
                  _selectedGiftCardRange = null;
                  _giftcardRangeOptions = [];
                  _giftcardCategoryOptions = [];

                  // Reset calculations
                  _resetGiftcardCalculations();
                });

                print("Selected giftcard: $value");
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) {
            return Center(
              child: Text('Failed to load giftcards: $err'),
            );
          },
        ),

        const SizedBox(height: 16),

        CustomDropdownSelect(
          label: 'Country',
          hintText: 'Select Giftcard Country',
          options: _giftcardCountryOptions,
          bottomSheetTitle: 'Select Card Country',
          bottomSheetSubtitle: '',
          initialValue: _selectedGiftcardCountryIso != null && _giftcardCountryOptions.isNotEmpty
              ? _giftcardCountryOptions.firstWhere(
                (option) => option.value == _selectedGiftcardCountryIso,
            orElse: () => SelectionOption(title: '', value: '', subtitle: ''),
          ).title
              : null,
          onOptionSelected: (selectedValue) {
            // Find the selected country
            final selectedCountry = _selectedGiftCard?.countries
                ?.firstWhere((country) => country.iso == selectedValue);

            setState(() {
              _selectedGiftcardCountryIso = selectedValue;
              _selectedGiftCardCountry = selectedCountry;

              // Map ranges
              _giftcardRangeOptions = (selectedCountry?.ranges ?? []).map((range) {
                return SelectionOption(
                  title: "${range.min} - ${range.max}",
                  subtitle: "Min: ${range.min}, Max: ${range.max}",
                  value: "${range.min}-${range.max}",
                );
              }).toList();

              // Reset dependent fields
              _selectedGiftcardRange = null;
              _selectedGiftcardCategory = null;
              _selectedGiftCardRange = null;
              _giftcardCategoryOptions = [];

              // Reset calculations
              _resetGiftcardCalculations();
            });

            print("Selected Country: $_selectedGiftcardCountryIso");
          },
        ),

        const SizedBox(height: 16),

        CustomDropdownSelect(
          label: 'Card Range',
          hintText: 'Select Card Range',
          options: _giftcardRangeOptions,
          bottomSheetTitle: 'Select Range',
          bottomSheetSubtitle: '',
          initialValue: _selectedGiftcardRange != null && _giftcardRangeOptions.isNotEmpty
              ? _giftcardRangeOptions.firstWhere(
                (option) => option.value == _selectedGiftcardRange,
            orElse: () => SelectionOption(title: '', value: '', subtitle: ''),
          ).title
              : null,
          onOptionSelected: (selectedValue) {
            // Find the selected range
            final selectedRange = _selectedGiftCardCountry?.ranges
                ?.firstWhere((range) => "${range.min}-${range.max}" == selectedValue);

            setState(() {
              _selectedGiftcardRange = selectedValue;
              _selectedGiftCardRange = selectedRange;

              // Build category options from selected range
              _giftcardCategoryOptions = (selectedRange?.receiptCategories ?? []).map((category) {
                return SelectionOption(
                  title: category.name ?? '',
                  subtitle: "Tap to select ${category.name}",
                  value: category.id.toString(),
                );
              }).toList();

              // Reset dependent field
              _selectedGiftcardCategory = null;

              // Reset calculations
              _resetGiftcardCalculations();
            });

            print("Selected Range: $_selectedGiftcardRange");
          },
        ),

        const SizedBox(height: 16),

        CustomDropdownSelect(
          label: 'Receipt Category',
          hintText: 'Select Receipt Category',
          options: _giftcardCategoryOptions,
          bottomSheetTitle: 'Select Category',
          bottomSheetSubtitle: '',
          initialValue: _selectedGiftcardCategory != null && _giftcardCategoryOptions.isNotEmpty
              ? _giftcardCategoryOptions.firstWhere(
                (option) => option.value == _selectedGiftcardCategory,
          ).title
              : null,
          onOptionSelected: (selectedValue) {
            // Find the selected category
            _selectedGiftCardRange?.receiptCategories
                ?.firstWhere((category) => category.id.toString() == selectedValue);

            setState(() {
              _selectedGiftcardCategory = selectedValue;
              // Recalculate rates when category changes
              _calculateGiftcardRates();
            });
            print("Selected Category: $_selectedGiftcardCategory");
          },
        ),

        const SizedBox(height: 16),

        CustomDropdownSelect(
          label: 'Giftcard Action',
          hintText: 'Select Giftcard Action',
          options: _giftcardOptions,
          bottomSheetTitle: 'Select an Action',
          bottomSheetSubtitle: 'Choose your most preferred action',
          initialValue: _selectedGiftcardAction != null
              ? _giftcardOptions.firstWhere((option) => option.value == _selectedGiftcardAction).title
              : null,
          onOptionSelected: (selectedValue) {
            setState(() {
              _selectedGiftcardAction = selectedValue;
              // Recalculate rates when action changes
              _calculateGiftcardRates();
            });
            print('Selected Giftcard Action: $_selectedGiftcardAction');
          },
        ),

        const SizedBox(height: 16),

        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Card Value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter Card Value',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: _primaryBlue, width: 2.0),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _giftcardCardValue = value;
              // Recalculate rates when value changes
              _calculateGiftcardRates();
            });
          },
        ),

        _buildGiftcardRateDisplay(),
      ],
    );
  }
  void _resetGiftcardCalculations() {
    setState(() {
      _calculatedGiftcardTotalValue = null;
      _giftcardRatePercentage = null;
    });
  }

  void _calculateGiftcardRates() {
    // Reset calculations
    _resetGiftcardCalculations();

    // Check if we have all required data
    if (_selectedGiftcardAction == null ||
        _giftcardCardValue == null ||
        _giftcardCardValue!.isEmpty) {
      return;
    }

    try {
      final cardValue = double.tryParse(_giftcardCardValue!);
      if (cardValue == null || cardValue <= 0) return;

      double ratePercentage = 0;
      double rate = 0;
      double totalValue = 0;

      if (_selectedGiftcardAction == 'sell_gift_card') {
        if (cardValue <= 25) {
          ratePercentage = 85.0;
        } else if (cardValue <= 100) {
          ratePercentage = 80.0;
        } else {
          ratePercentage = 75.0;
        }
      } else if (_selectedGiftcardAction == 'buy_gift_card') {
        if (cardValue <= 25) {
          ratePercentage = 90.0;
        } else if (cardValue <= 100) {
          ratePercentage = 92.0;
        } else {
          ratePercentage = 95.0;
        }
      }

      // Calculate actual values
      rate = ratePercentage / 100.0; // Convert percentage to decimal
      totalValue = cardValue * rate;

      setState(() {
        _giftcardRatePercentage = ratePercentage;
        _calculatedGiftcardTotalValue = totalValue;
      });

    } catch (e) {
      print('Error calculating giftcard rates: $e');
    }
  }
  Widget _buildGiftcardRateDisplay() {
    final ratePercentageText = _giftcardRatePercentage != null
        ? '${_giftcardRatePercentage!.toStringAsFixed(1)}%'
        : '0%';

    final totalValueText = _calculatedGiftcardTotalValue != null && _calculatedGiftcardTotalValue! > 0
        ? '${_calculatedGiftcardTotalValue!.toStringAsFixed(2)} ${_selectedGiftCardCountry?.currency?.code ?? 'USD'}'
        : '0 ${_selectedGiftCardCountry?.currency?.code ?? 'USD'}';


    return Column(
      children: [

        const SizedBox(height: 16),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Rate Percentage
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ratePercentageText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Total Payout/Value
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Value',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      totalValueText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoContent(AsyncValue<CryptoResponse> cryptoState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        cryptoState.when(
          data: (cryptoResponse) {
            final cryptoOptions = cryptoResponse.data?.data?.map((crypto) {
              return SelectionOption(
                title: crypto.name ?? '',
                subtitle: "Tap to select ${crypto.name}",
                imageUrl: crypto.icon,
                value: crypto.id.toString(),
              );
            }).toList();

            return CustomDropdownSelect(
              label: "Crypto",
              hintText: "Select Crypto",
              options: cryptoOptions ?? [],
              bottomSheetTitle: "Choose your preferred cryptocurrency",
              bottomSheetSubtitle: "",
              initialValue: _selectedCryptoId != null && (cryptoOptions ?? []).isNotEmpty
                  ? cryptoOptions!.firstWhere(
                    (option) => option.value == _selectedCryptoId,
                orElse: () => SelectionOption(title: '', value: '', subtitle: ''),
              ).title
                  : null,
              onOptionSelected: (value) {
                final selectedCrypto = cryptoResponse.data?.data?.firstWhere(
                      (crypto) => crypto.id.toString() == value,
                );

                setState(() {
                  _selectedCryptoId = value;
                  _selectedCryptoCurrency = selectedCrypto;
                  _calculateCryptoRates();
                });
                print("Selected crypto: $value");
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) {
            return Center(
              child: Text('Failed to load cryptocurrencies: $err'),
            );
          },
        ),

        const SizedBox(height: 16),

        CustomDropdownSelect(
          label: 'Crypto Action',
          hintText: 'Select Crypto Action',
          options: _cryptoActionOptions,
          bottomSheetTitle: 'Select Crypto Action',
          bottomSheetSubtitle: 'Choose whether to buy or sell',
          initialValue: _selectedCryptoAction != null
              ? _cryptoActionOptions.firstWhere((option) => option.value == _selectedCryptoAction).title
              : null,
          onOptionSelected: (selectedValue) {
            setState(() {
              _selectedCryptoAction = selectedValue;
              _calculateCryptoRates();
            });
            print('Selected Crypto Action: $_selectedCryptoAction');
          },
        ),

        const SizedBox(height: 16),

        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Crypto Value (\$USD)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter Crypto Value in USD',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: _primaryBlue, width: 2.0),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _cryptoValue = value;
              _calculateCryptoRates();
            });
          },
        ),

        _buildCryptoRateDisplay(),
      ],
    );
  }
  void _calculateCryptoRates() {
    // Reset calculations
    _calculatedRate = null;
    _calculatedTotalValue = null;

    // Check if we have all required data
    if (_selectedCryptoCurrency == null ||
        _selectedCryptoAction == null ||
        _cryptoValue == null ||
        _cryptoValue!.isEmpty) {
      return;
    }

    try {
      final cryptoValue = double.tryParse(_cryptoValue!);
      if (cryptoValue == null || cryptoValue <= 0) return;

      double rate = 0;
      double totalValue = 0;

      if (_selectedCryptoAction == 'buy') {
        // For buying: use buy_rate
        final buyRate = double.tryParse(_selectedCryptoCurrency!.buyRate ?? '0');
        if (buyRate != null && buyRate > 0) {
          rate = buyRate;
          totalValue = cryptoValue * buyRate;
        }
      } else if (_selectedCryptoAction == 'sell') {
        // For selling: use sell_rate
        final sellRate = double.tryParse(_selectedCryptoCurrency!.sellRate ?? '0');
        if (sellRate != null && sellRate > 0) {
          rate = sellRate;
          totalValue = cryptoValue * sellRate;
        }
      }

      setState(() {
        _calculatedRate = rate;
        _calculatedTotalValue = totalValue;
      });

    } catch (e) {
      print('Error calculating crypto rates: $e');
    }
  }

  Widget _buildCryptoRateDisplay() {
    // Format numbers for display
    final rateText = _calculatedRate != null && _calculatedRate! > 0
        ? '${_calculatedRate!.toStringAsFixed(2)} USD'
        : '0 USD';

    final totalValueText = _calculatedTotalValue != null && _calculatedTotalValue! > 0
        ? '${_calculatedTotalValue!.toStringAsFixed(2)} USD'
        : '0 USD';


    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Rate per USD
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      rateText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Total Value
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Value',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      totalValueText,
                      style:  TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}