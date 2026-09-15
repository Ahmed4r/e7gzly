import 'package:e7gzly/core/app_bottom_nav.dart';
import 'package:e7gzly/features/home/data/doctor_model.dart';
import 'package:e7gzly/features/home/presentation/doctor_booking_page.dart';
import 'package:e7gzly/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:see_more_text/see_more_text.dart';
import 'package:table_calendar/table_calendar.dart';

// ==========================================
// 1. DOCTOR DETAILS SCREEN
// ==========================================
class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Doctor Details',
          style: GoogleFonts.inter(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : const Color(0xFF1E293B),
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Card
            Container(
              padding: const EdgeInsets.all(12),
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 90,
                      height: 90,
                      color: const Color(0xFFE2E8F0),
                      child:
                          widget.doctor.imageUrl != null &&
                              widget.doctor.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.doctor.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Color(0xFF94A3B8),
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF94A3B8),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.doctor.specialty.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.doctor.clinic.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
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
            ),
            const SizedBox(height: 24),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.people_outline,
                  label: '${widget.doctor.patientsCount ?? 0}+',
                  subLabel: 'patients',
                ),
                _StatItem(
                  icon: Icons.workspace_premium_outlined,
                  label: '${widget.doctor.experienceYears ?? 0}+',
                  subLabel: 'experience',
                ),
                _StatItem(
                  icon: Icons.star_border,
                  label: '${widget.doctor.rating ?? 0}',
                  subLabel: 'rating',
                ),
                _StatItem(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.doctor.reviewsCount ?? 0}',
                  subLabel: 'reviews',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // About Me
            Text(
              'About me',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            SeeMoreText(
              text: widget.doctor.bio ?? 'No information available.',
              maxLines: 2,
              textStyle: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              linkStyle: GoogleFonts.inter(fontSize: 14, color: Colors.blue),
              seeMoreLessTextStyle: GoogleFonts.inter(
                fontSize: 14,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w400,
              ),
             
             
            ),
            const SizedBox(height: 24),

            // Working Time
            Text(
              'Working Time',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.doctor.workingDays ?? 'Not available'}, '
              '${widget.doctor.workingHours ?? ''}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),

            // Reviews Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Review Tile
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFCBD5E1),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emily Anderson',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '5.0 ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          ...List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookAppointmentScreen(doctor: widget.doctor),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Book Appointment',
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF1E293B), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff4B5563),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subLabel,
          style: GoogleFonts.inter(fontSize: 14, color: Color(0xff6B7280)),
        ),
      ],
    );
  }
}

// ==========================================
// 3. SUCCESS CONFIRMATION DIALOG WIDGET
// ==========================================
class SuccessDialogWidget extends StatelessWidget {
  final String doctorName;
  const SuccessDialogWidget({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Shield Icon Badge
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFA7F3D0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                size: 54,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Congratulations!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your appointment with Dr. $doctorName is confirmed for June 30, 2023, at 10:00 AM.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent user from dismissing manually
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Lottie.asset(
                          'assets/lottie/done.json',
                          repeat: false, // Ensure it plays only once
                        ),
                      );
                    },
                  );

                  // 2. Await the duration of the animation (e.g., 2 seconds)
                  await Future.delayed(const Duration(seconds: 2));

                  // 3. Verify context is still mounted before popping
                  if (!context.mounted) return;

                  // 4. Pop the dialog route
                  Navigator.of(context).pop();

                  // 5. Pop the target screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainWrapperScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Edit your appointment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
