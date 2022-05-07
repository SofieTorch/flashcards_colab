import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class TeamsDatabaseProvider {
  TeamsDatabaseProvider(this.database);

  final Database database;
  final String _collectionId = '6274b389a87c78af52de';

  Future<Document> create({
    required String id,
    required String name,
    String description = '',
  }) {
    return database.createDocument(
      collectionId: _collectionId,
      documentId: id,
      data: <String, dynamic>{
        'name': name,
        'description': description,
      },
      write: <String>['team:$id'],
      read: <String>['team:$id'],
    );
  }

  Future<Document> getTeam(String id) {
    return database.getDocument(collectionId: _collectionId, documentId: id);
  }
}
