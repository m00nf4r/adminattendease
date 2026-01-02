import 'package:flutter/material.dart';

// 1. DATA MODEL
class AttendanceRecord {
  final String date;
  final String inTime;
  final String outTime;
  final String hours;
  final String tardy;
  final String remark;
  final String empId;
  final String month;

  AttendanceRecord({
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.hours,
    required this.tardy,
    required this.remark,
    required this.empId,
    required this.month,
  });
}

class ReportSearchPage extends StatefulWidget {
  const ReportSearchPage({super.key});

  @override
  State<ReportSearchPage> createState() => _ReportSearchPageState();
}

class _ReportSearchPageState extends State<ReportSearchPage> {
  // 2. STATE VARIABLES
  String _selectedEmpId = "EMP001";
  String _selectedMonth = "November";
  String _searchQuery = "";

  // 3. MASTER DATA LIST
  final List<AttendanceRecord> _allRecords = [
    AttendanceRecord(date: "1.11.2025", inTime: "0900", outTime: "1700", hours: "8 hours", tardy: "0 minute", remark: "On Time", empId: "EMP001", month: "November"),
    AttendanceRecord(date: "2.11.2025", inTime: "0915", outTime: "1710", hours: "7h 55m", tardy: "15 minutes", remark: "Late", empId: "EMP001", month: "November"),
    AttendanceRecord(date: "1.12.2025", inTime: "0855", outTime: "1700", hours: "8 hours", tardy: "0 minute", remark: "On Time", empId: "EMP002", month: "December"),
    AttendanceRecord(date: "3.11.2025", inTime: "0900", outTime: "1700", hours: "8 hours", tardy: "0 minute", remark: "On Time", empId: "EMP001", month: "November"),
  ];

  // 4. FILTER LOGIC
  List<AttendanceRecord> get _filteredRecords {
    return _allRecords.where((record) {
      final matchesId = record.empId == _selectedEmpId;
      final matchesMonth = record.month == _selectedMonth;
      final matchesSearch = record.date.contains(_searchQuery) || 
                           record.remark.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesId && matchesMonth && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BREADCRUMB HEADER
            _buildHeader(context),
            const SizedBox(height: 24),

            // TOP FILTER CARD
            _buildFilterCard(),
            const SizedBox(height: 32),

            // RESULTS TABLE CARD
            _buildResultsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        const Text("Report / Attendance Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        const Spacer(),
        const Icon(Icons.logout),
      ],
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Attendance Report", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          Row(
            children: [
              _buildDropdownField("Employee's ID", _selectedEmpId, ["EMP001", "EMP002", "EMP003"], (val) {
                setState(() => _selectedEmpId = val!);
              }),
              const SizedBox(width: 32),
              _buildDropdownField("Month", _selectedMonth, ["November", "December"], (val) {
                setState(() => _selectedMonth = val!);
              }),
              const SizedBox(width: 32),
              _buildSearchButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Showing result records", style: TextStyle(color: Colors.grey)),
              _buildInlineSearchBar(),
            ],
          ),
          const SizedBox(height: 20),
          _buildReportTable(),
          const SizedBox(height: 20),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildInlineSearchBar() {
    return Container(
      width: 250,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: "Search date or remarks...",
          prefixIcon: Icon(Icons.search, size: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildReportTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFA6BDCC),
            child: Row(
              children: const [
                Expanded(child: _HeaderText("Date")),
                Expanded(child: _HeaderText("Clock-in")),
                Expanded(child: _HeaderText("Clock-out")),
                Expanded(child: _HeaderText("Hours Work")),
                Expanded(child: _HeaderText("Tardiness")),
                Expanded(child: _HeaderText("Remarks")),
              ],
            ),
          ),
          // Dynamic Rows
          if (_filteredRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("No records match your criteria"),
            )
          else
            ..._filteredRecords.map((record) => _buildRow(record)),
        ],
      ),
    );
  }

  Widget _buildRow(AttendanceRecord record) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(child: Text(record.date, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(record.inTime)),
          Expanded(child: Text(record.outTime)),
          Expanded(child: Text(record.hours)),
          Expanded(child: Text(record.tardy, style: TextStyle(color: record.tardy != "0 minute" ? Colors.red : Colors.black))),
          Expanded(child: Text(record.remark, style: TextStyle(color: record.remark == "Late" ? Colors.orange : Colors.green, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // REUSABLE COMPONENTS
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
  );

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EAF6),
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: () {}, // Filters update automatically via setState
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF000080),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: const Text("SEARCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF000080),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
      child: const Text("GENERATE PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }
}