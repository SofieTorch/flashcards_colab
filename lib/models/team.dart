import 'package:equatable/equatable.dart';

class Team extends Equatable {
  const Team({
    this.name = '',
    this.description = '',
    this.id = '',
    this.members = 0,
  });

  final String name;
  final String description;
  final String id;
  final int members;

  Team copyWith({
    String? name,
    String? description,
    String? id,
    int? members,
  }) {
    return Team(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [name, description, id, members];
}
