# Refactor api_client.dart to use API constants

**Session ID:** ses_2628fe9d1ffe4xv4yLyvlXfB8C
**Created:** 4/18/2026, 3:24:21 AM
**Updated:** 4/18/2026, 3:47:03 AM

---

## User

[search-mode]
MAXIMIZE SEARCH EFFORT. Launch multiple background agents IN PARALLEL:
- explore agents (codebase patterns, file structures, ast-grep)
- librarian agents (remote repos, official docs, GitHub examples)
  Plus direct tools: Grep, ripgrep (rg), ast-grep (sg)
  NEVER stop at first result - be exhaustive.

[analyze-mode]
ANALYSIS MODE. Gather context before diving deep:
CONTEXT GATHERING (parallel):
- 1-2 explore agents (codebase patterns, implementations)
- 1-2 librarian agents (if external library involved)
- Direct tools: Grep, AST-grep, LSP for targeted searches

IF COMPLEX - DO NOT STRUGGLE ALONE. Consult specialists:
- **Oracle**: Conventional problems (architecture, debugging, complex logic)
- **Artistry**: Non-conventional problems (different approach needed)

SYNTHESIZE findings before proceeding.
---
MANDATORY delegate_task params: ALWAYS include load_skills=[] and run_in_background when calling delegate_task.
Example: delegate_task(subagent_type="explore", prompt="...", run_in_background=true, load_skills=[])

---

<auto-slash-command>
# /bmad-help Command

**Description**: (opencode-project - Skill) Analyzes current state and user query to answer BMad questions or recommend the next skill(s) to use. Use when user asks for help, bmad help, what to do next, or what to start with in BMad.

**User Arguments**: /caveman

the @lib/core/api/api_client.dart should stricly use all teh constant string from api constatnts file. all endpoitns, base urls and other urls should be called from there.

keep in mind to striclty use from this file.

**Scope**: skill

---

## Command Instructions

<skill-instruction>
Base directory for this skill: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/
File references ([file not found: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/path)] in this skill are relative to this directory.

# BMad Help

## Purpose

Help the user understand where they are in their BMad workflow and what to do next, and also answer broader questions when asked that could be augmented with remote sources such as module documentation sources.

## Desired Outcomes

When this skill completes, the user should:

1. **Know where they are** — which module and phase they're in, what's already been completed
2. **Know what to do next** — the next recommended and/or required step, with clear reasoning
3. **Know how to invoke it** — skill name, menu code, action context, and any args that shortcut the conversation
4. **Get offered a quick start** — when a single skill is the clear next step, offer to run it for the user right now rather than just listing it
5. **Feel oriented, not overwhelmed** — surface only what's relevant to their current position; don't dump the entire catalog
6. **Get answers to general questions** — when the question doesn't map to a specific skill, use the module's registered documentation to give a grounded answer

## Data Sources

- **Catalog**: `{project-root}/_bmad/_config/bmad-help.csv` — assembled manifest of all installed module skills
- **Config**: `config.yaml` and `user-config.yaml` files in `{project-root}/_bmad/` and its subfolders — resolve `output-location` variables, provide `communication_language` and `project_knowledge`
- **Artifacts**: Files matching `outputs` patterns at resolved `output-location` paths reveal which steps are possibly completed; their content may also provide grounding context for recommendations
- **Project knowledge**: If `project_knowledge` resolves to an existing path, read it for grounding context. Never fabricate project-specific details.
- **Module docs**: Rows with `_meta` in the `skill` column carry a URL or path in `output-location` pointing to the module's documentation (e.g., llms.txt). Fetch and use these to answer general questions about that module.

## CSV Interpretation

The catalog uses this format:

```
module,skill,display-name,menu-code,description,action,args,phase,after,before,required,output-location,outputs
```

**Phases** determine the high-level flow:
- `anytime` — available regardless of workflow state
- Numbered phases (`1-analysis`, `2-planning`, etc.) flow in order; naming varies by module

**Dependencies** determine ordering within and across phases:
- `after` — skills that should ideally complete before this one
- `before` — skills that should run after this one
- Format: `skill-name` for single-action skills, `skill-name:action` for multi-action skills

**Required gates**:
- `required=true` items must complete before the user can meaningfully proceed to later phases
- A phase with no required items is entirely optional — recommend it but be clear about what's actually required next

**Completion detection**:
- Search resolved output paths for `outputs` patterns
- Fuzzy-match found files to catalog rows
- User may also state completion explicitly, or it may be evident from the current conversation

**Descriptions carry routing context** — some contain cycle info and alternate paths (e.g., "back to DS if fixes needed"). Read them as navigation hints, not just display text.

## Response Format

For each recommended item, present:
- `[menu-code]` **Display name** — e.g., "[CP] Create PRD"
- Skill name in backticks — e.g., `bmad-create-prd`
- For multi-action skills: action invocation context — e.g., "tech-writer lets create a mermaid diagram!"
- Description if present in CSV; otherwise your existing knowledge of the skill suffices
- Args if available

**Ordering**: Show optional items first, then the next required item. Make it clear which is which.

## Constraints

- Present all output in `{communication_language}`
- Recommend running each skill in a **fresh context window**
- Match the user's tone — conversational when they're casual, structured when they want specifics
- If the active module is ambiguous, retrieve all meta rows remote sources to find relevant info also to help answer their question
  </skill-instruction>

<user-request>
/caveman

the @lib/core/api/api_client.dart should stricly use all teh constant string from api constatnts file. all endpoitns, base urls and other urls should be called from there.

keep in mind to striclty use from this file.
</user-request>


---

## User Request

/caveman

the @lib/core/api/api_client.dart should stricly use all teh constant string from api constatnts file. all endpoitns, base urls and other urls should be called from there.

keep in mind to striclty use from this file.
</auto-slash-command>

<skill-instruction>
Base directory for this skill: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/
File references (@path) in this skill are relative to this directory.

# BMad Help

## Purpose

Help the user understand where they are in their BMad workflow and what to do next, and also answer broader questions when asked that could be augmented with remote sources such as module documentation sources.

## Desired Outcomes

When this skill completes, the user should:

1. **Know where they are** — which module and phase they're in, what's already been completed
2. **Know what to do next** — the next recommended and/or required step, with clear reasoning
3. **Know how to invoke it** — skill name, menu code, action context, and any args that shortcut the conversation
4. **Get offered a quick start** — when a single skill is the clear next step, offer to run it for the user right now rather than just listing it
5. **Feel oriented, not overwhelmed** — surface only what's relevant to their current position; don't dump the entire catalog
6. **Get answers to general questions** — when the question doesn't map to a specific skill, use the module's registered documentation to give a grounded answer

## Data Sources

- **Catalog**: `{project-root}/_bmad/_config/bmad-help.csv` — assembled manifest of all installed module skills
- **Config**: `config.yaml` and `user-config.yaml` files in `{project-root}/_bmad/` and its subfolders — resolve `output-location` variables, provide `communication_language` and `project_knowledge`
- **Artifacts**: Files matching `outputs` patterns at resolved `output-location` paths reveal which steps are possibly completed; their content may also provide grounding context for recommendations
- **Project knowledge**: If `project_knowledge` resolves to an existing path, read it for grounding context. Never fabricate project-specific details.
- **Module docs**: Rows with `_meta` in the `skill` column carry a URL or path in `output-location` pointing to the module's documentation (e.g., llms.txt). Fetch and use these to answer general questions about that module.

## CSV Interpretation

The catalog uses this format:

```
module,skill,display-name,menu-code,description,action,args,phase,after,before,required,output-location,outputs
```

**Phases** determine the high-level flow:
- `anytime` — available regardless of workflow state
- Numbered phases (`1-analysis`, `2-planning`, etc.) flow in order; naming varies by module

**Dependencies** determine ordering within and across phases:
- `after` — skills that should ideally complete before this one
- `before` — skills that should run after this one
- Format: `skill-name` for single-action skills, `skill-name:action` for multi-action skills

**Required gates**:
- `required=true` items must complete before the user can meaningfully proceed to later phases
- A phase with no required items is entirely optional — recommend it but be clear about what's actually required next

**Completion detection**:
- Search resolved output paths for `outputs` patterns
- Fuzzy-match found files to catalog rows
- User may also state completion explicitly, or it may be evident from the current conversation

**Descriptions carry routing context** — some contain cycle info and alternate paths (e.g., "back to DS if fixes needed"). Read them as navigation hints, not just display text.

## Response Format

For each recommended item, present:
- `[menu-code]` **Display name** — e.g., "[CP] Create PRD"
- Skill name in backticks — e.g., `bmad-create-prd`
- For multi-action skills: action invocation context — e.g., "tech-writer lets create a mermaid diagram!"
- Description if present in CSV; otherwise your existing knowledge of the skill suffices
- Args if available

**Ordering**: Show optional items first, then the next required item. Make it clear which is which.

## Constraints

- Present all output in `{communication_language}`
- Recommend running each skill in a **fresh context window**
- Match the user's tone — conversational when they're casual, structured when they want specifics
- If the active module is ambiguous, retrieve all meta rows remote sources to find relevant info also to help answer their question
  </skill-instruction>

<user-request>
/caveman

the @lib/core/api/api_client.dart should stricly use all teh constant string from api constatnts file. all endpoitns, base urls and other urls should be called from there.

keep in mind to striclty use from this file.
</user-request>

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 9.3s)

I detect **implementation** intent — replace all hardcoded strings in `api_client.dart` with constants from an API constants file. Let me find the constants file first.

**Tool: glob**

**Input:**
```json
{
  "pattern": "**/api_constant*",
  "path": "/Users/pratham/code/gz_app/lib"
}
```

**Output:**
```
No files found
[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

**Tool: grep**

**Input:**
```json
{
  "pattern": "api.*constant|ApiConstant|APIConstant",
  "path": "/Users/pratham/code/gz_app/lib",
  "include": "*.dart",
  "output_mode": "files_with_matches"
}
```

**Output:**
```
No matches found
[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

**Tool: grep**

**Input:**
```json
{
  "pattern": "http://192\\.168|https://gz\\.api|/auth/refresh",
  "path": "/Users/pratham/code/gz_app/lib",
  "include": "*.dart",
  "output_mode": "content"
}
```

**Output:**
```
Found 6 match(es) in 4 file(s)

/Users/pratham/code/gz_app/lib/models/api_responses.dart
  9: // Shape returned by /auth/login/email, /auth/verify/otp, /auth/refresh

/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart
  85: '/auth/refresh',

/Users/pratham/code/gz_app/lib/core/api/api_client.dart
  199: // baseUrl: 'http://192.168.1.4:3000',
  200: baseUrl: 'https://gz.api.splin.app',
  210: final uri = Uri.parse('http://192.168.1.4:3000/auth/refresh');

/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart
  46: .head(Uri.parse('http://192.168.1.4:3000/health'))

[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

[Category+Skill Reminder]

**Built-in**: playwright, frontend-ui-ux, git-master, dev-browser, review-work, ai-slop-remover
**⚡ YOUR SKILLS (PRIORITY)**: compress, caveman-compress, caveman, caveman-commit, find-skills, bmad-editorial-review-structure, bmad-technical-research, bmad-help (+38 more)

> User-installed skills OVERRIDE built-in defaults. ALWAYS prefer YOUR SKILLS when domain matches.

```typescript
task(category="visual-engineering", load_skills=["compress"], run_in_background=true)
```

```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.1s)

No API constants file exists yet. I also see hardcoded URLs in `api_client.dart` and `connectivity_service.dart`. Let me check `auth_service.dart` for its endpoint patterns too.

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart</path>
<type>file</type>
<content>
1: import 'package:flutter_riverpod/flutter_riverpod.dart';
2: import '../../../../core/api/api_client.dart';
3: import '../../../../core/auth/token_storage.dart';
4: import '../../../../models/api_responses.dart';
5: 
6: class AuthService {
7:   final ApiClient _apiClient;
8:   final TokenStorage _tokenStorage;
9: 
10:   AuthService(this._apiClient, this._tokenStorage);
11: 
12:   // ─── Login with Email ──────────────────────────────────────────────
13:   Future<AuthTokenResponse> loginWithEmail(
14:     String email,
15:     String password,
16:   ) async {
17:     final data = await _apiClient.post(
18:       '/auth/login/email',
19:       body: {'email': email, 'password': password},
20:     );
21:     return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
22:   }
23: 
24:   // ─── Login with OTP (request OTP) ─────────────────────────────────
25:   Future<void> loginWithOtp(String phone) async {
26:     await _apiClient.post('/auth/login/otp', body: {'phone': phone});
27:   }
28: 
29:   // ─── Verify OTP ───────────────────────────────────────────────────
30:   Future<AuthTokenResponse> verifyOtp(String phone, String code) async {
31:     final data = await _apiClient.post(
32:       '/auth/verify/otp',
33:       body: {'phone': phone, 'code': code},
34:     );
35:     return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
36:   }
37: 
38:   // ─── Get current user (requires Bearer token via ApiClient) ───────
39:   Future<UserResponse> getMe() async {
40:     final data = await _apiClient.get('/auth/me');
41:     return UserResponse.fromJson(data as Map<String, dynamic>);
42:   }
43: 
44:   // ─── Request password reset email ─────────────────────────────────
45:   Future<void> requestPasswordReset(String email) async {
46:     await _apiClient.post(
47:       '/auth/password/reset/request',
48:       body: {'email': email},
49:     );
50:   }
51: 
52:   // ─── Confirm password reset ───────────────────────────────────────
53:   Future<void> resetPassword(String token, String newPassword) async {
54:     await _apiClient.post(
55:       '/auth/password/reset/confirm',
56:       body: {'token': token, 'newPassword': newPassword},
57:     );
58:   }
59: 
60:   // ─── Logout ───────────────────────────────────────────────────────
61:   Future<void> logout() async {
62:     await _apiClient.post('/auth/logout');
63:     await _tokenStorage.clearAll();
64:   }
65: 
66:   // ─── Register ─────────────────────────────────────────────────────
67:   Future<UserResponse> register({
68:     required String name,
69:     String? phone,
70:     String? email,
71:     String? password,
72:   }) async {
73:     final body = <String, dynamic>{'name': name};
74:     if (phone != null) body['phone'] = phone;
75:     if (email != null) body['email'] = email;
76:     if (password != null) body['password'] = password;
77: 
78:     final data = await _apiClient.post('/auth/register', body: body);
79:     return UserResponse.fromJson(data as Map<String, dynamic>);
80:   }
81: 
82:   // ─── Refresh access token ─────────────────────────────────────────
83:   Future<AuthTokenResponse> refreshToken(String refreshToken) async {
84:     final data = await _apiClient.post(
85:       '/auth/refresh',
86:       body: {'refreshToken': refreshToken},
87:     );
88:     return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
89:   }
90: 
91:   // ─── Update profile (name, email) ────────────────────────────────
92:   Future<UserResponse> updateMe({String? name, String? email}) async {
93:     final body = <String, dynamic>{};
94:     if (name != null) body['name'] = name;
95:     if (email != null) body['email'] = email;
96: 
97:     final data = await _apiClient.patch('/auth/me', body: body);
98:     return UserResponse.fromJson(data as Map<String, dynamic>);
99:   }
100: 
101:   // ─── Register device for push notifications ──────────────────────
102:   Future<void> registerDevice({
103:     required String fcmToken,
104:     required String platform,
105:   }) async {
106:     await _apiClient.patch(
107:       '/auth/me/device',
108:       body: {'fcmToken': fcmToken, 'platform': platform},
109:     );
110:   }
111: 
112:   // ─── Request phone number change ─────────────────────────────────
113:   Future<void> requestPhoneChange(String newPhone) async {
114:     await _apiClient.post('/auth/phone/change', body: {'newPhone': newPhone});
115:   }
116: }
117: 
118: final authServiceProvider = Provider<AuthService>((ref) {
119:   final apiClient = ref.watch(apiClientProvider);
120:   final tokenStorage = ref.watch(tokenStorageProvider);
121:   return AuthService(apiClient, tokenStorage);
122: });

