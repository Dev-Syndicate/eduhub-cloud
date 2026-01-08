import 'package:equatable/equatable.dart';
import '../../../../core/models/announcement_model.dart';

/// Announcements BLoC events
abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

/// Load announcements
class AnnouncementsLoadRequested extends AnnouncementsEvent {
  final String? typeFilter;
  final bool? pinnedOnly;

  const AnnouncementsLoadRequested({
    this.typeFilter,
    this.pinnedOnly,
  });

  @override
  List<Object?> get props => [typeFilter, pinnedOnly];
}

/// Create announcement
class AnnouncementCreateRequested extends AnnouncementsEvent {
  final AnnouncementModel announcement;

  const AnnouncementCreateRequested(this.announcement);

  @override
  List<Object?> get props => [announcement];
}

/// Toggle pin status
class AnnouncementPinToggled extends AnnouncementsEvent {
  final String announcementId;
  final bool isPinned;

  const AnnouncementPinToggled({
    required this.announcementId,
    required this.isPinned,
  });

  @override
  List<Object?> get props => [announcementId, isPinned];
}

/// Filter changed
class AnnouncementsFilterChanged extends AnnouncementsEvent {
  final String? typeFilter;

  const AnnouncementsFilterChanged(this.typeFilter);

  @override
  List<Object?> get props => [typeFilter];
}

/// Delete announcement
class AnnouncementDeleteRequested extends AnnouncementsEvent {
  final String announcementId;

  const AnnouncementDeleteRequested(this.announcementId);

  @override
  List<Object?> get props => [announcementId];
}
