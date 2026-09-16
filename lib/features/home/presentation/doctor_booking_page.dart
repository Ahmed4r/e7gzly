import 'package:e7gzly/core/api_constants.dart';
import 'package:e7gzly/features/home/data/doctor_model.dart';
import 'package:e7gzly/features/home/presentation/doctor_details_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;
  final bool update;
  final int? appointmentId;
  final int? patientId;

  const BookAppointmentScreen({
    super.key,
    required this.doctor,
    this.update = false,
    this.appointmentId,
    this.patientId,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool _isLoading = false;
  DateTime date = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  String _selectedTimeSlot = '10.00 AM';

  final List<String> _timeSlots = [
    '09.00 AM',
    '09.30 AM',
    '10.00 AM',
    '10.30 AM',
    '11.00 AM',
    '11.30 AM',
    '3.00 PM',
    '3.30 PM',
    '4.00 PM',
    '4.30 PM',
    '5.00 PM',
    '5.30 PM',
  ];
  bool _isTimeSlotInPast(String slot) {
    if (_selectedDay == null) return false;

    final now = DateTime.now();

    // Future dates → all slots are valid
    if (!_isSameDate(_selectedDay!, now)) {
      return false;
    }

    final parts = slot.split(' ');
    final timeParts = parts[0].split('.');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final amPm = parts[1];

    if (amPm == 'PM' && hour != 12) {
      hour += 12;
    }

    if (amPm == 'AM' && hour == 12) {
      hour = 0;
    }

    final slotTime = DateTime(now.year, now.month, now.day, hour, minute);

    return slotTime.isBefore(now);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _submitBooking() async {
    if (_selectedDay == null) return;

    setState(() => _isLoading = true);

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);

      final timeParts = _selectedTimeSlot.split(' ');
      final timeStr = timeParts[0].replaceAll('.', ':');
      final ampm = timeParts[1];

      int hour = int.parse(timeStr.split(':')[0]);
      final minute = timeStr.split(':')[1];

      if (ampm == 'PM' && hour != 12) {
        hour += 12;
      }

      if (ampm == 'AM' && hour == 12) {
        hour = 0;
      }

      final timeFormatted = '${hour.toString().padLeft(2, '0')}:$minute:00';

      late http.Response response;

      if (widget.update) {
        // =========================
        // UPDATE APPOINTMENT
        // =========================

        if (widget.appointmentId == null || widget.patientId == null) {
          throw Exception('Appointment ID or Patient ID is missing');
        }

        final requestBody = {'date': dateStr, 'time': timeFormatted};

        response = await http.put(
          Uri.parse(
            'http://10.0.2.2:8080/api/appointments/'
            '${widget.appointmentId}/patient/${widget.patientId}',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
      } else {
        // =========================
        // CREATE APPOINTMENT
        // =========================

        if (widget.patientId == null) {
          throw Exception('Patient ID is missing');
        }

        final requestBody = {
          'doctorId': widget.doctor.id,
          'patientId': widget.patientId,
          'date': dateStr,
          'time': timeFormatted,
        };

        response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}/api/appointments'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showConfirmationDialog();
      } else {
        throw Exception('Failed: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.update
                ? 'Error updating appointment: $e'
                : 'Error booking appointment: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => SuccessDialogWidget(doctorName: widget.doctor.name),
    );
  }

  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(today.year, today.month, today.day),
                lastDay: DateTime.utc(2030, 12, 31),

                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  titleTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  // 1. Add default decoration override
                  defaultDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // 2. Add weekend decoration override
                  weekendDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // Existing configurations:
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  outsideDaysVisible: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Hour',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final slot = _timeSlots[index];

                final isPast = _isTimeSlotInPast(slot);
                final isSelected = slot == _selectedTimeSlot;

                return GestureDetector(
                  onTap: isPast
                      ? null
                      : () {
                          setState(() {
                            _selectedTimeSlot = slot;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isPast
                          ? const Color(0xFFE2E8F0)
                          : isSelected
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isPast
                            ? const Color(0xFF94A3B8)
                            : isSelected
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
