import 'package:equatable/equatable.dart';

class Membership extends Equatable {
  const Membership({
    this.teamId = '',
    this.membershipId = '',
    this.userId = '',
    this.secret = '',
  });

  final String teamId;
  final String membershipId;
  final String userId;
  final String secret;

  @override
  List<Object?> get props => [teamId, membershipId, userId, secret];
}
