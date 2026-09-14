import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          'Notification',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '1 New',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          // Section: TODAY
          NotificationSectionHeader(title: 'TODAY'),
          NotificationTile(
            title: 'Appointment Success',
            subtitle: 'You have successfully booked your appointment with Dr. Emily Walker.',
            time: '1h',
            type: NotificationType.success,
            isUnread: false,
          ),
          NotificationTile(
            title: 'Appointment Cancelled',
            subtitle: 'You have successfully cancelled your appointment with Dr. David Patel.',
            time: '2h',
            type: NotificationType.cancelled,
            isUnread: true,
          ),
          NotificationTile(
            title: 'Scheduled Changed',
            subtitle: 'You have successfully changes your appointment with Dr. Jesica Turner.',
            time: '8h',
            type: NotificationType.changed,
            isUnread: false,
          ),

          SizedBox(height: 16),

          // Section: YESTERDAY
          NotificationSectionHeader(title: 'YESTERDAY'),
          NotificationTile(
            title: 'Appointment success',
            subtitle: 'You have successfully booked your appointment with Dr. David Patel.',
            time: '1d',
            type: NotificationType.success,
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

enum NotificationType { success, cancelled, changed }

class NotificationSectionHeader extends StatelessWidget {
  final String title;

  const NotificationSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  final bool isUnread;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    Color avatarBgColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case NotificationType.success:
        avatarBgColor = const Color(0xFFDCFCE7);
        iconColor = const Color(0xFF166534);
        iconData = Icons.event_available_rounded;
        break;
      case NotificationType.cancelled:
        avatarBgColor = const Color(0xFFFFE4E6);
        iconColor = const Color(0xFF991B1B);
        iconData = Icons.event_busy_rounded;
        break;
      case NotificationType.changed:
        avatarBgColor = const Color(0xFFF1F5F9);
        iconColor = const Color(0xFF334155);
        iconData = Icons.edit_calendar_rounded;
        break;
    }

    return Container(
      color: isUnread ? const Color(0xFFF8FAFC) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: avatarBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
