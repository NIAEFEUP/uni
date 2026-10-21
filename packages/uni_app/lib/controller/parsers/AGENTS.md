## Parsers

All parsers extract data from SIGARRA HTTP responses and return typed entities. There are two response formats — HTML and JSON — each with different patterns and risks.

---

### General HTML parsing pattern

```dart
import 'package:html/parser.dart' show parse;

Future<List<T>> parseXyz(http.Response response) async {
  final document = parse(response.body);

  final rows = document.querySelectorAll('table.tabela-longa > tbody > tr');
  // ...extract data from rows...
}
```

**The critical fragility:** all CSS selectors are hardcoded strings. If SIGARRA changes its HTML structure, the parser returns an **empty list silently** — no exception is thrown. This makes regressions hard to detect without real responses.

Always test parsers with HTML captured from the real SIGARRA page, not synthetic mock HTML. The existing test fixtures in `test/` follow this pattern.

---

### JSON parsing pattern

Used for the schedule (`parsers/schedule/api/` and `parsers/schedule/new_api/`).

```dart
import 'dart:convert';

final json = jsonDecode(response.body) as Map<String, dynamic>;
```

**`aula_duracao` type ambiguity (schedule/api/parser.dart):** SIGARRA returns this field as `int` for whole-hour durations and `double` for fractional ones. Never cast directly:

```dart
// ✅
final lectureDuration = lecture['aula_duracao'];
final blocks = lectureDuration is double
    ? (lectureDuration * 2).toInt()
    : (lectureDuration as int) * 2;

// ❌ will throw on 1.5-hour lectures
final blocks = (lecture['aula_duracao'] as int) * 2;
```

---

### Multi-endpoint merge pattern

`parser_course_units.dart` combines data from **two** separate HTTP responses:

- `responseAcademicPath` — the student's academic path table (`#tabelapercurso`)
- `responseCurricularUnits` — the curricular units page (used only to extract `pv_ocorrencia_id`)

The first step builds an `occurIdMap` keyed by `"$codeName|$schoolYear"` from the curricular units page. Rows from the academic path are then enriched with that ID. If you add a new field that lives in only one of these responses, make sure you know which document to query.

---

### Dual HTML structure pattern

`parser_courses.dart` parses two separate HTML sections for the same data:
- `.estudantes-caixa-lista-cursos` — used for FEUP-style pages
- `.tabela-longa` — used for other faculties

If SIGARRA changes the markup for one faculty, the other may still work. When debugging a missing course, check both branches.

---

### When to create a new parser vs. extend an existing one

- **New parser** — if the data comes from a different SIGARRA page/endpoint
- **Extend** — if the data is on the same page but a new field needs extracting

File naming convention: `parser_{feature}.dart`. For features with multiple response formats (e.g. schedule), use a subdirectory: `schedule/api/parser.dart`, `schedule/new_api/parser.dart`.

---

### Testing parsers

Mock with a real `http.Response` built from captured SIGARRA HTML:

```dart
final html = File('test/fixtures/schedule.html').readAsStringSync();
final response = http.Response(html, 200);
final lectures = await parseSchedule(response, week);
expect(lectures, isNotEmpty);
```

Never assert on exact field counts — SIGARRA data changes per user. Assert on types and non-null required fields instead.
