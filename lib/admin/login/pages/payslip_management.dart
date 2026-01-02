import 'package:flutter/material.dart';

class PayslipManagementPage extends StatefulWidget {
  const PayslipManagementPage({super.key});

  @override
  State<PayslipManagementPage> createState() => _PayslipManagementPageState();
}

class _PayslipManagementPageState extends State<PayslipManagementPage> {
  // 1. Master list of all payroll data
  final List<Map<String, String>> _allPayrollData = [
    {"name": "Hani Syakirah", "id": "EMP001", "dept": "IT", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PENDING"},
    {"name": "Alice Wong", "id": "EMP002", "dept": "IT", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
    {"name": "Husna Aqilah", "id": "EMP003", "dept": "Marketing", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
    {"name": "Amir Amzah", "id": "EMP004", "dept": "Marketing", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
    {"name": "Alam Ikmal", "id": "EMP005", "dept": "HR", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
    {"name": "Amir Amzah", "id": "EMP006", "dept": "Sales", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
    {"name": "Alam Ikmal", "id": "EMP007", "dept": "Sales", "month": "November", "basic": "RM 5,000", "net": "RM 5,000", "status": "PAID"},
  ];

  // 2. List that will be displayed (filtered results)
  List<Map<String, String>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list is the same as the full list
    _filteredData = _allPayrollData;
  }

  // 3. Search logic
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPayrollData;
    } else {
      results = _allPayrollData
          .where((user) =>
              user["name"]!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["id"]!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payslip Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Welcome back, Admin", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          const SizedBox(height: 24),

          // SEARCH BAR SECTION
          _buildSearchInput("Search by name or employee ID"),
          const SizedBox(height: 24),

          // PAYROLL TABLE
          _buildTableHeader(["Employee", "Department", "Month", "Basic Salary", "Net Salary", "Status", "Action"]),
          Expanded(
            child: _filteredData.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return _buildPayrollRow(
                        item["name"]!,
                        item["id"]!,
                        item["dept"]!,
                        item["month"]!,
                        item["basic"]!,
                        item["net"]!,
                        item["status"]!,
                      );
                    },
                  )
                : const Center(child: Text("No results found", style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
    );
  }

  // UPDATED SEARCH BAR BUILDER
  Widget _buildSearchInput(String hint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value), // Trigger the filter
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13),
          border: InputBorder.none,
          icon: const Icon(Icons.search, size: 20, color: Colors.grey),
        ),
      ),
    );
  }

  // TABLE HEADER BUILDER (Same as yours)
  Widget _buildTableHeader(List<String> labels) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Color(0xFFA7BBC7)),
      child: Row(
        children: labels
            .map((l) => Expanded(
                  child: Text(l, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ))
            .toList(),
      ),
    );
  }

  // DATA ROW BUILDER (Same as yours)
  Widget _buildPayrollRow(String name, String id, String dept, String month, String basic, String net, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(id, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(child: Text(dept, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(month, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(basic, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(net, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(status, style: const TextStyle(fontWeight: FontWeight.bold))),
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.edit_note, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}