(End of file - total 122 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart</path>
<type>file</type>
<content>
1: import 'dart:async';
2: import 'package:connectivity_plus/connectivity_plus.dart';
3: import 'package:flutter_riverpod/flutter_riverpod.dart';
4: import 'package:http/http.dart' as http;
5: 
6: class ConnectivityService {
7:   ConnectivityService() {
8:     _init();
9:   }
10: 
11:   final _controller = StreamController<bool>.broadcast();
12:   Stream<bool> get onConnectivityChanged => _controller.stream;
13: 
14:   bool _isConnected = false;
15:   bool get isConnected => _isConnected;
16: 
17:   void _init() {
18:     Connectivity().onConnectivityChanged.listen((results) async {
19:       if (results.contains(ConnectivityResult.none) && results.length == 1) {
20:         _emit(false);
21:       } else {
22:         // Always ping — being on WiFi does NOT mean internet works
23:         final reachable = await _ping();
24:         _emit(reachable);
25:       }
26:     });
27:   }
28: 
29:   /// Call this manually to get the current real state.
30:   Future<bool> checkNow() async {
31:     final results = await Connectivity().checkConnectivity();
32:     if (results.contains(ConnectivityResult.none) && results.length == 1) {
33:       _emit(false);
34:       return false;
35:     }
36:     final reachable = await _ping();
37:     _emit(reachable);
38:     return reachable;
39:   }
40: 
41:   /// Pings the actual API server to verify internet + backend reachability.
42:   /// Uses HTTP HEAD — works over WiFi, mobile data, any connection type.
43:   Future<bool> _ping() async {
44:     try {
45:       final response = await http
46:           .head(Uri.parse('http://192.168.1.4:3000/health'))
47:           .timeout(const Duration(seconds: 5));
48:       return response.statusCode < 500;
49:     } catch (_) {
50:       return false;
51:     }
52:   }
53: 
54:   void _emit(bool value) {
55:     _isConnected = value;
56:     _controller.add(value);
57:   }
58: 
59:   void dispose() => _controller.close();
60: }
61: 
62: /// Global Riverpod provider — use this everywhere
63: final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
64:   final service = ConnectivityService();
65:   ref.onDispose(service.dispose);
66:   return service;
67: });
68: 
69: /// Stream provider for easy watching in widgets
70: final connectivityStreamProvider = StreamProvider<bool>((ref) {
71:   return ref.watch(connectivityServiceProvider).onConnectivityChanged;
72: });

(End of file - total 72 lines)
</content>

[Project README: /Users/pratham/code/gz_app/README.md]
# gz_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```

**Tool: grep**

**Input:**
```json
{
  "include": "*.dart",
  "output_mode": "content",
  "path": "/Users/pratham/code/gz_app/lib",
  "pattern": "'/(auth|users|api|health|posts|profile)"
}
```

**Output:**
```
Found 27 match(es) in 6 file(s)

/Users/pratham/code/gz_app/lib/core/navigation/routes.dart
  7: static const authLanding = '/auth';
  8: static const register = '/auth/register';
  9: static const otpVerification = '/auth/otp';
  10: static const emailLogin = '/auth/email-login';
  11: static const oauthHandler = '/auth/oauth-handler';
  12: static const forgotPassword = '/auth/forgot-password';
  13: static const resetPassword = '/auth/reset-password';
  14: static const emailVerificationPending = '/auth/email-verification-pending';
  29: static const profile = '/profile';

/Users/pratham/code/gz_app/lib/features/main_shell/presentation/widgets/main_mobile_layout.dart
  17: if (location.startsWith('/profile')) return 4;
  36: context.go('/profile');

/Users/pratham/code/gz_app/lib/features/main_shell/presentation/widgets/main_tablet_layout.dart
  18: if (location.startsWith('/profile')) return 4;
  37: context.go('/profile');

/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart
  18: '/auth/login/email',
  26: await _apiClient.post('/auth/login/otp', body: {'phone': phone});
  32: '/auth/verify/otp',
  40: final data = await _apiClient.get('/auth/me');
  47: '/auth/password/reset/request',
  55: '/auth/password/reset/confirm',
  62: await _apiClient.post('/auth/logout');
  78: final data = await _apiClient.post('/auth/register', body: body);
  85: '/auth/refresh',
  97: final data = await _apiClient.patch('/auth/me', body: body);
  107: '/auth/me/device',
  114: await _apiClient.post('/auth/phone/change', body: {'newPhone': newPhone});

/Users/pratham/code/gz_app/lib/features/profile/presentation/widgets/profile_tablet_layout.dart
  32: context.go('/auth_landing');

/Users/pratham/code/gz_app/lib/features/profile/presentation/widgets/profile_mobile_layout.dart
  37: '/auth_landing',

[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 10.4s)

Now I have the full picture. There's no existing API constants file. I need to:

1. Create an `api_constants.dart` file with all base URLs and endpoints
2. Update `api_client.dart` to use those constants
3. (Also spotted hardcoded URLs in `connectivity_service.dart` and `auth_service.dart` — I'll fix those too)

The hardcoded strings I found across the codebase:

| Location | Hardcoded String |
|---|---|
| `api_client.dart:200` | `'https://gz.api.splin.app'` (baseUrl) |
| `api_client.dart:199` | `'http://192.168.1.4:3000'` (commented) |
| `api_client.dart:210` | `'http://192.168.1.4:3000/auth/refresh'` |
| `connectivity_service.dart:46` | `'http://192.168.1.4:3000/health'` |
| `auth_service.dart` | 11 endpoint strings like `/auth/login/email`, `/auth/refresh`, etc. |

Let me create the constants file and update all files.

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "status": "in_progress",
      "priority": "high"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "status": "pending",
      "priority": "high"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "status": "pending",
      "priority": "medium"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "status": "pending",
      "priority": "medium"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "status": "pending",
      "priority": "medium"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "status": "pending",
    "priority": "medium"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "status": "pending",
    "priority": "medium"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "status": "pending",
    "priority": "medium"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 11.4s)

**Tool: write**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_constants.dart",
  "content": "/// Centralized API constants — all URLs, base URLs, and endpoint paths\n/// must be referenced from here. No hardcoded strings elsewhere.\nclass ApiConstants {\n  ApiConstants._();\n\n  // ─── Base URLs ─────────────────────────────────────────────────────\n  static const String prodBaseUrl = 'https://gz.api.splin.app';\n  static const String devBaseUrl = 'http://192.168.1.4:3000';\n\n  /// Active base URL — switch between prod/dev here (or wire to env config).\n  static const String baseUrl = prodBaseUrl;\n\n  // ─── Health Check ──────────────────────────────────────────────────\n  static const String healthEndpoint = '/health';\n  static const String healthUrl = '$devBaseUrl$healthEndpoint';\n\n  // ─── Auth Endpoints ────────────────────────────────────────────────\n  static const String authLoginEmail = '/auth/login/email';\n  static const String authLoginOtp = '/auth/login/otp';\n  static const String authVerifyOtp = '/auth/verify/otp';\n  static const String authMe = '/auth/me';\n  static const String authPasswordResetRequest = '/auth/password/reset/request';\n  static const String authPasswordResetConfirm = '/auth/password/reset/confirm';\n  static const String authLogout = '/auth/logout';\n  static const String authRegister = '/auth/register';\n  static const String authRefresh = '/auth/refresh';\n  static const String authMeDevice = '/auth/me/device';\n  static const String authPhoneChange = '/auth/phone/change';\n}\n"
}
```

**Output:**
```
Wrote file successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.1s)

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "priority": "high",
      "status": "in_progress"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "pending"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "pending"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "priority": "medium",
      "status": "pending"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "priority": "high",
    "status": "in_progress"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "pending"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "pending"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "priority": "medium",
    "status": "pending"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 6.4s)

Now update `api_client.dart` — add the import and replace hardcoded strings:

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_client.dart",
  "oldString": "import 'dart:convert';\nimport 'package:flutter/foundation.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:http/http.dart' as http;\nimport '../errors/app_exception.dart';\nimport '../auth/token_storage.dart';",
  "newString": "import 'dart:convert';\nimport 'package:flutter/foundation.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:http/http.dart' as http;\nimport 'api_constants.dart';\nimport '../errors/app_exception.dart';\nimport '../auth/token_storage.dart';"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.0s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_client.dart",
  "newString": "  return ApiClient(\n    baseUrl: ApiConstants.baseUrl,",
  "oldString": "  return ApiClient(\n    // baseUrl: 'http://192.168.1.4:3000',\n    baseUrl: 'https://gz.api.splin.app',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 9.9s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_client.dart",
  "newString": "        // Direct HTTP call — bypass ApiClient to avoid re-triggering 401 loop\n        final uri = Uri.parse('${ApiConstants.devBaseUrl}${ApiConstants.authRefresh}');",
  "oldString": "        // Direct HTTP call — bypass ApiClient to avoid re-triggering 401 loop\n        final uri = Uri.parse('http://192.168.1.4:3000/auth/refresh');"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 6.1s)

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "in_progress"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "pending"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "priority": "medium",
      "status": "pending"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "in_progress"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "pending"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "priority": "medium",
    "status": "pending"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.7s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart",
  "newString": "import 'dart:async';\nimport 'package:connectivity_plus/connectivity_plus.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:http/http.dart' as http;\nimport '../api/api_constants.dart';",
  "oldString": "import 'dart:async';\nimport 'package:connectivity_plus/connectivity_plus.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:http/http.dart' as http;"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.4s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart",
  "newString": "      final response = await http\n          .head(Uri.parse(ApiConstants.healthUrl))",
  "oldString": "      final response = await http\n          .head(Uri.parse('http://192.168.1.4:3000/health'))"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 6.5s)

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "completed"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "in_progress"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "priority": "medium",
      "status": "pending"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "completed"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "in_progress"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "priority": "medium",
    "status": "pending"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 8.2s)

Now update `auth_service.dart` — add import and replace all endpoint strings:

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../../../core/api/api_client.dart';\nimport '../../../../core/api/api_constants.dart';\nimport '../../../../core/auth/token_storage.dart';\nimport '../../../../models/api_responses.dart';",
  "oldString": "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../../../core/api/api_client.dart';\nimport '../../../../core/auth/token_storage.dart';\nimport '../../../../models/api_responses.dart';"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.1s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.post(\n      ApiConstants.authLoginEmail,",
  "oldString": "    final data = await _apiClient.post(\n      '/auth/login/email',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.7s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.post(ApiConstants.authLoginOtp, body: {'phone': phone});",
  "oldString": "    await _apiClient.post('/auth/login/otp', body: {'phone': phone});"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 8.9s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.post(\n      ApiConstants.authVerifyOtp,",
  "oldString": "    final data = await _apiClient.post(\n      '/auth/verify/otp',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 12.9s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.get(ApiConstants.authMe);",
  "oldString": "    final data = await _apiClient.get('/auth/me');"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.7s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.post(\n      ApiConstants.authPasswordResetRequest,",
  "oldString": "    await _apiClient.post(\n      '/auth/password/reset/request',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.8s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.post(\n      ApiConstants.authPasswordResetConfirm,",
  "oldString": "    await _apiClient.post(\n      '/auth/password/reset/confirm',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.3s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.post(ApiConstants.authLogout);",
  "oldString": "    await _apiClient.post('/auth/logout');"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 10.1s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.post(ApiConstants.authRegister, body: body);",
  "oldString": "    final data = await _apiClient.post('/auth/register', body: body);"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.7s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.post(\n      ApiConstants.authRefresh,",
  "oldString": "    final data = await _apiClient.post(\n      '/auth/refresh',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 11.5s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    final data = await _apiClient.patch(ApiConstants.authMe, body: body);",
  "oldString": "    final data = await _apiClient.patch('/auth/me', body: body);"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.9s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.patch(\n      ApiConstants.authMeDevice,",
  "oldString": "    await _apiClient.patch(\n      '/auth/me/device',"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.7s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "newString": "    await _apiClient.post(ApiConstants.authPhoneChange, body: {'newPhone': newPhone});",
  "oldString": "    await _apiClient.post('/auth/phone/change', body: {'newPhone': newPhone});"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 6.1s)

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "completed"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "completed"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "priority": "medium",
      "status": "in_progress"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "completed"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "completed"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "priority": "medium",
    "status": "in_progress"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 9.1s)

**Tool: lsp_diagnostics**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_constants.dart",
  "severity": "error"
}
```

