import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import '../utils/appcolors.dart';

class LabeledTextField extends ConsumerStatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final StateProvider<String?> provider;
  final bool isPassword;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.provider,
    this.isPassword = false,
  });

  @override
  ConsumerState<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends ConsumerState<LabeledTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // rebuild when focus changes
    });
    widget.controller.addListener(() {
      setState(() {}); // rebuild when text changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _focusNode.hasFocus || widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.isPassword ? _obscureText : false,
          onChanged: (value) {
            ref.read(widget.provider.notifier).state =
            value.isNotEmpty ? value : null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: isActive ? AppColors.PRIMARYCOLOR : Colors.grey.shade600,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.PRIMARYCOLOR,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class PhoneNumberField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? errorText;
  final StateProvider<String?> provider;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
    required this.provider,
  });

  @override
  ConsumerState<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends ConsumerState<PhoneNumberField> {
  List<Map<String, dynamic>> countries = [];
  String selectedDialCode = '+234';
  String selectedFlagUrl = 'https://flagcdn.com/w40/ng.png';

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<void> fetchCountries() async {
    const url = 'https://restcountries.com/v3.1/all?fields=name,idd,cca2,flags';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {'User-Agent': 'YourAppName/1.0'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = response.data;

        setState(() {
          countries = data.where((c) => c['idd'] != null).map((country) {
            final idd = country['idd'] as Map<String, dynamic>;
            final root = idd['root']?.toString() ?? '';

            // FIX: Handle empty suffixes list
            final suffixesList = idd['suffixes'] as List<dynamic>?;
            String suffix = '';
            if (suffixesList != null && suffixesList.isNotEmpty) {
              suffix = suffixesList[0]?.toString() ?? '';
            }

            final dialCode = '$root$suffix';

            // FIX: Use reliable flag source with fallback
            final cca2 = (country['cca2'] ?? '').toString().toLowerCase();
            final flagUrl = (country['flags']?['png'] != null)
                ? country['flags']['png']
                : 'https://flagcdn.com/w40/$cca2.png';

            return {
              'name': country['name']['common'] ?? 'Unknown',
              'flag': flagUrl,
              'dial_code': dialCode,
            };
          }).where((item) => item['dial_code']!.isNotEmpty).toList();
        });

        print('Fetched ${countries.length} countries');
      } else {
        print('FAILED: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('DIO ERROR: ${e.type} - ${e.message}');
    } catch (e, stack) {
      print('GENERAL ERROR: $e\n$stack');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Phone Number',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          border:  Border.all(color: widget.errorText != null ? const Color.fromRGBO(219, 33, 33, 0.76) : Colors.transparent),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _showCountryPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        selectedFlagUrl,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),


                    const SizedBox(width: 6),
                    Text(selectedDialCode,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (value) {
                  ref.read(widget.provider.notifier).state =
                  value.isNotEmpty ? value : null;
                },
              ),
            ),
          ],
        ),
      ),
      widget.errorText != null ?
      Text(
        widget.errorText ?? '',
        style: const TextStyle(
            color: Color.fromRGBO(219, 33, 33, 0.76),
            fontSize: 12
        ),
      ): Text(''),
      // const SizedBox(height: 16),
    ]);
  }

  void _showCountryPicker(BuildContext context) {
    if (countries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No countries available. Retrying...'))
      );
      fetchCountries(); // Retry
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: countries.length,
        itemBuilder: (_, i) => ListTile(
          leading: Image.network(countries[i]['flag']!, width: 24, errorBuilder:
              (_, __, ___) => Icon(Icons.flag)),
          title: Text(countries[i]['name']!),
          subtitle: Text(countries[i]['dial_code']!),
          onTap: () => _selectCountry(countries[i]),
        ),
      ),
    );
  }
  void _selectCountry(Map<String, dynamic> country) {
    setState(() {
      selectedDialCode = country['dial_code']!;
      selectedFlagUrl = country['flag']!;
    });
    Navigator.pop(context);
  }
}