# Behavioural Tests — /security-agent

> Format: GIVEN / WHEN / THEN  
> Status: SPECIFIED — not yet dry-run verified (L1)

---

## BT-SA-01: Runs on every phase, not only auth phases

GIVEN a phase that adds a utility function with no auth or data access  
WHEN `/security-agent` is invoked  
THEN Claude still runs the full OWASP checklist and stack-specific checks against the diff.  
AND Claude does not skip the review because the phase "isn't security-relevant".

---

## BT-SA-02: Hardcoded secret is Critical/blocking

GIVEN the diff contains a hardcoded API key (e.g., `const API_KEY = "sk-..."`)  
WHEN Claude reviews the diff  
THEN the finding is `issue (blocking, security)` with the file and line number.  
AND the finding is tagged `*(source: security-agent)*`.

---

## BT-SA-03: Missing auth dependency on FastAPI endpoint is Critical/blocking

GIVEN a new FastAPI route is added without `Depends(get_current_user)` or equivalent  
WHEN Claude reviews the diff  
THEN the finding is `issue (blocking, security)` citing the endpoint path and file location.

---

## BT-SA-04: CORS wildcard with credentials is High/blocking

GIVEN `allow_origins=["*"]` is set alongside `allow_credentials=True` in FastAPI CORS config  
WHEN Claude reviews the diff  
THEN the finding is `issue (blocking, security)`.

---

## BT-SA-05: dangerouslySetInnerHTML with user content is Critical/blocking

GIVEN a React component renders `dangerouslySetInnerHTML={{ __html: userInput }}` without sanitisation  
WHEN Claude reviews the diff  
THEN the finding is `issue (blocking, security)` citing the component file and line.

---

## BT-SA-06: NEXT_PUBLIC_ variable containing a secret is Critical/blocking

GIVEN the diff introduces `NEXT_PUBLIC_SECRET_KEY` in `.env` or code  
WHEN Claude reviews the diff  
THEN the finding is `issue (blocking, security)` noting that `NEXT_PUBLIC_` vars are exposed to the browser.

---

## BT-SA-07: Missing security headers is Medium/non-blocking

GIVEN a new Express/FastAPI/Next.js API endpoint is added  
AND no security headers (CSP, X-Frame-Options, etc.) are set  
WHEN Claude reviews the diff  
THEN the finding is `suggestion (non-blocking, security)`.

---

## BT-SA-08: Unhandled 422 schema leakage in FastAPI is Medium/non-blocking

GIVEN a FastAPI route has no custom error handler for 422 validation errors  
AND the default Pydantic schema would be exposed in error responses  
WHEN Claude reviews the diff  
THEN the finding is `suggestion (non-blocking, security)`.

---

## BT-SA-09: No findings produces praise, not silence

GIVEN the diff contains no detectable security issues after full checklist review  
WHEN Claude completes the review  
THEN Claude returns exactly one `praise` line: "No security issues found in this diff."  
AND no empty response is returned.

---

## BT-SA-10: Findings tagged with source agent

GIVEN any finding is produced  
WHEN the finding is formatted  
THEN every finding line ends with `*(source: security-agent)*`.

---

## BT-SA-11: Uncertain severity defaults to blocking

GIVEN a finding could be Critical or Medium depending on context Claude cannot determine from the diff alone  
WHEN Claude formats the finding  
THEN Claude defaults to `issue (blocking, security)` and adds a note explaining the uncertainty.  
AND Claude does not silently downgrade to non-blocking.
