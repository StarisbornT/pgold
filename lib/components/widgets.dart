import 'package:flutter/material.dart';
import 'package:pgold/utils/appcolors.dart';

class SelectionOption {
  final String title;
  final String subtitle;
  final IconData? icon; // Optional icon
  final Color? iconColor; // Optional icon color
  final String? imageUrl;
  final dynamic value;

  SelectionOption({
    required this.title,
    this.subtitle = '',
    this.icon,
    this.iconColor,
    this.imageUrl,
    required this.value,
  });
}

class AppModalBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<SelectionOption> options;
  final ValueChanged<dynamic>? onOptionSelected;

  const AppModalBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    this.onOptionSelected,
  });

  @override
  State<AppModalBottomSheet> createState() => _AppModalBottomSheetState();
}

class _AppModalBottomSheetState extends State<AppModalBottomSheet> {
  late List<SelectionOption> _filteredOptions;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredOptions = widget.options.where((option) {
          return option.title.toLowerCase().contains(query) ||
              option.subtitle.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header =====
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 24),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== Search Bar =====
              SearchBox(
                controller: _searchController,
                hintText: "Search ${widget.title.toLowerCase()}",
                onChanged: (query) {
                  // handle filtering logic here
                },
              ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // ===== List =====
            Expanded(
              child: _filteredOptions.isEmpty
                  ? const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return ActionTile(
                    icon: option.icon ?? Icons.label_important_outline,
                    iconColor: option.iconColor ?? AppColors.PRIMARYCOLOR,
                    imageUrl: option.imageUrl,
                    title: option.title,
                    subtitle: option.subtitle,
                    onTap: () {
                      widget.onOptionSelected?.call(option.value);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconColor,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Show network image inside a circle
      leadingWidget = CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Colors.grey.shade200,
      );
    } else {
      // Fallback to icon
      leadingWidget = Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.blue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon ?? Icons.image_not_supported,
          color: iconColor ?? Colors.blue,
          size: 24,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xFF1A202C),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
class CustomDropdownSelect extends StatefulWidget {
  final String label; // The label above the input field
  final String hintText; // The hint text inside the input field
  final List<SelectionOption> options; // The list of options for the bottom sheet
  final String? initialValue; // The currently selected display value
  final String bottomSheetTitle;
  final String bottomSheetSubtitle;
  final ValueChanged<dynamic>? onOptionSelected; // Callback when an option is chosen

  const CustomDropdownSelect({
    super.key,
    required this.label,
    required this.hintText,
    required this.options,
    this.initialValue,
    required this.bottomSheetTitle,
    required this.bottomSheetSubtitle,
    this.onOptionSelected,
  });

  @override
  State<CustomDropdownSelect> createState() => _CustomDropdownSelectState();
}

class _CustomDropdownSelectState extends State<CustomDropdownSelect> {
  // We manage the displayed text here, but the actual value is passed via onOptionSelected
  String? _selectedDisplayText;

  @override
  void initState() {
    super.initState();
    _selectedDisplayText = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedDisplayText = widget.initialValue;
    }
  }

  void _showSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AppModalBottomSheet(
          title: widget.bottomSheetTitle,
          subtitle: widget.bottomSheetSubtitle,
          options: widget.options,
          onOptionSelected: (selectedValue) {
            // Find the display title for the selected value
            final selectedOption = widget.options.firstWhere(
                  (option) => option.value == selectedValue,
              orElse: () => SelectionOption(title: '', value: null), // Fallback
            );
            if (selectedOption.value != null) {
              setState(() {
                _selectedDisplayText = selectedOption.title;
              });
              widget.onOptionSelected?.call(selectedValue); // Notify parent with the actual value
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _showSelectionBottomSheet(context),
          child: Container(
            height: 56, // Standard height for input fields
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDisplayText ?? widget.hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedDisplayText == null
                        ? Colors.grey.shade600
                        : Colors.black, // Darker text if selected
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.45, 1.0],
          colors: [
            Color(0xFFF5F7FB),
            Color(0xFFFAFBFD),
            Color(0xFFFFFFFF),
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: Color(0xFF1A202C),
            ),
          ),
        ),
      ),
    );
  }
}
