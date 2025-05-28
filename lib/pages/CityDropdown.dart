import 'package:flutter/material.dart';

class City {
  final String id;
  final String name;

  City({required this.id, required this.name});
}

class SearchableDropdownFormField extends StatefulWidget {
  final List<City> cities;
  final City? selectedCity;
  final ValueChanged<City?> onChanged;
  final String? labelText;
  final String? Function(City?)? validator;

  SearchableDropdownFormField({
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
    this.labelText,
    this.validator,
  });

  @override
  _SearchableDropdownFormFieldState createState() =>
      _SearchableDropdownFormFieldState();
}

class _SearchableDropdownFormFieldState
    extends State<SearchableDropdownFormField> {
  City? _selectedCity;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<City>(
      value: _selectedCity,
      onChanged: (City? value) {
        setState(() {
          _selectedCity = value;
          widget.onChanged(value);
        });
      },
      items: _filterCities().map((City city) {
        return DropdownMenuItem<City>(
          value: city,
          child: Text(city.name),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Select a City *',
      ),
      validator: widget.validator,
    );
  }

  List<City> _filterCities() {
    final String? query = _searchController.text.toLowerCase();
    return query!.isEmpty
        ? widget.cities
        : widget.cities
            .where((City city) => city.name.toLowerCase().contains(query))
            .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
