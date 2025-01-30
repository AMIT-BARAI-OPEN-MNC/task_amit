import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_amit/data/search_model.dart';

class HiveStorage {
  static const String boxName = 'favorites';
  static late Box<Post> _box;

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // ✅ Register all necessary adapters
    Hive.registerAdapter(PostAdapter());
    Hive.registerAdapter(ReactionsAdapter());

    _box = await Hive.openBox<Post>(boxName);
  }

  static Future<void> savePost(Post post) async {
    if (!_box.containsKey(post.id)) {
      await _box.put(post.id, post);
    }
  }

  static Future<void> removePost(int postId) async {
    await _box.delete(postId);
  }

  static List<Post> getSavedPosts() {
    return _box.values.toList();
  }

  static bool isPostSaved(int postId) {
    return _box.containsKey(postId);
  }
}

// ✅ PostAdapter
class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 0;

  @override
  Post read(BinaryReader reader) {
    return Post(
      id: reader.readInt(),
      title: reader.readString(),
      body: reader.readString(),
      tags: reader.readList().cast<String>(),
      reactions: reader.read() as Reactions,
      views: reader.readInt(),
      userId: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeList(obj.tags);
    writer.write(obj.reactions);
    writer.writeInt(obj.views);
    writer.writeInt(obj.userId);
  }
}

// ✅ ReactionsAdapter
class ReactionsAdapter extends TypeAdapter<Reactions> {
  @override
  final int typeId = 1;

  @override
  Reactions read(BinaryReader reader) {
    return Reactions(
      likes: reader.readInt(),
      dislikes: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Reactions obj) {
    writer.writeInt(obj.likes);
    writer.writeInt(obj.dislikes);
  }
}
