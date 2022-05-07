import 'package:equatable/equatable.dart';

class Team extends Equatable {
  const Team({
    this.name = '',
    this.description = '',
    this.id = '',
  });

  final String name;
  final String description;
  final String id;

  @override
  List<Object?> get props => [name, description, id];
}