**Output:**
```
No diagnostics found
```

**Tool: lsp_diagnostics**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/api/api_client.dart",
  "severity": "error"
}
```

**Output:**
```
No diagnostics found
```

**Tool: lsp_diagnostics**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/core/network/connectivity_service.dart",
  "severity": "error"
}
```

**Output:**
```
No diagnostics found
```

**Tool: lsp_diagnostics**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_app/lib/features/auth/data/services/auth_service.dart",
  "severity": "error"
}
```

**Output:**
```
No diagnostics found
```

**Tool: grep**

**Input:**
```json
{
  "include": "*.dart",
  "output_mode": "content",
  "path": "/Users/pratham/code/gz_app/lib",
  "pattern": "http://192\\.168|https://gz\\.api"
}
```

**Output:**
```
Found 2 match(es) in 1 file(s)

/Users/pratham/code/gz_app/lib/core/api/api_constants.dart
  7: static const String prodBaseUrl = 'https://gz.api.splin.app';
  8: static const String devBaseUrl = 'http://192.168.1.4:3000';

[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.5s)

All clean. Zero diagnostics errors across all 4 files. The only remaining URLs are in `api_constants.dart` itself — exactly where they belong.

**Tool: todowrite**

**Input:**
```json
{
  "todos": [
    {
      "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update api_client.dart to use ApiConstants",
      "priority": "high",
      "status": "completed"
    },
    {
      "content": "Update connectivity_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "completed"
    },
    {
      "content": "Update auth_service.dart to use ApiConstants",
      "priority": "medium",
      "status": "completed"
    },
    {
      "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
      "priority": "medium",
      "status": "completed"
    }
  ]
}
```

**Output:**
```
[
  {
    "content": "Create lib/core/api/api_constants.dart with base URLs and all endpoint constants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update api_client.dart to use ApiConstants",
    "priority": "high",
    "status": "completed"
  },
  {
    "content": "Update connectivity_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "completed"
  },
  {
    "content": "Update auth_service.dart to use ApiConstants",
    "priority": "medium",
    "status": "completed"
  },
  {
    "content": "Verify no hardcoded URLs remain with lsp_diagnostics",
    "priority": "medium",
    "status": "completed"
  }
]
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.6s)

Done. Here's what changed:

**Created:** `lib/core/api/api_constants.dart` — single source of truth for all URLs:
- `prodBaseUrl`, `devBaseUrl`, `baseUrl` (active)
- Health check: `healthEndpoint`, `healthUrl`
- Auth endpoints: `authLoginEmail`, `authLoginOtp`, `authVerifyOtp`, `authMe`, `authPasswordResetRequest`, `authPasswordResetConfirm`, `authLogout`, `authRegister`, `authRefresh`, `authMeDevice`, `authPhoneChange`

**Updated 3 files** to reference `ApiConstants.*` instead of hardcoded strings:
- `api_client.dart` — `baseUrl` + refresh URL
- `connectivity_service.dart` — health ping URL
- `auth_service.dart` — all 11 endpoint strings

Zero errors, zero hardcoded URLs outside `api_constants.dart`.

---

## User

[search-mode]
MAXIMIZE SEARCH EFFORT. Launch multiple background agents IN PARALLEL:
- explore agents (codebase patterns, file structures, ast-grep)
- librarian agents (remote repos, official docs, GitHub examples)
  Plus direct tools: Grep, ripgrep (rg), ast-grep (sg)
  NEVER stop at first result - be exhaustive.

[analyze-mode]
ANALYSIS MODE. Gather context before diving deep:
CONTEXT GATHERING (parallel):
- 1-2 explore agents (codebase patterns, implementations)
- 1-2 librarian agents (if external library involved)
- Direct tools: Grep, AST-grep, LSP for targeted searches

IF COMPLEX - DO NOT STRUGGLE ALONE. Consult specialists:
- **Oracle**: Conventional problems (architecture, debugging, complex logic)
- **Artistry**: Non-conventional problems (different approach needed)

SYNTHESIZE findings before proceeding.
---
MANDATORY delegate_task params: ALWAYS include load_skills=[] and run_in_background when calling delegate_task.
Example: delegate_task(subagent_type="explore", prompt="...", run_in_background=true, load_skills=[])

---

<auto-slash-command>
# /bmad-help Command

**Description**: (opencode-project - Skill) Analyzes current state and user query to answer BMad questions or recommend the next skill(s) to use. Use when user asks for help, bmad help, what to do next, or what to start with in BMad.

**User Arguments**: /caveman tell me if the @docs/general-layout.md file for all the screens that we just implemented. does that file tell that the app is only meant for customers?? does it have the analytics and the login UI for the store admions and employess?

**Scope**: skill

---

## Command Instructions

<skill-instruction>
Base directory for this skill: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/
File references ([file not found: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/path)] in this skill are relative to this directory.

# BMad Help

## Purpose

Help the user understand where they are in their BMad workflow and what to do next, and also answer broader questions when asked that could be augmented with remote sources such as module documentation sources.

## Desired Outcomes

When this skill completes, the user should:

1. **Know where they are** — which module and phase they're in, what's already been completed
2. **Know what to do next** — the next recommended and/or required step, with clear reasoning
3. **Know how to invoke it** — skill name, menu code, action context, and any args that shortcut the conversation
4. **Get offered a quick start** — when a single skill is the clear next step, offer to run it for the user right now rather than just listing it
5. **Feel oriented, not overwhelmed** — surface only what's relevant to their current position; don't dump the entire catalog
6. **Get answers to general questions** — when the question doesn't map to a specific skill, use the module's registered documentation to give a grounded answer

## Data Sources

- **Catalog**: `{project-root}/_bmad/_config/bmad-help.csv` — assembled manifest of all installed module skills
- **Config**: `config.yaml` and `user-config.yaml` files in `{project-root}/_bmad/` and its subfolders — resolve `output-location` variables, provide `communication_language` and `project_knowledge`
- **Artifacts**: Files matching `outputs` patterns at resolved `output-location` paths reveal which steps are possibly completed; their content may also provide grounding context for recommendations
- **Project knowledge**: If `project_knowledge` resolves to an existing path, read it for grounding context. Never fabricate project-specific details.
- **Module docs**: Rows with `_meta` in the `skill` column carry a URL or path in `output-location` pointing to the module's documentation (e.g., llms.txt). Fetch and use these to answer general questions about that module.

## CSV Interpretation

The catalog uses this format:

```
module,skill,display-name,menu-code,description,action,args,phase,after,before,required,output-location,outputs
```

**Phases** determine the high-level flow:
- `anytime` — available regardless of workflow state
- Numbered phases (`1-analysis`, `2-planning`, etc.) flow in order; naming varies by module

**Dependencies** determine ordering within and across phases:
- `after` — skills that should ideally complete before this one
- `before` — skills that should run after this one
- Format: `skill-name` for single-action skills, `skill-name:action` for multi-action skills

**Required gates**:
- `required=true` items must complete before the user can meaningfully proceed to later phases
- A phase with no required items is entirely optional — recommend it but be clear about what's actually required next

**Completion detection**:
- Search resolved output paths for `outputs` patterns
- Fuzzy-match found files to catalog rows
- User may also state completion explicitly, or it may be evident from the current conversation

**Descriptions carry routing context** — some contain cycle info and alternate paths (e.g., "back to DS if fixes needed"). Read them as navigation hints, not just display text.

## Response Format

For each recommended item, present:
- `[menu-code]` **Display name** — e.g., "[CP] Create PRD"
- Skill name in backticks — e.g., `bmad-create-prd`
- For multi-action skills: action invocation context — e.g., "tech-writer lets create a mermaid diagram!"
- Description if present in CSV; otherwise your existing knowledge of the skill suffices
- Args if available

**Ordering**: Show optional items first, then the next required item. Make it clear which is which.

## Constraints

- Present all output in `{communication_language}`
- Recommend running each skill in a **fresh context window**
- Match the user's tone — conversational when they're casual, structured when they want specifics
- If the active module is ambiguous, retrieve all meta rows remote sources to find relevant info also to help answer their question
  </skill-instruction>

<user-request>
/caveman tell me if the @docs/general-layout.md file for all the screens that we just implemented. does that file tell that the app is only meant for customers?? does it have the analytics and the login UI for the store admions and employess?
</user-request>


---

## User Request

/caveman tell me if the @docs/general-layout.md file for all the screens that we just implemented. does that file tell that the app is only meant for customers?? does it have the analytics and the login UI for the store admions and employess?
</auto-slash-command>

<skill-instruction>
Base directory for this skill: /Users/pratham/code/gz_app/.opencode/skills/bmad-help/
File references (@path) in this skill are relative to this directory.

# BMad Help

## Purpose

Help the user understand where they are in their BMad workflow and what to do next, and also answer broader questions when asked that could be augmented with remote sources such as module documentation sources.

## Desired Outcomes

When this skill completes, the user should:

1. **Know where they are** — which module and phase they're in, what's already been completed
2. **Know what to do next** — the next recommended and/or required step, with clear reasoning
3. **Know how to invoke it** — skill name, menu code, action context, and any args that shortcut the conversation
4. **Get offered a quick start** — when a single skill is the clear next step, offer to run it for the user right now rather than just listing it
5. **Feel oriented, not overwhelmed** — surface only what's relevant to their current position; don't dump the entire catalog
6. **Get answers to general questions** — when the question doesn't map to a specific skill, use the module's registered documentation to give a grounded answer

## Data Sources

- **Catalog**: `{project-root}/_bmad/_config/bmad-help.csv` — assembled manifest of all installed module skills
- **Config**: `config.yaml` and `user-config.yaml` files in `{project-root}/_bmad/` and its subfolders — resolve `output-location` variables, provide `communication_language` and `project_knowledge`
- **Artifacts**: Files matching `outputs` patterns at resolved `output-location` paths reveal which steps are possibly completed; their content may also provide grounding context for recommendations
- **Project knowledge**: If `project_knowledge` resolves to an existing path, read it for grounding context. Never fabricate project-specific details.
- **Module docs**: Rows with `_meta` in the `skill` column carry a URL or path in `output-location` pointing to the module's documentation (e.g., llms.txt). Fetch and use these to answer general questions about that module.

## CSV Interpretation

The catalog uses this format:

```
module,skill,display-name,menu-code,description,action,args,phase,after,before,required,output-location,outputs
```

**Phases** determine the high-level flow:
- `anytime` — available regardless of workflow state
- Numbered phases (`1-analysis`, `2-planning`, etc.) flow in order; naming varies by module

**Dependencies** determine ordering within and across phases:
- `after` — skills that should ideally complete before this one
- `before` — skills that should run after this one
- Format: `skill-name` for single-action skills, `skill-name:action` for multi-action skills

**Required gates**:
- `required=true` items must complete before the user can meaningfully proceed to later phases
- A phase with no required items is entirely optional — recommend it but be clear about what's actually required next

**Completion detection**:
- Search resolved output paths for `outputs` patterns
- Fuzzy-match found files to catalog rows
- User may also state completion explicitly, or it may be evident from the current conversation

**Descriptions carry routing context** — some contain cycle info and alternate paths (e.g., "back to DS if fixes needed"). Read them as navigation hints, not just display text.

## Response Format

For each recommended item, present:
- `[menu-code]` **Display name** — e.g., "[CP] Create PRD"
- Skill name in backticks — e.g., `bmad-create-prd`
- For multi-action skills: action invocation context — e.g., "tech-writer lets create a mermaid diagram!"
- Description if present in CSV; otherwise your existing knowledge of the skill suffices
- Args if available

**Ordering**: Show optional items first, then the next required item. Make it clear which is which.

## Constraints

- Present all output in `{communication_language}`
- Recommend running each skill in a **fresh context window**
- Match the user's tone — conversational when they're casual, structured when they want specifics
- If the active module is ambiguous, retrieve all meta rows remote sources to find relevant info also to help answer their question
  </skill-instruction>

<user-request>
/caveman tell me if the @docs/general-layout.md file for all the screens that we just implemented. does that file tell that the app is only meant for customers?? does it have the analytics and the login UI for the store admions and employess?
</user-request>

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 20.3s)

I detect **research/analysis** intent — user wants to understand the scope of the general-layout doc. Direct answer from the file I already read.

**Yes, the doc is 100% customer-only (Players).** Here's the evidence:

### It's explicitly stated
- **Title** (line 1): *"Gaming Zone — Player Mobile App: Complete UX Design"*
- **Line 10**: *"The mobile app serves **Players only** — the people who walk into or pre-book gaming sessions at physical gaming venues."*
- It also says: *"It is one of three API consumers (the others are the **Admin Dashboard** and the **System Agent desktop app**)."*

### No admin/employee features exist
- **40 screens** — all player-facing (Home, Book, My Games, Wallet, Profile)
- **Auth stack** (Screens 01–10) — only player registration/login (OTP, email, OAuth, password reset)
- **No analytics dashboard** for store admins
- **No store admin login** — no role-based auth, no admin portal
- **No employee management** screens
- Session extension is explicitly *"admin-only"* — the app just tells the player to *"walk up to admin"* (line 553)

### What's missing for store admins/employees
| Feature | In this doc? |
|---|---|
| Admin login UI | ❌ No |
| Employee login UI | ❌ No |
| Store analytics dashboard | ❌ No |
| Revenue/session reports | ❌ No |
| Booking management (admin side) | ❌ No |
| System management | ❌ No |
| Campaign creation | ❌ No |
| Dispute resolution | ❌ No |

The doc explicitly notes that the **Admin Dashboard** and **System Agent** are **separate API consumers** — they'd need their own design docs.

---

## User

[search-mode]
MAXIMIZE SEARCH EFFORT. Launch multiple background agents IN PARALLEL:
- explore agents (codebase patterns, file structures, ast-grep)
- librarian agents (remote repos, official docs, GitHub examples)
  Plus direct tools: Grep, ripgrep (rg), ast-grep (sg)
  NEVER stop at first result - be exhaustive.

[analyze-mode]
ANALYSIS MODE. Gather context before diving deep:
CONTEXT GATHERING (parallel):
- 1-2 explore agents (codebase patterns, implementations)
- 1-2 librarian agents (if external library involved)
- Direct tools: Grep, AST-grep, LSP for targeted searches

IF COMPLEX - DO NOT STRUGGLE ALONE. Consult specialists:
- **Oracle**: Conventional problems (architecture, debugging, complex logic)
- **Artistry**: Non-conventional problems (different approach needed)

SYNTHESIZE findings before proceeding.
---
MANDATORY delegate_task params: ALWAYS include load_skills=[] and run_in_background when calling delegate_task.
Example: delegate_task(subagent_type="explore", prompt="...", run_in_background=true, load_skills=[])

---

i want you to make a pormtp for the backedn which would give you the detailes just like teh general file so that you can creaet the admin part. I want to striclly call everuything from the api forst. pure informative first. mainintaining the @docs/main-rules.md aarchitecture. give me a one time proempt explaoning this so that i can paste it in thge backend opencode. the backend is in /Users/pratham/code/gz_ideation/ n

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 19.7s)

I detect **writing** intent — user wants me to craft a prompt to paste into their backend OpenCode. Let me quickly check the backend structure to make the prompt accurate.

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation</path>
<type>directory</type>
<entries>
.agents/
.DS_Store
.env
.env.example
.git/
.github/
.gitignore
.local/
.sisyphus/
AGENTS.md
bun.lock
CLAUDE.md
credentials.txt
db.md
db/
dist/
docs/
drizzle.config.ts
echo
node_modules/
package.json
readme.md
schema.md
scripts/
skills-lock.json
skills/
src/
test_api.sh
test_results/
tests.html
tsconfig.json

(31 entries)
</entries>
```

