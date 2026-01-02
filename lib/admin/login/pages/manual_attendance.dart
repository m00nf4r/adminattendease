import 'package:flutter/material.dart';

class ManualAttendancePage extends StatefulWidget {
  const ManualAttendancePage({super.key});

  @override
  State<ManualAttendancePage> createState() => _ManualAttendancePageState();
}

class _ManualAttendancePageState extends State<ManualAttendancePage> {
  String _selectedId = "EMP001";
  String _employeeName = "Hani Syakirah";
  
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _inTimeController = TextEditingController();
  final TextEditingController _outTimeController = TextEditingController();

  // 1. DATE PICKER FUNCTION
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        // Formats date as YYYY-MM-DD
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // 2. TIME PICKER FUNCTION
  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        // Formats time as HH:MM AM/PM
        _inTimeController.text = picked.format(context);
        controller.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text("Attendance / Manual Attendance", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            // SEARCH BOX (Same as before)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Manual Attendance Entry", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(height: 32),
                  Row(
                    children: [
                      _buildDropdown(),
                      const SizedBox(width: 20),
                      _buildSearchButton(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DETAILS BOX WITH PICKERS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ATTENDANCE DETAILS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 20),
                  _detailRow("Employee's Name:", Text(_employeeName)),
                  
                  // DATE SELECTION
                  _detailRow("Date:", _buildPickerField(
                    controller: _dateController, 
                    hint: "Select Date", 
                    icon: Icons.calendar_today, 
                    onTap: _selectDate
                  )),

                  // CLOCK IN SELECTION
                  _detailRow("Clock-In Time:", _buildPickerField(
                    controller: _inTimeController, 
                    hint: "Select Time", 
                    icon: Icons.access_time, 
                    onTap: () => _selectTime(_inTimeController)
                  )),

                  // CLOCK OUT SELECTION
                  _detailRow("Clock-Out Time:", _buildPickerField(
                    controller: _outTimeController, 
                    hint: "Select Time", 
                    icon: Icons.access_time, 
                    onTap: () => _selectTime(_outTimeController)
                  )),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton("ADD", const Color(0xFF0B1D4D), () {}),
                const SizedBox(width: 20),
                _buildActionButton("CLEAR", Colors.red.shade900, () {
                  _dateController.clear();
                  _inTimeController.clear();
                  _outTimeController.clear();
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Helper for the Picker TextFields
  Widget _buildPickerField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    required VoidCallback onTap
  }) {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: controller,
        readOnly: true, // Prevents keyboard from opening
        onTap: onTap,    // Opens the picker
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  // --- EXISTING HELPERS ---
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
  );

  Widget _detailRow(String label, Widget inputWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          inputWidget,
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedId,
          items: ["EMP001", "EMP002"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => _selectedId = val!),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _employeeName = _selectedId == "EMP001" ? "Hani Syakirah" : "New Employee"),
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B1D4D), padding: const EdgeInsets.all(18)),
      child: const Text("SEARCH", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 15)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}