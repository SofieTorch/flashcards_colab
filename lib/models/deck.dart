import 'package:equatable/equatable.dart';

class Deck extends Equatable {
  const Deck({
    required this.title,
    this.id,
  });

  final String title;
  final String? id;

  @override
  List<Object?> get props => [title, id];
}
