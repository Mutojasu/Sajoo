abstract class ProfileRepository { Future<void> save(Profile p); }
class InMemoryProfileRepository implements ProfileRepository {
  Profile? _p;
  @override Future<void> save(Profile p) async { _p = p; }
  Profile? get current => _p;
}