**Tool: glob**

**Input:**
```json
{
  "path": "/Users/pratham/code/gz_ideation",
  "pattern": "**/routes/**"
}
```

**Output:**
```
No files found
[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 7.1s)

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/src"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/src</path>
<type>directory</type>
<entries>
.DS_Store
config/
db/
index.ts
jobs/
lib/
middleware/
modules/
types/
ws/

(10 entries)
</entries>

[Project README: /Users/pratham/code/gz_ideation/README.md]
# 📘 README — Gaming Zone SaaS Platform Architecture

## 🧩 Product Overview

This system is a **multi-tenant SaaS platform** designed to manage physical gaming zones (PC cafés / console arenas).

It enables:

* Slot booking from mobile app
* Walk-in session management
* Real-time control of gaming PCs
* Hybrid session timing (local + cloud)
* Dynamic pricing and loyalty credits
* Revenue analytics dashboard
* Promotions and personalized notifications

The platform acts as a **real-time resource scheduling and billing operating system** for gaming stores.

---

## 🎯 Core Goals

* Ensure **accurate billing based on real usage**
* Prevent **session conflicts and PC misuse**
* Provide **store owners revenue visibility**
* Enable **user retention through credits & tiers**
* Support **many stores (multi-tenant SaaS)**

---

## 👥 Actors

### Player (Mobile App)

Can:

* create account
* view available slots
* reserve or pre-pay booking
* check play history
* earn & redeem credits
* receive targeted offers
* view tier status

Cannot:

* control PCs
* change pricing
* override sessions

---

### Store Admin (Dashboard)

Can:

* view live PC status
* start / stop sessions
* assign walk-ins
* extend sessions
* override pricing
* view revenue analytics
* create campaigns
* manage pricing rules

Cannot:

* modify SaaS system settings
* access other stores’ data

---

### PC Agent (Installed on Gaming PC)

Responsible for:

* locking / unlocking system
* local session countdown
* offline continuation
* sending usage logs
* receiving commands from server

---

## 🏗️ High Level System Architecture

```
Mobile App
Admin Dashboard
PC Agent Software
↓
API Gateway
↓
-------------------------------------
Booking Service
Session Controller Service
Billing Service
Loyalty Service
Pricing Engine
Notification Service
Realtime Gateway
Tenant Service
-------------------------------------
        ↓
     Main Database
     Redis Cache
```

---

## ⏱️ Hybrid Session Timing Model

### Local Authority (PC Agent)

* controls timer in real time
* locks PC when session ends
* continues if internet fails
* stores offline logs

### Cloud Authority (Server)

* creates official session records
* calculates billing
* applies pricing rules
* updates loyalty credits
* resolves conflicts

This ensures:

✅ fault tolerance
✅ financial accuracy
✅ operational reliability

---

## 📅 Booking Priority Model (v2)

1. **Paid booking (P1, guaranteed)** — Booked and paid within the payment window
2. **Walk-in (P2, highest default)** — Physical presence at the store
3. **Reserved unpaid (P3, soft hold)** — Online reservation without payment

Walk-ins outrank unpaid reservations. Only paid bookings guarantee a slot.

**Booking Windows** (configurable per store):
* Clients can only book within `booking_window_minutes` (default: 60 min) before the slot
* Clients can only pay within `payment_window_minutes` (default: 15 min) before the slot starts
* Unpaid bookings auto-expire after the payment deadline

System must handle:

* no-show grace period (auto-cancel via cron)
* early arrival buffer
* overstay conflicts
* extension feasibility (check for upcoming paid bookings)

---

## 💰 Billing Principles

* Billing is based on **actual usage**
* Pricing is **snapshotted at billing time**
* Sessions can generate **multiple charge segments**
* Admin overrides are stored with reason

Revenue dashboards sum from **billing ledger**, not payment table.

---

## 🎮 Loyalty & Credits

* Each user has global identity
* Credits are **store-specific**
* Tier is computed from **total minutes played**
* Promotions may target specific tiers
* Credits recorded via **ledger transactions**

---

## 📊 Analytics Capabilities

Stores can view:

* revenue by day / hour
* utilization heatmaps
* player retention stats
* peak pricing performance
* PC usage distribution

Future potential:

* AI pricing recommendations
* expansion forecasting

---

## 🌐 Multi-Tenant Model

* Single central backend
* All data partitioned by `store_id`
* No cross-store data visibility
* Pricing & loyalty configurable per store

---

## 📶 Offline Handling

If store internet fails:

* sessions continue locally
* PCs auto-lock on time completion
* logs sync when connection restores

---

## 🚫 Out of Scope (Current Version)

* Game launcher / piracy control
* Anti-cheat kernel drivers
* Hardware performance monitoring
* Inter-store credit sharing
* Advanced accounting exports (GST etc)
* Franchise billing system
* Automated PC imaging / OS deployment

---

## 🚀 Future Expansion Possibilities

* Subscription memberships
* Online wallet system
* Tournament scheduling
* Multi-store leaderboards
* Dynamic surge pricing
* Store marketplace discovery
```

**Tool: glob**

**Input:**
```json
{
  "path": "/Users/pratham/code/gz_ideation",
  "pattern": "**/route*"
}
```

