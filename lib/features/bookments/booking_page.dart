import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e7gzly/features/bookments/data/appointment_model.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _isLoading = true;
  List<AppointmentModel> _upcoming = [];
  List<AppointmentModel> _completed = [];
  List<AppointmentModel> _canceled = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/appointments/patient/1'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final appointments = jsonList.map((e) => AppointmentModel.fromJson(e)).toList();

        setState(() {
          _upcoming = appointments.where((a) => a.status == 'CONFIRMED' || a.status == 'PENDING').toList();
          _completed = appointments.where((a) => a.status == 'COMPLETED').toList();
          _canceled = appointments.where((a) => a.status == 'CANCELED').toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          title: const Text(
            'My Bookings',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF1E293B),
            unselectedLabelColor: Color(0xFF94A3B8),
            indicatorColor: Color(0xFF1E293B),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _BookingsList(appointments: _upcoming, isUpcoming: true),
                  _BookingsList(appointments: _completed, isUpcoming: false),
                  _BookingsList(appointments: _canceled, isUpcoming: false),
                ],
              ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final bool isUpcoming;

  const _BookingsList({required this.appointments, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Text(
          'No bookings found',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        
        // Format date and time
        final dateObj = DateTime.tryParse(apt.date) ?? DateTime.now();
        final dateFormatted = DateFormat('MMM d, yyyy').format(dateObj);
        
        // Time from "10:30:00" to "10:30 AM"
        final timeParts = apt.time.split(':');
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = timeParts[1];
        final ampm = hour >= 12 ? 'PM' : 'AM';
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final timeFormatted = '$hour12:$minute $ampm';

        return BookingCard(
          dateTime: '$dateFormatted - $timeFormatted',
          doctorName: apt.doctor.name,
          specialty: apt.doctor.specialty.name,
          location: apt.doctor.clinic.name,
          imageUrl: apt.doctor.imageUrl,
          leftButtonText: isUpcoming ? 'Cancel' : 'Re-Book',
          rightButtonText: isUpcoming ? 'Reschedule' : 'Add Review',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final String dateTime;
  final String doctorName;
  final String specialty;
  final String location;
  final String? imageUrl;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;

  const BookingCard({
    super.key,
    required this.dateTime,
    required this.doctorName,
    required this.specialty,
    required this.location,
    this.imageUrl,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateTime,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                  image: imageUrl != null && imageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl == null || imageUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Color(0xFF94A3B8),
                        size: 36,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onLeftButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    leftButtonText,
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRightButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    rightButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
