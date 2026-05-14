import 'package:flutter/material.dart';
import 'package:flightbooking/core/widgets/App_widget.dart';

enum SelectionType { airline, aircraft }

class SelectOptionScreen extends StatefulWidget {
  final List<String> options;
  final SelectionType type;
  final String? selectedValue;

  const SelectOptionScreen({
    super.key,
    required this.options,
    required this.type,
    this.selectedValue,
  });

  @override
  State<SelectOptionScreen> createState() => _SelectOptionScreenState();
}

class _SelectOptionScreenState extends State<SelectOptionScreen> {
  late String? selectedValue;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<String> get filteredOptions {
    if (searchController.text.isEmpty) {
      return widget.options;
    }
    return widget.options
        .where(
          (option) => option.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == SelectionType.airline
        ? "Select Airline"
        : "Select Aircraft";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText:
                    "Search ${widget.type == SelectionType.airline ? 'Airline' : 'Aircraft'}",
                border: const OutlineInputBorder(),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      )
                    : const Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            // Options list
            Expanded(
              child: filteredOptions.isEmpty
                  ? Center(
                      child: AppWidget.appText(
                        text:
                            "No ${widget.type == SelectionType.airline ? 'airlines' : 'aircraft'} found",
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredOptions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final option = filteredOptions[index];
                        final isSelected = selectedValue == option;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          title: AppWidget.appText(
                            text: option,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            Navigator.pop(context, option);
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