**Output:**
```
No files found
[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/docs"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/docs</path>
<type>directory</type>
<entries>
api-best-practices.md
api-overview.md
general-idea.md
mobile-api-guide.md
mobile-ux-design.md

(5 entries)
</entries>
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 6.2s)

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/src/modules"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/src/modules</path>
<type>directory</type>
<entries>
.DS_Store
analytics/
auth/
billing/
bookings/
campaigns/
credits/
disputes/
notifications/
payments/
pricing/
sessions/
store-admins/
stores/
system-types/
systems/
users/

(17 entries)
</entries>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/docs/api-overview.md"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/docs/api-overview.md</path>
<type>file</type>
<content>
1: # Gaming Zone SaaS API — Complete Project Overview
2: **Version**: 2.0.0 | **Last Updated**: 2026-04-02 | **Stack**: Bun + ElysiaJS + PostgreSQL + Drizzle ORM
3: 
4: > **Purpose**: This document is the authoritative project context. Feed it to any AI agent before generating code. It answers: what this system does, who uses it, what exists, and what every endpoint does.
5: 
6: ---
7: 
8: ## 1. What Is This API
9: 
10: A **multi-tenant SaaS backend** for managing physical gaming venues — PC cafes, console arenas, and similar spaces. It serves three distinct clients:
11: 
12: | Client | Type | Purpose |
13: |--------|------|---------|
14: | **Player Mobile App** | iOS / Android | Browse stores, book slots, manage credits, view history, receive notifications |
15: | **Admin Dashboard** | Web SPA | Live monitoring, session management, analytics, pricing, campaigns |
16: | **System Agent** | Desktop (per PC/console) | Heartbeat reporting, lock/unlock commands, offline sync |
17: 
18: **Core purpose**: Real-time resource scheduling, usage-based billing, and store operations management.
19: 
20: ---
21: 
22: ## 2. Complete Tech Stack
23: 
24: | Layer | Technology | Notes |
25: |-------|-----------|-------|
26: | Runtime | **Bun** (latest) | Native TypeScript, fast cold start |
27: | Framework | **ElysiaJS ^1.x** | HTTP + WebSocket server |
28: | ORM | **Drizzle ORM** | Type-safe query builder |
29: | DB Driver | **postgres.js** | PostgreSQL connection pool |
30: | Database | **PostgreSQL 14+** | Primary data store |
31: | Cache/Pub-Sub | **Redis (ioredis)** | Sessions, rate limiting, caching, locks |
32: | API Docs | **@elysiajs/swagger** | Auto OpenAPI 3.0 |
33: | Validation | **Elysia.t (TypeBox)** | Runtime validation + TS inference |
34: | Auth | **@elysiajs/jwt** | JWT access/refresh tokens (jose under the hood) |
35: | Push Notifications | **firebase-admin** | FCM v1 — iOS, Android, Web push |
36: | Email | **nodemailer** | Transactional email via SMTP |
37: | Real-time | **Elysia WebSocket** | uWebSocket (built into Bun) |
38: | Testing | **bun:test** | Built-in test runner |
39: | Logging | **pino** | Structured JSON logging |
40: 
41: ---
42: 
43: ## 3. Infrastructure Map
44: 
45: ### 3.1 PostgreSQL
46: 
47: - **Connection**: Drizzle ORM via `postgres.js` with pool (`max: 10`)
48: - **Tenant Isolation**: Every tenant-scoped query filters by `store_id` in application layer
49: - **Schema**: 25+ tables, 19 enum types, database functions for scheduled tasks
50: - **Migrations**: `src/db/migrations/` — managed by `drizzle-kit`
51: - **Soft Deletes**: Use `is_active = false` — never hard delete operational data
52: 
53: ### 3.2 Redis
54: 
55: Five distinct roles:
56: 
57: | Role | Key Pattern | TTL | Description |
58: |------|------------|-----|-------------|
59: | Session Tokens | `session:{tokenHash}` | 7d | JWT refresh token storage |
60: | OTP Codes | `otp:{phone\|email}` | 10m | Verification codes |
61: | Rate Limiting | `ratelimit:{action}:{identifier}` | Sliding | OTP attempts, API throttling |
62: | Caching | `cache:{entity}:{id}:{subkey}` | 30s–5m | Store config, pricing, system status |
63: | Pub/Sub | `channel:store:{storeId}:live` | — | Real-time event fanout to WS clients |
64: | Booking Mutex | `lock:booking:{systemId}:{slot}` | 30s | Distributed lock — prevent double booking |
65: 
66: ### 3.3 WebSocket Channels
67: 
68: | Channel | WS Path | Auth | Subscribers | Direction |
69: |---------|---------|------|-------------|-----------|
70: | Store Live Feed | `/ws/stores/:storeId/live?token=` | Admin JWT | Admin Dashboard | Server → Client |
71: | System Agent Link | `/ws/stores/:storeId/agent/:systemId?key=` | API Key | Desktop Agent | Bidirectional |
72: | Player Notifications | `/ws/users/:userId/notify?token=` | User JWT | Mobile App | Server → Client |
73: 
74: **Auth note**: WebSocket connections authenticate via query param `?token=` — NOT headers. Browser WebSocket API cannot set custom headers.
75: 
76: ### 3.4 Push Notifications (FCM)
77: 
78: - Firebase Admin SDK (`firebase-admin`) — FCM HTTP v1 API
79: - Service account credentials stored as JSON string in `FCM_SERVICE_ACCOUNT_JSON` env var
80: - Device tokens stored in `user_devices` table (`userId`, `fcmToken`, `platform`, `isActive`)
81: - Stale/invalid tokens automatically marked `isActive = false` on send failure
82: - Multi-device support: each user can have multiple device tokens (mobile + web)
83: 
84: ### 3.5 Email (Nodemailer)
85: 
86: - SMTP-based transactional email — compatible with Resend, SendGrid, Postmark, etc.
87: - All templates defined in `src/lib/mailer.ts` as functions returning HTML strings
88: - Fire-and-forget for non-critical notifications (don't await in hot path)
89: - Block-and-await for critical flows (OTP, password reset)
90: 
91: ### 3.6 Cron Jobs
92: 
93: | Job | Schedule | Mechanism | Purpose |
94: |-----|----------|-----------|---------|
95: | Expire Unpaid Bookings | Every 1 min | DB function | Cancel bookings past payment window |
96: | Mark No-Shows | Every 5 min | DB function | Mark unattended bookings as `no_show` |
97: | Refresh Credit Balances | On ledger change | DB trigger | Refresh `credit_balances` materialized view |
98: | Cleanup Expired Tokens | Every 60 min | DB function | Remove expired verification tokens |
99: | Hourly Summary | Every hour | App job | Compute `store_hourly_summary` |
100: | Daily Summary | Daily at midnight | App job | Compute `store_daily_summary` |
101: 
102: ---
103: 
104: ## 4. Actors and Access Patterns
105: 
106: ### 4.1 Player (Mobile App)
107: 
108: **Authentication**: Phone OTP, Email+Password, Google OAuth, Apple OAuth
109: 
110: | Can | Cannot |
111: |-----|--------|
112: | Register / login | Control systems (PCs/consoles) |
113: | Browse stores and available slots | Change pricing rules |
114: | Book and pay for slots | Override sessions or billing |
115: | Check-in for bookings | Manage store admins |
116: | View own play history | See other users' data |
117: | Earn and redeem credits | Access admin endpoints |
118: | Manage notification preferences | |
119: | Receive push/in-app/email/SMS notifications | |
120: 
121: ### 4.2 Store Admin (Dashboard)
122: 
123: **Authentication**: Email+Password only
124: 
125: **Role Permission Matrix**:
126: | Permission | super_admin | admin | staff |
127: |------------|:-----------:|:-----:|:-----:|
128: | Session management (start/stop/extend) | ✅ | ✅ | Start/Stop only |
129: | Pricing rule management | ✅ | ✅ | ❌ |
130: | View analytics | ✅ | ✅ | View only |
131: | Apply billing overrides | ✅ | ✅ | ❌ |
132: | Process payments | ✅ | ❌ | ❌ |
133: | Manage other admins | ✅ | ❌ | ❌ |
134: | Campaign management | ✅ | ✅ | ❌ |
135: | Send store-wide notifications | ✅ | ✅ | ❌ |
136: 
137: ### 4.3 System Agent (Desktop)
138: 
139: **Authentication**: API key per system (not JWT — machine client)
140: 
141: | Can | Cannot |
142: |-----|--------|
143: | Send heartbeat (status ping) | Manage bookings |
144: | Receive lock/unlock commands | Change pricing |
145: | Sync session logs (offline batch) | Access billing data |
146: | Report local timer status | Manage users or admins |
147: | Continue offline when disconnected | |
148: 
149: ---
150: 
151: ## 5. Complete Module Map with Endpoint Catalog
152: 
153: ### 5.1 Auth Module
154: **Prefix**: `/auth` | **Auth Level**: Mostly Public
155: 
156: | Method | Path | Description | Auth | Request Body |
157: |--------|------|-------------|------|-------------|
158: | POST | `/auth/register` | Register new user | Public | `{ phone?, email?, name, password? }` |
159: | POST | `/auth/login/otp` | Request OTP (phone) | Public | `{ phone }` |
160: | POST | `/auth/login/email` | Email + password login | Public | `{ email, password }` |
161: | POST | `/auth/login/oauth/:provider` | OAuth (google/apple) | Public | `{ code, state }` |
162: | POST | `/auth/verify/otp` | Verify OTP + get tokens | Public | `{ phone, code }` |
163: | POST | `/auth/verify/email` | Verify email via link | Public | `{ token }` |
164: | POST | `/auth/refresh` | Refresh access token | Valid refresh token | `{ refreshToken }` |
165: | POST | `/auth/logout` | Logout + revoke session | Authenticated | — |
166: | POST | `/auth/password/reset/request` | Request reset email | Public | `{ email }` |
167: | POST | `/auth/password/reset/confirm` | Confirm password reset | Public | `{ token, newPassword }` |
168: | POST | `/auth/phone/change` | Initiate phone change | Authenticated | `{ newPhone }` |
169: | GET | `/auth/me` | Get my profile | Authenticated | — |
170: | PATCH | `/auth/me` | Update my profile | Authenticated | `{ name?, email? }` |
171: | PATCH | `/auth/me/device` | Register/update FCM token | Authenticated | `{ fcmToken, platform }` |
172: 
173: ### 5.2 Stores Module
174: **Prefix**: `/stores` | **Auth Level**: Mixed
175: 
176: | Method | Path | Description | Auth |
177: |--------|------|-------------|------|
178: | GET | `/stores` | List all active stores | Public |
179: | GET | `/stores/:slug` | Get store by slug | Public |
180: | POST | `/stores` | Create store | Super Admin |
181: | PATCH | `/stores/:id` | Update store | Super Admin |
182: | GET | `/stores/:id/config` | Get booking config | Admin+ |
183: | PATCH | `/stores/:id/config` | Update booking config | Super Admin |
184: 
185: ### 5.3 System Types Module
186: **Prefix**: `/stores/:storeId/system-types`
187: 
188: | Method | Path | Description | Auth |
189: |--------|------|-------------|------|
190: | GET | `/` | List system types | Admin+ |
191: | POST | `/` | Create system type | Admin+ |
192: | PATCH | `/:id` | Update system type | Admin+ |
193: | DELETE | `/:id` | Deactivate system type | Super Admin |
194: 
195: ### 5.4 Systems Module
196: **Prefix**: `/stores/:storeId/systems`
197: 
198: | Method | Path | Description | Auth |
199: |--------|------|-------------|------|
200: | GET | `/` | List all systems with status | Admin+ |
201: | GET | `/available` | Available systems for booking | Authenticated |
202: | GET | `/live` | Live status overview | Admin+ |
203: | GET | `/:id` | System detail | Admin+ |
204: | POST | `/` | Register system | Admin+ |
205: | PATCH | `/:id` | Update system | Admin+ |
206: | DELETE | `/:id` | Deactivate system | Super Admin |
207: | POST | `/:id/heartbeat` | Agent heartbeat | System Agent |
208: 
209: ### 5.5 Bookings Module
210: **Prefix**: `/stores/:storeId/bookings`
211: 
212: | Method | Path | Description | Auth |
213: |--------|------|-------------|------|
214: | GET | `/` | List bookings (filtered) | Admin+ |
215: | GET | `/my` | My bookings | Authenticated |
216: | GET | `/availability` | Check slot availability | Authenticated |
217: | GET | `/:id` | Booking detail | Owner/Admin |
218: | POST | `/` | Create booking | Authenticated |
219: | POST | `/walk-in` | Walk-in booking + session | Admin+ |
220: | POST | `/:id/pay` | Pay for booking | Owner |
221: | POST | `/:id/cancel` | Cancel booking | Owner/Admin |
222: | POST | `/:id/check-in` | Check in | Owner/Admin |
223: | PATCH | `/:id` | Extend booking | Admin+ |
224: 
225: ### 5.6 Sessions Module
226: **Prefix**: `/stores/:storeId/sessions`
227: 
228: | Method | Path | Description | Auth |
229: |--------|------|-------------|------|
230: | GET | `/` | List sessions | Admin+ |
231: | GET | `/active` | Active sessions | Admin+ |
232: | GET | `/my` | My session history | Authenticated |
233: | GET | `/:id` | Session detail | Owner/Admin |
234: | POST | `/` | Start session (walk-in) | Admin+ |
235: | POST | `/:id/end` | End session | Admin+/Agent |
236: | POST | `/:id/extend` | Extend session | Admin+ |
237: | POST | `/:id/pause` | Pause session | Admin+ |
238: | POST | `/:id/resume` | Resume session | Admin+ |
239: | GET | `/:id/logs` | Session event logs | Admin+ |
240: | POST | `/sync` | Agent bulk log sync | System Agent |
241: 
242: ### 5.7 Pricing Module
243: **Prefix**: `/stores/:storeId/pricing`
244: 
245: | Method | Path | Description | Auth |
246: |--------|------|-------------|------|
247: | GET | `/rules` | List pricing rules | Admin+ |
248: | POST | `/rules` | Create rule | Admin+ |
249: | PATCH | `/rules/:id` | Update rule | Admin+ |
250: | DELETE | `/rules/:id` | Deactivate rule | Admin+ |
251: | POST | `/calculate` | Price preview | Admin+ |
252: 
253: ### 5.8 Billing Module
254: **Prefix**: `/stores/:storeId/billing`
255: 
256: | Method | Path | Description | Auth |
257: |--------|------|-------------|------|
258: | GET | `/ledger` | Billing ledger | Admin+ |
259: | GET | `/ledger/:id` | Record detail | Admin+ |
260: | GET | `/my` | My billing history | Authenticated |
261: | POST | `/:sessionId/bill` | Generate bill | System/Admin |
262: | POST | `/:billingId/override` | Price override | Super Admin |
263: | GET | `/revenue/summary` | Revenue report | Admin+ |
264: 
265: ### 5.9 Payments Module
266: **Prefix**: `/stores/:storeId/payments`
267: 
268: | Method | Path | Description | Auth |
269: |--------|------|-------------|------|
270: | GET | `/` | List payments | Admin+ |
271: | GET | `/:id` | Payment detail | Admin+ |
272: | POST | `/` | Record payment | Admin+ |
273: | POST | `/:id/refund` | Refund payment | Super Admin |
274: | GET | `/reconciliation` | Reconciliation report | Super Admin |
275: 
276: ### 5.10 Credits Module
277: **Prefix**: `/stores/:storeId/credits`
278: 
279: | Method | Path | Description | Auth |
280: |--------|------|-------------|------|
281: | GET | `/balance` | My balance | Authenticated |
282: | GET | `/balance/:userId` | User balance | Admin+ |
283: | GET | `/transactions` | My credit history | Authenticated |
284: | GET | `/transactions/:userId` | User credit history | Admin+ |
285: | POST | `/redeem` | Redeem credits | Authenticated |
286: | POST | `/adjust` | Manual adjustment | Admin+ |
287: 
288: ### 5.11 Campaigns Module
289: **Prefix**: `/stores/:storeId/campaigns`
290: 
291: | Method | Path | Description | Auth |
292: |--------|------|-------------|------|
293: | GET | `/` | List campaigns | Admin+ |
294: | GET | `/active` | Active campaigns | Authenticated |
295: | GET | `/:id` | Campaign detail | Admin+ |
296: | POST | `/` | Create campaign | Admin+ |
297: | PATCH | `/:id` | Update campaign | Admin+ |
298: | POST | `/:id/pause` | Pause | Admin+ |
299: | POST | `/:id/resume` | Resume | Admin+ |
300: | POST | `/:id/redeem` | Redeem | Authenticated |
301: | GET | `/:id/redemptions` | Redemption history | Admin+ |
302: 
303: ### 5.12 Notifications Module
304: **Prefix**: `/notifications`
305: 
306: | Method | Path | Description | Auth | Channels |
307: |--------|------|-------------|------|---------|
308: | GET | `/` | My notifications | Authenticated | — |
309: | GET | `/:id` | Notification detail | Owner | — |
310: | PATCH | `/:id/read` | Mark as read | Owner | — |
311: | POST | `/read-all` | Mark all read | Authenticated | — |
312: | GET | `/preferences` | My preferences | Authenticated | — |
313: | PATCH | `/preferences` | Update preferences | Authenticated | — |
314: | POST | `/admin/send` | Send to users | Admin+ | push, email, in_app, sms |
315: | POST | `/admin/send/topic` | Broadcast to topic | Admin+ | push (FCM topic) |
316: 
317: **Notification delivery logic**:
318: 1. Check user's `notification_preferences` for each channel
319: 2. In-app: always insert to `notifications` table
320: 3. Push: call `sendPushNotification` if user has active FCM token
321: 4. Email: call `sendEmail` (fire-and-forget for non-critical)
322: 5. SMS: integrate with Twilio/MSG91 (similar to email pattern)
323: 
324: ### 5.13 Disputes Module
325: **Prefix**: `/stores/:storeId/disputes`
326: 
327: | Method | Path | Description | Auth |
328: |--------|------|-------------|------|
329: | GET | `/` | List disputes | Admin+ |
330: | GET | `/my` | My disputes | Authenticated |
331: | POST | `/` | Create dispute | Authenticated |
332: | GET | `/:id` | Dispute detail | Owner/Admin |
333: | POST | `/:id/review` | Start review | Admin+ |
334: | POST | `/:id/resolve` | Resolve dispute | Admin+ |
335: | POST | `/:id/withdraw` | Withdraw dispute | Owner |
336: 
337: ### 5.14 Store Admins Module
338: **Prefix**: `/stores/:storeId/admins`
339: 
340: | Method | Path | Description | Auth |
341: |--------|------|-------------|------|
342: | GET | `/` | List admins | Super Admin |
343: | POST | `/` | Create admin | Super Admin |
344: | PATCH | `/:id` | Update admin | Super Admin |
345: | DELETE | `/:id` | Deactivate admin | Super Admin |
346: | POST | `/login` | Admin login | Public |
347: | POST | `/password-reset/request` | Request reset | Public |
348: | POST | `/password-reset/confirm` | Confirm reset | Public |
349: 
350: ### 5.15 Analytics Module
351: **Prefix**: `/stores/:storeId/analytics`
352: 
353: | Method | Path | Description | Auth |
354: |--------|------|-------------|------|
355: | GET | `/dashboard` | Dashboard overview | Admin+ |
356: | GET | `/revenue` | Revenue analytics | Admin+ |
357: | GET | `/utilization` | Utilization heatmap | Admin+ |
358: | GET | `/sessions/stats` | Session statistics | Admin+ |
359: | GET | `/players` | Player analytics | Admin+ |
360: | GET | `/systems/performance` | System usage | Admin+ |
361: 
362: ### 5.16 WebSocket Channels
363: 
364: | Channel | WS Path | Auth Method | Subscribers |
365: |---------|---------|-------------|-------------|
366: | Store Live Feed | `/ws/stores/:storeId/live?token=` | Admin JWT query param | Admin Dashboard |
367: | Agent Command Link | `/ws/stores/:storeId/agent/:systemId?key=` | API key query param | System Agent |
368: | Player Notify | `/ws/users/:userId/notify?token=` | User JWT query param | Player App |
369: 
370: ---
371: 
372: ## 6. Database Table → Module Mapping
373: 
374: | Module | Primary Tables | Tenant-Scoped? |
375: |--------|---------------|----------------|
376: | Auth | `users`, `user_credentials`, `user_sessions`, `verification_tokens`, `user_identifiers` | ❌ Global |
377: | Devices | `user_devices` (FCM tokens) | ❌ Global |
378: | Stores | `stores` | ❌ Global |
379: | System Types | `system_types` | ✅ Yes |
380: | Systems | `systems` | ✅ Yes |
381: | Bookings | `bookings` | ✅ Yes |
382: | Sessions | `sessions`, `session_logs` | ✅ Yes |
383: | Pricing | `pricing_rules` | ✅ Yes |
384: | Billing | `billing_ledger`, `admin_overrides` | ✅ Yes |
385: | Payments | `payments` | ✅ Yes |
386: | Credits | `credit_ledger`, `credit_balances` (mat. view) | ✅ Yes |
387: | Campaigns | `campaigns`, `campaign_redemptions` | ✅ Yes |
388: | Notifications | `notifications`, `notification_preferences` | ❌ Global (userId only) |
389: | Disputes | `billing_disputes` | ✅ Yes |
390: | Store Admins | `store_admins` | ✅ Yes |
391: | Analytics | `store_daily_summary`, `store_hourly_summary` | ✅ Yes |
392: 
393: ---
394: 
395: ## 7. Authentication and Authorization Model
396: 
397: ### 7.1 JWT Strategy
398: 
399: | Token | Lifetime | Storage | Header |
400: |-------|----------|---------|--------|
401: | User Access Token | 15 min | Client memory | `Authorization: Bearer {token}` |
402: | User Refresh Token | 7 days | httpOnly cookie OR Redis | Body `{ refreshToken }` |
403: | Admin Access Token | 15 min | Client memory | `Authorization: Bearer {token}` |
404: | Agent API Key | No expiry | System config file | `X-Agent-Key: {key}` |
405: 
406: ### 7.2 JWT Payload Shapes
407: 
408: ```typescript
409: // User JWT payload
410: { sub: userId, type: 'user', iat: number, exp: number }
411: 
412: // Admin JWT payload
413: { sub: adminId, type: 'admin', storeId: storeId, role: 'super_admin' | 'admin' | 'staff', iat: number, exp: number }
414: ```
415: 
416: ### 7.3 Auth Middleware Context Injections
417: 
418: ```typescript
419: // userAuth injects:
420: { user: { id: string, name: string, email: string | null, phone: string | null, ... } }
421: 
422: // adminAuth injects:
423: { admin: { id: string, storeId: string, role: 'super_admin' | 'admin' | 'staff', name: string } }
424: 
425: // agentAuth injects:
426: { system: { id: string, storeId: string, name: string } }
427: ```
428: 
429: ---
430: 
431: ## 8. All Database Enum Types (19 total)
432: 
433: | Enum | Values | Module |
434: |------|--------|--------|
435: | `system_status` | `available`, `in_use`, `maintenance`, `offline` | Systems |
436: | `booking_status` | `pending`, `confirmed`, `checked_in`, `cancelled`, `no_show` | Bookings |
437: | `session_status` | `in_progress`, `completed`, `cancelled`, `disputed` | Sessions |
438: | `booking_type` | `paid`, `reserved`, `walk_in` | Bookings |
439: | `payment_method` | `cash`, `card`, `upi`, `wallet`, `credits` | Payments |
440: | `payment_status` | `pending`, `completed`, `failed`, `refunded` | Payments |
441: | `pricing_rule_type` | `base`, `peak`, `off_peak`, `weekend`, `custom` | Pricing |
442: | `override_type` | `price`, `duration`, `both` | Billing |
443: | `auth_method` | `phone_otp`, `email_password`, `google_oauth`, `apple_oauth` | Auth |
444: | `admin_role` | `super_admin`, `admin`, `staff` | Store Admins |
445: | `system_platform` | `pc`, `ps5`, `ps4`, `xbox`, `vr`, `other` | Systems |
446: | `dispute_status` | `open`, `under_review`, `resolved`, `withdrawn` | Disputes |
447: | `dispute_resolution` | `upheld`, `partial_refund`, `full_refund`, `credit_issued` | Disputes |
448: | `campaign_type` | `percentage_off`, `fixed_off`, `bonus_minutes`, `bonus_credits`, `happy_hour`, `first_visit` | Campaigns |
449: | `campaign_status` | `draft`, `scheduled`, `active`, `paused`, `expired`, `cancelled` | Campaigns |
450: | `notification_channel` | `push`, `sms`, `email`, `in_app` | Notifications |
451: | `notification_status` | `pending`, `sent`, `delivered`, `failed`, `read` | Notifications |
452: | `verification_purpose` | `phone_verification`, `email_verification`, `password_reset`, `login_otp`, `phone_change` | Auth |
453: | `credit_transaction_type` | `earned`, `redeemed`, `bonus`, `admin_adjust`, `expired`, `refund` | Credits |
454: 
455: ---
456: 
457: ## 9. Non-Negotiable Business Rules
458: 
459: These rules must be respected by every service method. No exceptions.
460: 
461: 1. **Billing is based on actual session time** — `sessions` table, not `bookings`. Sessions record real play time.
462: 2. **Pricing is snapshotted at billing time** — `base_rate` and `applied_multiplier` are written to `billing_ledger` at bill generation and are immutable.
463: 3. **Revenue dashboards always sum from `billing_ledger`** — NOT from `payments`. These are separate concepts.
464: 4. **Credits use append-only ledger accounting** — `credit_ledger` is never updated or deleted. Balance = `SUM(amount)` from ledger.
465: 5. **Credits are store-specific** — Credits from Store A cannot be used in Store B.
466: 6. **Booking priority**: Paid > Walk-in > Reserved unpaid. Walk-ins can override unpaid reservations.
467: 7. **Booking windows are per-store config** — `booking_window_minutes`, `payment_window_minutes`, `no_show_grace_minutes`, `check_in_early_minutes`.
468: 8. **Sessions can run past booking end time** — session continues until explicitly ended.
469: 9. **Every admin override requires a `reason` and `admin_id`** — mandatory for audit trail.
470: 10. **Payment idempotency is mandatory** — Every payment must have an `idempotency_key`. Duplicates return the existing payment (200, not 201).
471: 11. **Booking mutex** — Acquire Redis lock `lock:booking:{systemId}:{slot}` before creating booking. Release after commit.
472: 12. **OTP rate limiting** — Max 3 OTP requests per phone/email per 10 minutes. Max 5 attempts per OTP. Track in Redis.
473: 13. **FCM token cleanup** — Mark tokens `is_active = false` on `messaging/registration-token-not-registered` errors.
474: 14. **Never expose raw DB errors** — Catch `postgres` errors and throw typed `BusinessRuleError` instead.
475: 
476: ---
477: 
478: ## 10. Auth Module — Detailed Implementation Guide
479: 
480: > This section is the primary reference for implementing the Auth system first.
481: 
482: ### OTP Flow (Phone Login):
483: ```
484: POST /auth/login/otp { phone }
485:   → Generate 6-digit OTP
486:   → Store in Redis: otp:{phone} = { code, attempts: 0 } TTL: 10m
487:   → Rate check: ratelimit:otp:send:{phone} (max 3 per 10m)
488:   → Send SMS (Twilio/MSG91) — fire-and-forget
489:   → Send push notification if user already has FCM token
490:   → Return { message: "OTP sent" }
491: 
492: POST /auth/verify/otp { phone, code }
493:   → Look up otp:{phone} from Redis
494:   → Check attempts < 5 (else: OTP_MAX_ATTEMPTS)
495:   → Verify code matches (else: increment attempts, return OTP_INVALID)
496:   → Delete otp:{phone} from Redis
497:   → Upsert user (create if new phone)
498:   → Create user_sessions record
499:   → Store refresh token hash in Redis: session:{hash} TTL: 7d
500:   → Return { accessToken, refreshToken, user }
501: ```
502: 
503: ### Email+Password Login Flow:
504: ```
505: POST /auth/login/email { email, password }
506:   → Find user by email
507:   → Verify password with Bun.password.verify()
508:   → Check email is verified (else: EMAIL_NOT_VERIFIED)
509:   → Create user_sessions record
510:   → Store refresh token hash in Redis
511:   → Return { accessToken, refreshToken, user }
512: ```
513: 
514: ### Token Refresh Flow:
515: ```
516: POST /auth/refresh { refreshToken }
517:   → Hash the provided refresh token
518:   → Look up session:{hash} in Redis
519:   → If not found: REFRESH_TOKEN_INVALID
520:   → Verify JWT is valid and not expired
521:   → Generate new access token (and optionally rotate refresh token)
522:   → Return { accessToken, refreshToken? }
523: ```
524: 
525: ### Password Reset Flow:
526: ```
527: POST /auth/password/reset/request { email }
528:   → Find user by email (return success even if not found — don't leak existence)
529:   → Generate secure random token (crypto.randomUUID)
530:   → Store in verification_tokens table: { token, userId, purpose: 'password_reset', expiresAt: +30min }
531:   → Send password reset email with link: {FRONTEND_URL}/reset-password?token={token}
532:   → Return { message: "If the email exists, a reset link was sent" }
533: 
534: POST /auth/password/reset/confirm { token, newPassword }
535:   → Look up token in verification_tokens where purpose = 'password_reset'
536:   → Check expiresAt > now (else: TOKEN_EXPIRED)
537:   → Hash new password with Bun.password.hash()
538:   → Update user_credentials passwordHash
539:   → Delete token from verification_tokens
540:   → Revoke all existing sessions for this user (delete from Redis)
541:   → Return { message: "Password updated" }
542: ```
543: 
544: ### Register Flow:
545: ```
546: POST /auth/register { name, email?, phone?, password? }
547:   → Check uniqueness of email and phone
548:   → Hash password with Bun.password.hash() if provided
549:   → Insert user
550:   → If email provided: send verification email with token
551:   → If phone provided: auto-send OTP
552:   → Return { user } (201)
553: ```
554: 
555: ### FCM Token Registration:
556: ```
557: PATCH /auth/me/device { fcmToken, platform }
558:   → Authenticated endpoint
559:   → Upsert user_devices: { userId, fcmToken, platform, isActive: true, updatedAt: now }
560:   → If same token exists for different user: deactivate the old one
561:   → Return { message: "Device registered" }
562: ```
563: 
564: ### Drizzle Schema for Auth:
565: ```typescript
566: // Key tables for auth — define in src/modules/auth/schema.ts
567: 
568: export const users = pgTable('users', {
569:   id: uuid('id').primaryKey().defaultRandom(),
570:   name: text('name').notNull(),
571:   email: text('email').unique(),
572:   phone: text('phone').unique(),
573:   isEmailVerified: boolean('is_email_verified').default(false).notNull(),
574:   isPhoneVerified: boolean('is_phone_verified').default(false).notNull(),
575:   createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
576:   updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull(),
577: });
578: 
579: export const userCredentials = pgTable('user_credentials', {
580:   id: uuid('id').primaryKey().defaultRandom(),
581:   userId: uuid('user_id').references(() => users.id).notNull(),
582:   authMethod: authMethodEnum('auth_method').notNull(),
583:   identifier: text('identifier').notNull(),  // email, phone, or provider sub
584:   passwordHash: text('password_hash'),
585:   createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
586: });
587: 
588: export const userSessions = pgTable('user_sessions', {
589:   id: uuid('id').primaryKey().defaultRandom(),
590:   userId: uuid('user_id').references(() => users.id).notNull(),
591:   tokenHash: text('token_hash').unique().notNull(),  // sha256 of refresh token
592:   expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
593:   createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
594:   revokedAt: timestamp('revoked_at', { withTimezone: true }),
595: });
596: 
597: export const verificationTokens = pgTable('verification_tokens', {
598:   id: uuid('id').primaryKey().defaultRandom(),
599:   userId: uuid('user_id').references(() => users.id).notNull(),
600:   token: text('token').unique().notNull(),
601:   purpose: verificationPurposeEnum('purpose').notNull(),
602:   expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
603:   createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
604: });
605: 
606: export const userDevices = pgTable('user_devices', {
607:   id: uuid('id').primaryKey().defaultRandom(),
608:   userId: uuid('user_id').references(() => users.id).notNull(),
609:   fcmToken: text('fcm_token').notNull(),
610:   platform: text('platform').notNull(),  // 'ios' | 'android' | 'web'
611:   isActive: boolean('is_active').default(true).notNull(),
612:   createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
613:   updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull(),
614: });
615: ```

(End of file - total 615 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/schema.md",
  "limit": 100
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/schema.md</path>
<type>file</type>
<content>
1: # Gaming Zone SaaS - Database Schema
2: 
3: **Version**: 2.0.0
4: **Last Updated**: 2026-04-02
5: **PostgreSQL Version**: 14+
6: 
7: ---
8: 
9: ## Overview
10: 
11: Multi-tenant SaaS database for managing physical gaming zones (PC cafés / console arenas). Supports slot booking, real-time session management, dynamic pricing, accurate billing with historical integrity, user authentication, credit ledger, campaigns, and dispute resolution.
12: 
13: ### Key Features
14: 
15: - **Multi-tenant isolation** via Row-Level Security (RLS)
16: - **Immutable billing ledger** with price snapshots
17: - **Hybrid timing model** (local system agent + cloud reconciliation)
18: - **Dynamic pricing** based on time, day, system type, platform, and tier
19: - **Full auth stack** — phone OTP, email+password, OAuth
20: - **Credit ledger accounting** — never stores only balance
21: - **Booking window enforcement** — configurable booking/payment deadlines
22: - **Overlap prevention** — exclusion constraints prevent double-booking
23: - **Campaign engine** — promotions with redemptions tracking
24: 
25: ---
26: 
27: ## Entity Relationship Diagram
28: 
29: ```
30: ┌─────────────────────────────────────────────────────────────────────────────┐
31: │                              GLOBAL TABLES                                   │
32: │  (No store_id - accessible across all tenants)                              │
33: ├─────────────────────────────────────────────────────────────────────────────┤
34: │                                                                              │
35: │   ┌──────────────┐     ┌──────────────┐     ┌──────────────────┐           │
36: │   │    users     │     │user_credential│     │ verification_    │           │
37: │   │              │◄────│     s        │     │   tokens         │           │
38: │   └──────┬───────┘     └──────────────┘     └──────────────────┘           │
39: │          │                                                                  │
40: │   ┌──────▼───────┐     ┌──────────────┐     ┌──────────────────┐           │
41: │   │   stores     │     │user_sessions │     │user_identifiers  │           │
42: │   └──────┬───────┘     └──────────────┘     └──────────────────┘           │
43: │          │                                                                  │
44: └──────────┼──────────────────────────────────────────────────────────────────┘
45:            │
46:            │  store_id (FK)
47:            ▼
48: ┌─────────────────────────────────────────────────────────────────────────────┐
49: │                           TENANT-SCOPED TABLES                               │
50: │  (All have store_id - isolated by RLS policies)                             │
51: ├─────────────────────────────────────────────────────────────────────────────┤
52: │                                                                              │
53: │   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐               │
54: │   │store_admins  │     │ system_types │     │   systems    │               │
55: │   │(super_admin/ │     │(PC/PS5/etc.) │     │ (stations)   │               │
56: │   │ admin/staff) │     └──────┬───────┘     └──────┬───────┘               │
57: │   └──────────────┘            │                     │                       │
58: │                               └─────────────────────┘                       │
59: │                                        │                                     │
60: │   ┌──────────────┐     ┌──────────────▼────────┐     ┌──────────────┐      │
61: │   │pricing_rules │◄────│      bookings         │────►│   sessions   │      │
62: │   └──────────────┘     │(expires_at, overlap   │     └──────┬───────┘      │
63: │                        │ protection, priority) │            │               │
64: │                        └───────────────────────┘            │               │
65: │                                                              │               │
66: │   ┌──────────────┐     ┌──────────────┐     ┌──────────────▼────┐          │
67: │   │   payments   │◄────│billing_ledger│     │  session_logs     │          │
68: │   │(idempotency) │     │  (immutable) │     └───────────────────┘          │
69: │   └──────────────┘     └──────┬───────┘                                    │
70: │                               │                                             │
71: │   ┌──────────────┐            │     ┌──────────────┐                       │
72: │   │admin_overrides│◄──────────┘     │billing_      │                       │
73: │   └──────────────┘                  │  disputes   │                       │
74: │                                     └──────────────┘                       │
75: │                                                                              │
76: │   ┌──────────────┐     ┌──────────────────┐                                │
77: │   │ credit_ledger│     │ credit_balances  │                                │
78: │   │ (immutable)  │────►│ (materialized vw)│                                │
79: │   └──────────────┘     └──────────────────┘                                │
80: │                                                                              │
81: │   ┌──────────────┐     ┌──────────────────┐                                │
82: │   │  campaigns   │────►│campaign_          │                                │
83: │   │              │     │  redemptions      │                                │
84: │   └──────────────┘     └──────────────────┘                                │
85: │                                                                              │
86: │   ┌──────────────┐     ┌──────────────────┐                                │
87: │   │notifications │     │notification_     │                                │
88: │   │              │     │  preferences     │                                │
89: │   └──────────────┘     └──────────────────┘                                │
90: │                                                                              │
91: │   ┌──────────────┐     ┌──────────────────┐                                │
92: │   │store_daily_  │     │store_hourly_     │                                │
93: │   │  summary     │     │  summary         │                                │
94: │   └──────────────┘     └──────────────────┘                                │
95: │                                                                              │
96: └─────────────────────────────────────────────────────────────────────────────┘
97: ```
98: 
99: ---
100: 

(Showing lines 1-100 of 868. Use offset=101 to continue.)
</content>
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 5.5s)

Now let me check the admin-specific endpoints and the existing docs:

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/docs/general-idea.md",
  "limit": 50
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/docs/general-idea.md</path>
<type>file</type>
<content>
1: # Master Architecture Blueprint
2: ## ElysiaJS + Bun + PostgreSQL + Drizzle ORM — Production API
3: 
4: > **Purpose**: This document is the foundational architectural reference. Feed it into any AI code generator as the primary context document. It defines the project's skeleton, patterns, and integrations.
5: 
6: ---
7: 
8: ## Tech Stack (Exact Versions)
9: 
10: | Layer | Package | Purpose |
11: |-------|---------|---------|
12: | Runtime | `bun` (latest) | JS runtime — native TS, fast cold start |
13: | Framework | `elysia` ^1.x | HTTP + WebSocket server |
14: | ORM | `drizzle-orm` + `drizzle-kit` | Type-safe query builder |
15: | DB Driver | `postgres` (postgres.js) | PostgreSQL connection pool |
16: | Cache | `ioredis` | Redis client (Bun-compatible) |
17: | Auth | `@elysiajs/jwt` | JWT signing/verification |
18: | CORS | `@elysiajs/cors` | Cross-origin support |
19: | Docs | `@elysiajs/swagger` | Auto OpenAPI 3.0 docs |
20: | Push | `firebase-admin` | FCM v1 push notifications |
21: | Email | `nodemailer` + `@react-email/components` | Transactional email |
22: | Logging | `pino` | Structured JSON logging |
23: | Validation | `elysia` (TypeBox via `t`) | Runtime validation + TS inference |
24: 
25: ---
26: 
27: ## 1. Canonical Folder Structure
28: 
29: ```text
30: 📦 project-root
31:  ┣ 📂 src
32:  ┃ ┣ 📂 modules                    # Feature modules (one folder per domain)
33:  ┃ ┃ ┣ 📂 auth
34:  ┃ ┃ ┃ ┣ 📜 index.ts               # Controller: routes only, no logic
35:  ┃ ┃ ┃ ┣ 📜 service.ts             # Service: all business logic (abstract class)
36:  ┃ ┃ ┃ ┗ 📜 model.ts               # Model: all Elysia t.Object schemas
37:  ┃ ┃ ┣ 📂 users
38:  ┃ ┃ ┣ 📂 notifications
39:  ┃ ┃ ┗ 📂 [other-modules]
40:  ┃ ┣ 📂 db
41:  ┃ ┃ ┣ 📜 index.ts                 # Drizzle instance + connection pool
42:  ┃ ┃ ┣ 📜 schema.ts                # Central re-export of all table schemas
43:  ┃ ┃ ┗ 📂 migrations               # Drizzle migration files
44:  ┃ ┣ 📂 lib                        # Shared, stateless utilities
45:  ┃ ┃ ┣ 📜 responses.ts             # sendSuccess / sendError helpers
46:  ┃ ┃ ┣ 📜 errors.ts                # Custom error classes (BusinessRuleError, etc.)
47:  ┃ ┃ ┣ 📜 redis.ts                 # Redis client singleton
48:  ┃ ┃ ┣ 📜 logger.ts                # Pino logger singleton
49:  ┃ ┃ ┣ 📜 fcm.ts                   # Firebase Admin + FCM helpers
50:  ┃ ┃ ┗ 📜 mailer.ts                # Nodemailer transporter + send helpers

(Showing lines 1-50 of 858. Use offset=51 to continue.)
</content>
```

**Tool: glob**

**Input:**
```json
{
  "path": "/Users/pratham/code/gz_ideation/src/modules",
  "pattern": "**/admin*"
}
```

**Output:**
```
No files found
[Agent Usage Reminder]

You called a search/fetch tool directly without leveraging specialized agents.

RECOMMENDED: Use task with explore/librarian agents for better results:

```
// Parallel exploration - fire multiple agents simultaneously
task(subagent_type="explore", load_skills=[], prompt="Find all files matching pattern X")
task(subagent_type="explore", load_skills=[], prompt="Search for implementation of Y")
task(subagent_type="librarian", load_skills=[], prompt="Lookup documentation for Z")

// Then continue your work while they run in background
// System will notify you when each completes
```

WHY:
- Agents can perform deeper, more thorough searches
- Background tasks run in parallel, saving time
- Specialized agents have domain expertise
- Reduces context window usage in main session

ALWAYS prefer: Multiple parallel task calls > Direct tool calls

```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 4.9s)

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/pratham/code/gz_ideation/src/modules/store-admins"
}
```

**Output:**
```
<path>/Users/pratham/code/gz_ideation/src/modules/store-admins</path>
<type>directory</type>
<entries>
index.ts
model.ts
service.ts

(3 entries)
</entries>
```

---

## Assistant (Sisyphus (Ultraworker) · GLM-5.1 · 47.2s)

Now I have everything I need. Here's the prompt:

---

**Copy-paste this into your backend OpenCode at `/Users/pratham/code/gz_ideation/`:**

---

```
I need you to generate a comprehensive admin dashboard UX design document — exactly like what `docs/mobile-ux-design.md` is for the Player Mobile App, but for the **Admin Dashboard (Web SPA)**.

## What I Need

A single markdown file: `docs/admin-dashboard-ux-design.md`

It must follow the EXACT same structure and depth as `docs/mobile-ux-design.md` — meaning:
- Every screen numbered, named, and described
- Every screen lists its API calls (method + path) mapped to actual endpoints from this API
- Navigation architecture with full tree
- UI elements, sections, form fields per screen
- Business logic and validation rules per screen
- A full API coverage map table at the end (every admin endpoint → which screen uses it)
- Role-based access matrix (what super_admin vs admin vs staff sees)
- Real-time strategy (WebSocket channels for admin)
- State management considerations
- Deep link map if applicable

## Scope — Admin Dashboard ONLY

This is the **Store Admin Dashboard** — a web SPA for store owners, managers, and staff.

Three roles exist in `store_admins` table:
- **super_admin**: Full control — can manage other admins, billing overrides, payments, reconciliation
- **admin**: Session management, pricing, campaigns, analytics, billing overrides
- **staff**: Limited — can start/stop sessions, view analytics (read-only)

## API-First Approach

Call out EVERY endpoint from the API that the admin dashboard uses. Reference the actual routes from the codebase. The admin dashboard consumes these modules/endpoints (from `docs/api-overview.md`):

**Auth:**
- `POST /stores/:storeId/admins/login` — Admin login
- `POST /stores/:storeId/admins/password-reset/request`
- `POST /stores/:storeId/admins/password-reset/confirm`
- `POST /auth/refresh` — Token refresh

**Store Admins:**
- `GET /stores/:storeId/admins` — List admins (super_admin only)
- `POST /stores/:storeId/admins` — Create admin (super_admin only)
- `PATCH /stores/:storeId/admins/:id` — Update admin (super_admin only)
- `DELETE /stores/:storeId/admins/:id` — Deactivate admin (super_admin only)

**Stores:**
- `GET /stores/:id/config` — Get booking config
- `PATCH /stores/:id/config` — Update booking config (super_admin)

**Systems:**
- `GET /stores/:storeId/systems` — List all systems with status
- `GET /stores/:storeId/systems/live` — Live status overview
- `GET /stores/:storeId/systems/:id` — System detail
- `POST /stores/:storeId/systems` — Register system
- `PATCH /stores/:storeId/systems/:id` — Update system
- `DELETE /stores/:storeId/systems/:id` — Deactivate system

**System Types:**
- `GET /stores/:storeId/system-types` — List
- `POST /stores/:storeId/system-types` — Create
- `PATCH /stores/:storeId/system-types/:id` — Update
- `DELETE /stores/:storeId/system-types/:id` — Deactivate

**Bookings:**
- `GET /stores/:storeId/bookings` — List bookings (filtered)
- `GET /stores/:storeId/bookings/:id` — Booking detail
- `POST /stores/:storeId/bookings/walk-in` — Walk-in booking + session
- `POST /stores/:storeId/bookings/:id/cancel` — Cancel booking
- `POST /stores/:storeId/bookings/:id/check-in` — Check in
- `PATCH /stores/:storeId/bookings/:id` — Extend booking

**Sessions:**
- `GET /stores/:storeId/sessions` — List sessions
- `GET /stores/:storeId/sessions/active` — Active sessions
- `GET /stores/:storeId/sessions/:id` — Session detail
- `POST /stores/:storeId/sessions` — Start session (walk-in)
- `POST /stores/:storeId/sessions/:id/end` — End session
- `POST /stores/:storeId/sessions/:id/extend` — Extend session
- `POST /stores/:storeId/sessions/:id/pause` — Pause session
- `POST /stores/:storeId/sessions/:id/resume` — Resume session
- `GET /stores/:storeId/sessions/:id/logs` — Session event logs

**Pricing:**
- `GET /stores/:storeId/pricing/rules` — List pricing rules
- `POST /stores/:storeId/pricing/rules` — Create rule
- `PATCH /stores/:storeId/pricing/rules/:id` — Update rule
- `DELETE /stores/:storeId/pricing/rules/:id` — Deactivate rule
- `POST /stores/:storeId/pricing/calculate` — Price preview

**Billing:**
- `GET /stores/:storeId/billing/ledger` — Billing ledger
- `GET /stores/:storeId/billing/ledger/:id` — Record detail
- `POST /stores/:storeId/billing/:sessionId/bill` — Generate bill
- `POST /stores/:storeId/billing/:billingId/override` — Price override
- `GET /stores/:storeId/billing/revenue/summary` — Revenue report

**Payments:**
- `GET /stores/:storeId/payments` — List payments
- `GET /stores/:storeId/payments/:id` — Payment detail
- `POST /stores/:storeId/payments` — Record payment
- `POST /stores/:storeId/payments/:id/refund` — Refund payment
- `GET /stores/:storeId/payments/reconciliation` — Reconciliation report

**Credits:**
- `GET /stores/:storeId/credits/balance/:userId` — User balance
- `GET /stores/:storeId/credits/transactions/:userId` — User credit history
- `POST /stores/:storeId/credits/adjust` — Manual adjustment

**Campaigns:**
- `GET /stores/:storeId/campaigns` — List campaigns
- `GET /stores/:storeId/campaigns/:id` — Campaign detail
- `POST /stores/:storeId/campaigns` — Create campaign
- `PATCH /stores/:storeId/campaigns/:id` — Update campaign
- `POST /stores/:storeId/campaigns/:id/pause` — Pause
- `POST /stores/:storeId/campaigns/:id/resume` — Resume
- `GET /stores/:storeId/campaigns/:id/redemptions` — Redemption history

**Notifications:**
- `POST /notifications/admin/send` — Send to users
- `POST /notifications/admin/send/topic` — Broadcast to topic

**Disputes:**
- `GET /stores/:storeId/disputes` — List disputes
- `GET /stores/:storeId/disputes/:id` — Dispute detail
- `POST /stores/:storeId/disputes/:id/review` — Start review
- `POST /stores/:storeId/disputes/:id/resolve` — Resolve dispute

**Analytics:**
- `GET /stores/:storeId/analytics/dashboard` — Dashboard overview
- `GET /stores/:storeId/analytics/revenue` — Revenue analytics
- `GET /stores/:storeId/analytics/utilization` — Utilization heatmap
- `GET /stores/:storeId/analytics/sessions/stats` — Session statistics
- `GET /stores/:storeId/analytics/players` — Player analytics
- `GET /stores/:storeId/analytics/systems/performance` — System usage

**WebSocket:**
- `/ws/stores/:storeId/live?token=` — Store live feed (real-time system status, session events, booking updates)

## What Each Screen Must Include

For EVERY screen, specify:
1. **Screen name and number**
2. **Access**: How you get there + which roles can see it
3. **Purpose**: What this screen accomplishes
4. **UI sections**: Layout breakdown with component descriptions
5. **API calls**: Exact method + path (from the list above)
6. **Business logic**: Validation, conditional rendering, state transitions
7. **Real-time**: Which WebSocket events update this screen
8. **Role restrictions**: What super_admin vs admin vs staff sees differently

## Key Screens I Expect (not exhaustive — you determine the full list):

1. **Login Screen** — Admin email+password login
2. **Live Floor Map / Dashboard** — Real-time view of all systems (available, in-use, maintenance, offline) — the PRIMARY screen
3. **Session Management** — Start, end, extend, pause, resume sessions
4. **Walk-in Booking** — Quick walk-in creation assigning a system
5. **Booking Management** — View all bookings, cancel, check-in
6. **Analytics Dashboard** — Revenue charts, utilization heatmaps, session stats
7. **Pricing Rules** — CRUD for pricing rules with price calculator
8. **Billing & Payments** — Ledger, payment recording, overrides, refunds
9. **Campaign Management** — Create/edit/pause/resume campaigns, view redemptions
10. **Credits Management** — View user balances, manual adjustments
11. **Dispute Resolution** — Review and resolve disputes
12. **System Management** — Register/edit/deactivate gaming systems and types
13. **Staff Management** — CRUD for store admins (super_admin only)
14. **Store Config** — Booking windows, check-in settings
15. **Notifications** — Send announcements to players

## Format

Follow the exact format of `docs/mobile-ux-design.md`:
- Version, target platform at the top
- Numbered sections
- Navigation architecture tree
- Per-screen breakdown with API calls
- Full API coverage map at the end
- Real-time strategy section
- State management section

## Critical Rules

1. **EVERY API call must reference the actual endpoint path from the list above** — no making up endpoints
2. **Every screen must show role-based differences** — super_admin, admin, staff see different things
3. **The WebSocket channel `/ws/stores/:storeId/live` must be used extensively** — this is a real-time dashboard
4. **Be exhaustive** — this document will be fed to a frontend AI agent to build the entire admin dashboard
5. **Include analytics screens with chart descriptions** — what data each chart shows, what API endpoint feeds it
6. **Include the admin auth flow** — login, password reset, token refresh

Read `docs/mobile-ux-design.md` and `docs/api-overview.md` first for reference on format and available endpoints. Then generate the full document.
```

---

## Part 2: Generate Dart Model Files for Missing Endpoints

After generating the admin dashboard UX design document, also generate **Dart model files** for the endpoints that do NOT already have Dart models in the Flutter frontend.

### Why

The Flutter frontend already has a rich set of Dart models in `lib/models/`. We want to **copy-paste** new model files directly into that directory without any modification. The frontend AI agent will then import and use them to parse API responses.

### Existing Models (DO NOT regenerate these)

The following models already exist in the Flutter app. **Skip these entirely:**

**Core (`lib/models/core.dart`):**
- `BaseApiResponse`, `FailureResponse`, `PaginationMeta`, `SuccessResponse<T>`, `PaginatedSuccessResponse<T>`

**Enums (`lib/models/enums.dart`):**
- All 21 enums: `SystemStatus`, `BookingStatus`, `SessionStatus`, `PaymentStatus`, `PaymentMethod`, `BookingType`, `SystemType`, `CreditTransactionType`, `CampaignType`, `CampaignStatus`, `NotificationType`, `NotificationPriority`, `VerificationTokenType`, `UserRole`, `AccountType`, `VerificationStatus`, `DiscountType`, `DisputeStatus`, `OverrideType`, `TransactionType`, `PricingType`

**Domain — Global (`lib/models/domain_global.dart`):**
- `UserModel`, `StoreModel`, `UserCredentialModel`, `UserSessionModel`, `VerificationTokenModel`, `UserIdentifierModel`

**Domain — Systems (`lib/models/domain_systems.dart`):**
- `StoreAdminModel`, `SystemTypeModel`, `SystemModel`, `BookingModel`, `SessionModel`, `SessionLogModel`

**Domain — Billing (`lib/models/domain_billing.dart`):**
- `PricingRuleModel`, `BillingLedgerModel`, `PaymentModel`, `AdminOverrideModel`, `BillingDisputeModel`, `TransactionModel`

**Domain — Loyalty (`lib/models/domain_loyalty.dart`):**
- `CreditLedgerModel`, `CreditBalanceModel`, `CampaignModel`, `CampaignRedemptionModel`

**Domain — Misc (`lib/models/domain_misc.dart`):**
- `NotificationModel`, `NotificationPreferenceModel`, `StoreDailySummaryModel`, `StoreHourlySummaryModel`

**Response Wrappers (`lib/models/api_responses.dart`):**
- `AuthResponse`, `StoreListResponse`, `StoreDetailResponse`, `SystemListResponse`, `SystemDetailResponse`, `BookingListResponse`, `BookingDetailResponse`, `SessionListResponse`, `SessionDetailResponse`, `SessionLogListResponse`, `PaymentListResponse`, `PaymentDetailResponse`, `BillingLedgerListResponse`, `TransactionListResponse`, `PricingRuleListResponse`, `PricingRuleDetailResponse`, `CreditBalanceResponse`, `CreditLedgerListResponse`, `CampaignListResponse`, `CampaignDetailResponse`, `NotificationListResponse`, `NotificationPreferenceResponse`, `StoreDailySummaryListResponse`, `StoreHourlySummaryListResponse`, `AdminOverrideListResponse`, `BillingDisputeListResponse`, `UserListResponse`, `UserDetailResponse`

### Missing Models (GENERATE these)

Generate Dart model files for the following endpoints. Each model should follow the **exact pattern described below**.

#### 1. Store Config — `GET /stores/:id/config` / `PATCH /stores/:id/config`
- `StoreConfigModel` — booking window settings, check-in settings, operating hours config, system defaults

#### 2. Analytics Dashboard — `GET /analytics/dashboard`
- `AnalyticsDashboardModel` — aggregated stats: total revenue, active sessions, occupancy rate, bookings today, alerts

#### 3. Revenue Analytics — `GET /analytics/revenue`
- `RevenueAnalyticsModel` — revenue breakdown by period, by system type, comparison data, growth percentages

#### 4. Utilization — `GET /analytics/utilization`
- `UtilizationModel` — system utilization rates, peak hours, occupancy trends, per-system-type breakdown

#### 5. Session Stats — `GET /analytics/sessions/stats`
- `SessionStatsModel` — average session duration, session counts by status, session distribution by system type

#### 6. Player Analytics — `GET /analytics/players`
- `PlayerAnalyticsModel` — player registration trends, active players, top players, retention data

#### 7. System Performance — `GET /analytics/systems/performance`
- `SystemPerformanceModel` — uptime percentages, error rates, revenue per system, maintenance alerts

#### 8. Price Calculation — `POST /pricing/calculate`
- `PriceCalculationModel` — calculated price, applied rules breakdown, discounts, duration, final amount

#### 9. Payment Reconciliation — `GET /payments/reconciliation`
- `ReconciliationModel` — expected vs actual amounts, discrepancies, matched payments, outstanding items

#### 10. Revenue Summary — `GET /billing/revenue/summary`
- `RevenueSummaryModel` — total revenue, breakdown by payment method, pending amounts, period comparison

#### 11. Admin Auth Token — `POST /stores/:storeId/admins/login`
- `AdminAuthTokenResponse` — access token, refresh token, expiry, admin user info (role, permissions)

#### 12. Live Systems Overview — `GET /systems/live`
- `LiveSystemsOverviewModel` — list of live system statuses, current sessions, queue info, estimated wait times

#### 13. Walk-in Booking — `POST /bookings/walk-in`
- `WalkInBookingResponse` — combined booking + session data returned after walk-in creation

### Required Dart Model Pattern

Generate each model following this **exact pattern** (copy this style precisely):

```dart
// ============================================================
// [ModelName] — [Brief description]
// ============================================================

class StoreConfigModel {
  // Nullable fields, camelCase Dart names
  final String? id;
  final String? storeId;
  final int? defaultBookingWindowMinutes;
  final int? maxBookingWindowMinutes;
  final int? checkInGracePeriodMinutes;
  final bool? autoStartSession;
  final bool? allowWalkIns;
  final String? operatingHoursStart; // HH:mm format
  final String? operatingHoursEnd;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreConfigModel({
    this.id,
    this.storeId,
    this.defaultBookingWindowMinutes,
    this.maxBookingWindowMinutes,
    this.checkInGracePeriodMinutes,
    this.autoStartSession,
    this.allowWalkIns,
    this.operatingHoursStart,
    this.operatingHoursEnd,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreConfigModel.fromJson(Map<String, dynamic> json) =>
      StoreConfigModel(
        id: json['id']?.toString(),
        storeId: json['store_id']?.toString(),
        defaultBookingWindowMinutes:
            json['default_booking_window_minutes'] as int?,
        maxBookingWindowMinutes: json['max_booking_window_minutes'] as int?,
        checkInGracePeriodMinutes:
            json['check_in_grace_period_minutes'] as int?,
        autoStartSession: json['auto_start_session'] as bool?,
        allowWalkIns: json['allow_walk_ins'] as bool?,
        operatingHoursStart: json['operating_hours_start']?.toString(),
        operatingHoursEnd: json['operating_hours_end']?.toString(),
        isActive: json['is_active'] as bool?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'default_booking_window_minutes': defaultBookingWindowMinutes,
        'max_booking_window_minutes': maxBookingWindowMinutes,
        'check_in_grace_period_minutes': checkInGracePeriodMinutes,
        'auto_start_session': autoStartSession,
        'allow_walk_ins': allowWalkIns,
        'operating_hours_start': operatingHoursStart,
        'operating_hours_end': operatingHoursEnd,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
```

### Required Response Wrapper Pattern

For each domain model, also generate a response wrapper:

```dart
class StoreConfigResponse extends SuccessResponse<StoreConfigModel> {
  const StoreConfigResponse({super.message, super.data});

  factory StoreConfigResponse.fromJson(Map<String, dynamic> json) =>
      StoreConfigResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? StoreConfigModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}
```

For list endpoints, generate paginated wrappers:

```dart
class RevenueAnalyticsListResponse
    extends PaginatedSuccessResponse<RevenueAnalyticsModel> {
  const RevenueAnalyticsListResponse({
    super.message,
    super.data,
    super.meta,
  });

  factory RevenueAnalyticsListResponse.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsListResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? (json['data'] as List)
                .map((e) => RevenueAnalyticsModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        meta: json['meta'] != null
            ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
            : null,
      );
}
```

### Field Parsing Rules (MUST follow exactly)

| JSON Type | Dart Parsing | Example |
|-----------|-------------|---------|
| `String` | `json['key']?.toString()` | `json['id']?.toString()` |
| `int` | `json['key'] as int?` | `json['count'] as int?` |
| `double` | `double.tryParse(json['key']?.toString() ?? '')` | `double.tryParse(json['revenue']?.toString() ?? '')` |
| `bool` | `json['key'] as bool?` | `json['is_active'] as bool?` |
| `DateTime` | `DateTime.tryParse(json['key'].toString())` | `DateTime.tryParse(json['created_at'].toString())` |
| `Enum` | `json['key']?.toString().toEnumName()` | `json['status']?.toString().toSystemStatus()` |
| `Nested Object` | `json['key'] != null ? NestedModel.fromJson(json['key']) : null` | See pattern above |
| `List<Object>` | `(json['key'] as List).map((e) => Model.fromJson(e)).toList()` | See list pattern above |

### Naming Conventions

- **Dart fields**: `camelCase` (e.g., `storeId`, `bookingWindowMinutes`)
- **JSON keys**: `snake_case` (e.g., `store_id`, `booking_window_minutes`)
- **Model classes**: `PascalCase` + `Model` suffix (e.g., `RevenueAnalyticsModel`)
- **Response classes**: `PascalCase` + `Response` or `ListResponse` suffix
- **Files**: Group related models into logical files (e.g., `domain_analytics.dart`, `domain_admin.dart`)

### Output Format

Generate the models as **separate Dart files** in code blocks, one per file:

````markdown
### File: `lib/models/domain_analytics.dart`

```dart
import 'core.dart';
import 'enums.dart';

// ============================================================
// AnalyticsDashboardModel — Aggregated dashboard statistics
// ============================================================

class AnalyticsDashboardModel {
  ...
}
```

### File: `lib/models/domain_admin.dart`

```dart
import 'core.dart';
import 'enums.dart';
import 'domain_global.dart';

// ============================================================
// StoreConfigModel — Store configuration settings
// ============================================================

class StoreConfigModel {
  ...
}
```

### File: `lib/models/api_responses_admin.dart`

```dart
import 'core.dart';
import 'domain_admin.dart';
import 'domain_analytics.dart';

// Response wrappers for admin/analytics models
...
```
````

### Critical Rules

1. **Use the actual field names from your database schema** — look at `schema.md` and the actual API response shapes
2. **ALL fields must be nullable** (`Type?`) — the frontend uses safe parsing everywhere
3. **Use `const` constructors** — all model constructors must be `const`
4. **Import only existing model files** — `core.dart`, `enums.dart`, `domain_global.dart`, `domain_systems.dart`, `domain_billing.dart`, `domain_loyalty.dart`, `domain_misc.dart`
5. **Do NOT regenerate any model that already exists** (see the full list above)
6. **Include `fromJson` and `toJson`** on every single model — no exceptions
7. **Response wrappers must extend `SuccessResponse<T>` or `PaginatedSuccessResponse<T>`** from `core.dart`
8. **Group models logically** — analytics models together, admin config models together, response wrappers together

Read `schema.md` and `src/modules/` to understand the exact database field types before generating the models. Generate complete, ready-to-copy-paste Dart files.