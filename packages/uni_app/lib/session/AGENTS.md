## Authentication in UNI

Two session types, both following the same base interfaces:
- `flows/base/initiator`- created a `SessionRequest`
- `flows/base/request`- performs the authentication
- `flows/base/session`- session class definition

If authentication fails, throws `AuthenticationException`

The `Session` is imutable - If you need to change something you need to use `copyWith`or create a new object.

### Credential Session
Login directly with username and password against SIGARRA

SIGARRA always returns HTTP 200 - parse the HTML response to know if succeeded:
```dart
// Success: page has <meta http-equiv="refresh">
// Failure: look for p.aviso-invalidado (wrong credentials, blocked account)
//          or p.erro-nota (already logged in)
```

The login flows fetches the real username and faculties after authenticating, since the login response doesn't include them.
`tempFaculty = feup` is used because FEUP's home page exposes the real username in the photo URL:
```dart
final username = photoUrl?.queryParameters['pct_cod'];
```

Cookies are injected via `CookieClient` - pass a lambda so it always fetches the latest cookies after a session refresh:
```dart
// ✅
final client = CookieClient(httpClient, cookies: () => session.cookies);
// ❌ cookies: session.cookies  — stale after refresh
```

### Federated Session

Login via OpenID Connect (OIDC) with Authorization Code + PKCE — the user 
authenticates directly on the UP's server, the app never sees the password.

The realm and clientID variables are declarted in `utils/constants.dart`.

**Initiator flow:**
1. `Issuer.discover(realm)` — fetches OIDC endpoints from `{realm}/.well-known/openid-configuration` (only on login, not on session restore)
2. `performAuthentication(flow)` — opens browser, user logs in on UP's page, returns callback URI with authorization code
3. `flow.callback(uri.queryParameters)` — exchanges auth code for tokens → `credential`

**Request flow:**
1. `credential.createHttpClient()` — HTTP client that injects `Authorization: Bearer <token>` automatically
2. `SigarraOidc().token()` — exchanges access token for SIGARRA cookies (SIGARRA has its own OIDC endpoint)
3. `credential.getUserInfo()` — fetches username (`nmec`) and faculties (`ous`) from UP's `/userinfo` endpoint

The `credential` object contains everything needed for future requests and session
refresh — no need to re-discover or re-authenticate.

**Session refresh:** uses the refresh token inside `credential`, no user interaction needed.