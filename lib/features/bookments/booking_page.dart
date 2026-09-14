import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

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
        body: const TabBarView(
          children: [
            _UpcomingBookingsList(),
            _CompletedBookingsList(),
            Center(
              child: Text(
                'No canceled bookings',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      
      ),
    );
  }
}

class _UpcomingBookingsList extends StatelessWidget {
  const _UpcomingBookingsList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        BookingCard(
          dateTime: 'May 22, 2023 - 10.00 AM',
          doctorName: 'Dr. James Robinson',
          specialty: 'Orthopedic Surgery',
          location: 'Elite Ortho Clinic, USA',
          leftButtonText: 'Cancel',
          rightButtonText: 'Reschedule',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
        BookingCard(
          dateTime: 'June 14, 2023 - 15.00 PM',
          doctorName: 'Dr. Daniel Lee',
          specialty: 'Gastroenterologist',
          location: 'Digestive Institute, USA',
          leftButtonText: 'Cancel',
          rightButtonText: 'Reschedule',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
        BookingCard(
          dateTime: 'June 21, 2023 - 10.00 AM',
          doctorName: 'Dr. Nathan Harris',
          specialty: 'Cardiologist',
          location: 'HeartCare Center, USA',
          leftButtonText: 'Cancel',
          rightButtonText: 'Reschedule',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
      ],
    );
  }
}

class _CompletedBookingsList extends StatelessWidget {
  const _CompletedBookingsList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        BookingCard(
          dateTime: 'March 12, 2023 - 11.00 AM',
          doctorName: 'Dr. Sarah Johnson',
          specialty: 'Gynecologist',
          location: "Women's Health Clinic",
          leftButtonText: 'Re-Book',
          rightButtonText: 'Add Review',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
        BookingCard(
          dateTime: 'March 2, 2023 - 12.00 AM',
          doctorName: 'Dr. Michael Chang',
          specialty: 'Cardiologist',
          location: 'HeartCare Center, USA',
          leftButtonText: 'Re-Book',
          rightButtonText: 'Add Review',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
        BookingCard(
          dateTime: 'Feb 2, 2023 - 9.00 AM',
          doctorName: 'Dr. Robert Smith',
          specialty: 'Dermatologist',
          location: 'Skin Care Center, USA',
          leftButtonText: 'Re-Book',
          rightButtonText: 'Add Review',
          onLeftButtonPressed: () {},
          onRightButtonPressed: () {},
        ),
      ],
    );
  }
}

class BookingCard extends StatelessWidget {
  final String dateTime;
  final String doctorName;
  final String specialty;
  final String location;
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
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF94A3B8),
                  size: 36,
                ),
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
