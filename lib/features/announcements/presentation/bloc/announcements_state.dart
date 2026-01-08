import 'package:equatable/equatable.dart';
import '../../../../core/models/announcement_model.dart';

/// Announcements BLoC states
abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AnnouncementsInitial extends AnnouncementsState {
  const AnnouncementsInitial();
}

/// Loading state
class AnnouncementsLoading extends AnnouncementsState {
  const AnnouncementsLoading();
}

/// Loaded state
class AnnouncementsLoaded extends AnnouncementsState {
  final List<AnnouncementModel> announcements;
  final List<AnnouncementModel> pinnedAnnouncements;
  final String? activeFilter;

  const AnnouncementsLoaded({
    required this.announcements,
    required this.pinnedAnnouncements,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [announcements, pinnedAnnouncements, activeFilter];

  List<AnnouncementModel> get filteredAnnouncements {
    if (activeFilter == null) return announcements;
    return announcements.where((a) => a.type.value == activeFilter).toList();
  }

  AnnouncementsLoaded copyWith({
    List<AnnouncementModel>? announcements,
    List<AnnouncementModel>? pinnedAnnouncements,
    String? activeFilter,
  }) {
    return AnnouncementsLoaded(
      announcements: announcements ?? this.announcements,
      pinnedAnnouncements: pinnedAnnouncements ?? this.pinnedAnnouncements,
      activeFilter: activeFilter,
    );
  }
}

/// Creating announcement
class AnnouncementCreating extends AnnouncementsState {
  const AnnouncementCreating();
}

/// Announcement created
class AnnouncementCreated extends AnnouncementsState {
  final String announcementId;

  const AnnouncementCreated(this.announcementId);

  @override
  List<Object?> get props => [announcementId];
}

/// Error state
class AnnouncementsError extends AnnouncementsState {
  final String message;

  const AnnouncementsError(this.message);

  @override
  List<Object?> get props => [message];
}
