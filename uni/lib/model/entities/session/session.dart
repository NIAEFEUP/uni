abstract class AbstractSession {
  bool authenticated;
  bool persistentSession;
  String cookies;

  AbstractSession(
      {this.authenticated = false,
      this.cookies = '',
      this.persistentSession = false});
}