/// Resource type enumeration for campus resources
enum ResourceType {
  examSchedule,
  campusMap,
  holidayCalendar,
  feeSchedule,
  labBooking,
  other;

  String get value {
    switch (this) {
      case ResourceType.examSchedule:
        return 'exam_schedule';
      case ResourceType.campusMap:
        return 'campus_map';
      case ResourceType.holidayCalendar:
        return 'holiday_calendar';
      case ResourceType.feeSchedule:
        return 'fee_schedule';
      case ResourceType.labBooking:
        return 'lab_booking';
      case ResourceType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ResourceType.examSchedule:
        return 'Exam Schedule';
      case ResourceType.campusMap:
        return 'Campus Map';
      case ResourceType.holidayCalendar:
        return 'Holiday Calendar';
      case ResourceType.feeSchedule:
        return 'Fee Schedule';
      case ResourceType.labBooking:
        return 'Lab Booking';
      case ResourceType.other:
        return 'Other';
    }
  }

  static ResourceType fromString(String value) {
    switch (value) {
      case 'exam_schedule':
        return ResourceType.examSchedule;
      case 'campus_map':
        return ResourceType.campusMap;
      case 'holiday_calendar':
        return ResourceType.holidayCalendar;
      case 'fee_schedule':
        return ResourceType.feeSchedule;
      case 'lab_booking':
        return ResourceType.labBooking;
      default:
        return ResourceType.other;
    }
  }
}
