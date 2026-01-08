import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/announcements_remote_datasource.dart';
import 'announcements_event.dart';
import 'announcements_state.dart';

/// Announcements BLoC
class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final AnnouncementsRemoteDataSource _dataSource;

  AnnouncementsBloc({AnnouncementsRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? AnnouncementsRemoteDataSource(),
        super(const AnnouncementsInitial()) {
    on<AnnouncementsLoadRequested>(_onLoadRequested);
    on<AnnouncementCreateRequested>(_onCreateRequested);
    on<AnnouncementPinToggled>(_onPinToggled);
    on<AnnouncementsFilterChanged>(_onFilterChanged);
    on<AnnouncementDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    AnnouncementsLoadRequested event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(const AnnouncementsLoading());

    try {
      final announcements = await _dataSource.getAnnouncements(
        type: event.typeFilter,
        pinnedOnly: event.pinnedOnly,
      );

      final pinnedAnnouncements =
          announcements.where((a) => a.isPinned).toList();
      final regularAnnouncements =
          announcements.where((a) => !a.isPinned).toList();

      emit(AnnouncementsLoaded(
        announcements: regularAnnouncements,
        pinnedAnnouncements: pinnedAnnouncements,
        activeFilter: event.typeFilter,
      ));
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    AnnouncementCreateRequested event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(const AnnouncementCreating());

    try {
      final id = await _dataSource.createAnnouncement(event.announcement);
      emit(AnnouncementCreated(id));

      // Refresh the list
      add(const AnnouncementsLoadRequested());
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onPinToggled(
    AnnouncementPinToggled event,
    Emitter<AnnouncementsState> emit,
  ) async {
    try {
      await _dataSource.togglePin(event.announcementId, event.isPinned);

      // Refresh the list
      add(const AnnouncementsLoadRequested());
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onFilterChanged(
    AnnouncementsFilterChanged event,
    Emitter<AnnouncementsState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementsLoaded) {
      emit(currentState.copyWith(activeFilter: event.typeFilter));
    }
  }

  Future<void> _onDeleteRequested(
    AnnouncementDeleteRequested event,
    Emitter<AnnouncementsState> emit,
  ) async {
    try {
      await _dataSource.deleteAnnouncement(event.announcementId);

      // Refresh the list
      add(const AnnouncementsLoadRequested());
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }
}
