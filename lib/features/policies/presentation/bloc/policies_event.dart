import 'package:equatable/equatable.dart';

abstract class PoliciesEvent extends Equatable {
  const PoliciesEvent();

  @override
  List<Object> get props => [];
}

class PoliciesStarted extends PoliciesEvent {
  const PoliciesStarted();
}

class PoliciesRefreshRequested extends PoliciesEvent {
  const PoliciesRefreshRequested();
}
