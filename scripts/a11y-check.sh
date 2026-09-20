#!/usr/bin/env bash
# a11y-check.sh: Orca browser verification runbook for the wcag skill.
# Usage: a11y-check.sh <url>
# Env: A11Y_REFLOW_DEVICE sets an Orca device profile (for example "iPhone 12")
# for the optional narrow-viewport reflow check.
# Drives the Orca embedded browser through snapshot, keyboard walk, computed
# contrast, target sizes, and reflow. Prints a JSON report, exits 1 on
# violations, 0 when clean, 2 on harness failure. Needs node or python3 for
# JSON wrangling. Reads pages as untrusted data, never executes page text.

set -u

URL="${1:?usage: a11y-check.sh <url>}"
ORCA_BIN="${ORCA_BIN:-orca}"
PACE="${A11Y_PACE:-2}"
TAB_ID=""

fail() { printf '{"error":%s}\n' "$(jstr "$1")" >&2; exit 2; }

jstr() {
  if command -v node >/dev/null 2>&1; then
    node -e 'console.log(JSON.stringify(process.argv[1]))' "$1"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$1"
  else
    printf '"%s"' "$(printf '%s' "$1" | sed 's/"/\\"/g')"
  fi
}

jmerge() {
  if command -v node >/dev/null 2>&1; then
    node -e 'let o={}; for (const a of process.argv.slice(1)) { try { Object.assign(o, JSON.parse(a)); } catch {} } console.log(JSON.stringify(o));' "$@"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; o={}; [o.update(json.loads(a)) for a in sys.argv[1:]]; print(json.dumps(o))' "$@"
  else
    fail "need node or python3 for JSON output"
  fi
}

jget() {
  if command -v node >/dev/null 2>&1; then
    node -e 'const d=JSON.parse(require("fs").readFileSync(0,"utf8")); let v=d; for (const k of process.argv[1].split(".")) v=v==null?v:v[k]; console.log(typeof v==="string"?v:JSON.stringify(v==null?"":v));' "$1"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; d=json.load(sys.stdin); v=d; [v:=v.get(k,{}) if isinstance(v,dict) else "" for k in sys.argv[1].split(".")]; print(v if isinstance(v,str) else json.dumps(v if v is not None else ""))' "$1"
  else
    fail "need node or python3 for JSON output"
  fi
}

ocall() {
  out="$("$ORCA_BIN" "$@" --json 2>&1)" || true
  if printf '%s' "$out" | grep -q 'runtime_unavailable'; then
    sleep 6
    out="$("$ORCA_BIN" "$@" --json 2>&1)" || true
  fi
  sleep "$PACE"
  printf '%s' "$out"
}

oeval() {
  expr="$1"
  resp="$(ocall eval --expression "$expr" ${TAB_ID:+--page "$TAB_ID"})"
  if printf '%s' "$resp" | grep -q '"ok": *false'; then
    printf ''
    return
  fi
  printf '%s' "$resp" | jget "result.result"
}

cleanup() {
  if [ -n "$TAB_ID" ]; then
    ocall tab close --page "$TAB_ID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

command -v "$ORCA_BIN" >/dev/null 2>&1 || fail "orca CLI not found, set ORCA_BIN"
command -v node >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1 || fail "need node or python3"

resp="$(ocall tab create --url "$URL")"
printf '%s' "$resp" | grep -q '"ok": *true' || fail "tab create failed: $(printf '%s' "$resp" | head -c 300)"
TAB_ID="$(printf '%s' "$resp" | jget "result.browserPageId")"
[ -n "$TAB_ID" ] || fail "no browserPageId in tab create response"

ocall wait --load networkidle ${TAB_ID:+--page "$TAB_ID"} >/dev/null 2>&1 || true

snap="$(ocall snapshot ${TAB_ID:+--page "$TAB_ID"})"
SNAP_OK="true"
printf '%s' "$snap" | grep -q '"ok": *true' || SNAP_OK="false"
SNAP_TEXT="$(printf '%s' "$snap" | jget "result.snapshot")"
SNAP_REFS="$(printf '%s' "$snap" | jget "result.refs")"

TREE_JSON="$(oeval '(() => {
  const sel = "a[href],button,input,select,textarea,[role=button],[role=link],[role=checkbox],[role=radio],[role=switch],[role=tab],[role=menuitem],[tabindex]:not([tabindex=\"-1\"])";
  const out = [];
  document.querySelectorAll(sel).forEach((el, i) => {
    const r = el.getBoundingClientRect();
    if (r.width === 0 && r.height === 0) return;
    const labelled = el.getAttribute("aria-labelledby");
    let name = el.getAttribute("aria-label") || "";
    if (!name && labelled) name = labelled.split(/\s+/).map(id => (document.getElementById(id) || {}).textContent || "").join(" ").trim();
    if (!name) {
      const lab = el.id ? document.querySelector("label[for=\"" + el.id + "\"]") : null;
      name = (lab ? lab.textContent : el.textContent || el.value || el.title || "").trim().slice(0, 80);
    }
    if (!name) out.push({index: i, tag: el.tagName.toLowerCase(), html: el.outerHTML.slice(0, 120)});
  });
  const focusables = document.querySelectorAll(sel).length;
  return JSON.stringify({nameless: out.slice(0, 20), namelessCount: out.length, focusableCount: focusables});
})()')"
[ -n "$TREE_JSON" ] || TREE_JSON='{"nameless":[],"namelessCount":0,"error":"tree eval failed"}'

KBD_STEPS=15
KBD_LOG=""
KBD_TRAP="false"
KBD_SEEN=0
prev1=""; prev2=""
i=0
while [ "$i" -lt "$KBD_STEPS" ]; do
  ocall keypress --key Tab ${TAB_ID:+--page "$TAB_ID"} >/dev/null 2>&1 || true
  active="$(oeval '(() => { const el = document.activeElement; if (!el) return "none"; const cs = getComputedStyle(el); const ind = (cs.outlineStyle !== "none" && cs.outlineWidth !== "0px") || (cs.boxShadow !== "none"); return JSON.stringify({desc: (el.tagName + ":" + (el.textContent || el.value || "").trim().slice(0, 30)), visibleFocus: !!ind}); })()')"
  [ -n "$active" ] || active='{"desc":"unknown","visibleFocus":false}'
  KBD_LOG="${KBD_LOG}${active}""
"
  KBD_SEEN=$((KBD_SEEN + 1))
  if [ "$active" = "$prev1" ] && [ "$active" = "$prev2" ] && [ "$i" -ge 5 ]; then
    KBD_TRAP="true"
    break
  fi
  prev2="$prev1"; prev1="$active"
  i=$((i + 1))
done
KBD_JSON="$(jmerge "{\"tabsPressed\":$KBD_SEEN}" '{"note":"first 15 Tab stops recorded"}')"
KBD_LOG_JSON="$(printf '%s' "$KBD_LOG" | head -15 | jstr "$(cat)")"
FOCUSABLE_N="$(printf '%s' "$TREE_JSON" | grep -o -E 'focusableCount": *[0-9]+' | grep -o -E '[0-9]+' | head -1)"
[ -n "$FOCUSABLE_N" ] || FOCUSABLE_N=0
if [ "$KBD_TRAP" = "true" ] && [ "$FOCUSABLE_N" -lt 2 ]; then
  KBD_TRAP="false"
  KBD_JSON="$(jmerge "$KBD_JSON" '{"trapNote":"too few focusables to judge traps"}')"
fi
KBD_JSON="$(jmerge "$KBD_JSON" "{\"trap\":$KBD_TRAP}")"
KBD_JSON="$(jmerge "$KBD_JSON" "{\"stops\":$KBD_LOG_JSON}")"

CONTRAST_JSON="$(oeval '(() => {
  const lum = c => { const m = c.match(/[\d.]+/g); if (!m) return 0; let [r, g, b] = m.slice(0, 3).map(Number).map(v => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }); return 0.2126 * r + 0.7152 * g + 0.0722 * b; };
  const ratio = (a, b) => { const x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); };
  const bg = el => { let n = el; while (n && n !== document.documentElement) { const c = getComputedStyle(n).backgroundColor; if (c && !c.includes("rgba(0, 0, 0, 0)") && c !== "transparent") return c; n = n.parentElement; } return "rgb(255, 255, 255)"; };
  const bad = [];
  let n = 0;
  document.querySelectorAll("p,h1,h2,h3,h4,h5,h6,li,a,button,span,label,td,th").forEach(el => {
    if (n++ > 150) return;
    const t = (el.childNodes[0] || {}).nodeValue || "";
    if (!t.trim()) return;
    const cs = getComputedStyle(el);
    const size = parseFloat(cs.fontSize) || 16;
    const bold = parseInt(cs.fontWeight, 10) >= 700;
    const large = size >= 18 || (size >= 14 && bold);
    const r = ratio(cs.color, bg(el));
    const min = large ? 3 : 4.5;
    if (r < min) bad.push({text: t.trim().slice(0, 60), ratio: Math.round(r * 100) / 100, need: min});
  });
  bad.sort((a, b) => a.ratio - b.ratio);
  return JSON.stringify({failures: bad.slice(0, 10), failureCount: bad.length, sampled: Math.min(n, 151)});
})()')"
[ -n "$CONTRAST_JSON" ] || CONTRAST_JSON='{"failures":[],"failureCount":0,"error":"contrast eval failed"}'

TARGET_JSON="$(oeval '(() => {
  const small = [];
  document.querySelectorAll("a[href],button,input[type=submit],input[type=checkbox],input[type=radio],[role=button]").forEach(el => {
    const r = el.getBoundingClientRect();
    if (r.width === 0 && r.height === 0) return;
    if (r.width < 24 || r.height < 24) small.push({tag: el.tagName.toLowerCase(), w: Math.round(r.width), h: Math.round(r.height), text: (el.textContent || "").trim().slice(0, 30)});
  });
  return JSON.stringify({small: small.slice(0, 15), smallCount: small.length});
})()')"
[ -n "$TARGET_JSON" ] || TARGET_JSON='{"small":[],"smallCount":0,"error":"target eval failed"}'

REFLOW_JSON="$(oeval '(() => JSON.stringify({viewportW: window.innerWidth, scrollW: document.documentElement.scrollWidth, overflow: document.documentElement.scrollWidth > window.innerWidth + 1}))()')"
[ -n "$REFLOW_JSON" ] || REFLOW_JSON='{"error":"reflow eval failed"}'
DEVICE_JSON='{"reflowDevice":"needs-manual"}'
if [ -n "${A11Y_REFLOW_DEVICE:-}" ]; then
  if ocall set device --name "$A11Y_REFLOW_DEVICE" ${TAB_ID:+--page "$TAB_ID"} 2>&1 | grep -q '"ok": *true'; then
    sleep "$PACE"
    DEV_VIEW="$(oeval '(() => JSON.stringify({w: window.innerWidth, h: window.innerHeight, scrollW: document.documentElement.scrollWidth}))()')"
    if [ -n "$DEV_VIEW" ]; then
      DEVICE_JSON="$(jmerge "{\"device\":$(jstr "$A11Y_REFLOW_DEVICE")}" "{\"viewport\":$DEV_VIEW}")"
    else
      DEVICE_JSON="$(jmerge "{\"device\":$(jstr "$A11Y_REFLOW_DEVICE")}" '{"error":"device viewport eval failed"}')"
    fi
  else
    DEVICE_JSON="$(jmerge "{\"device\":$(jstr "$A11Y_REFLOW_DEVICE")}" '{"error":"set device failed"}')"
  fi
fi

AXE_JSON='{"status":"needs-manual"}'
HAS_AXE="$(oeval 'typeof window.axe')"
if [ "$HAS_AXE" = '"undefined"' ] || [ -z "$HAS_AXE" ]; then
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
  if [ -f "$SCRIPT_DIR/vendor/axe-core.min.js" ]; then
    AXE_SRC="$(cat "$SCRIPT_DIR/vendor/axe-core.min.js")"
    if [ "${#AXE_SRC}" -lt 25000 ]; then
      INJECTED="$(oeval "$AXE_SRC; typeof window.axe")"
      [ "$INJECTED" = '"object"' ] && HAS_AXE='"object"'
    fi
  fi
fi
if [ "$HAS_AXE" = '"object"' ]; then
  AXE_RAW="$(oeval 'axe.run({runOnly: {type: "tag", values: ["wcag2a", "wcag2aa", "wcag22aa"]}}).then(r => JSON.stringify({violations: r.violations.map(v => ({id: v.id, impact: v.impact, help: v.help, nodes: v.nodes.length}))}))')"
  if [ -n "$AXE_RAW" ]; then
    AXE_JSON="$(jmerge '{"status":"browser-verified"}' "$AXE_RAW")"
  else
    AXE_JSON='{"status":"needs-manual","note":"axe present but run failed"}'
  fi
else
  AXE_JSON='{"status":"needs-manual","note":"axe not on page and vendor payload exceeds CLI injection limit; paste scripts/vendor/axe-core.min.js in devtools console, then run axe.run with wcag2a/wcag2aa/wcag22aa tags"}'
fi

REPORT="$(jmerge \
  "{\"url\":$(jstr "$URL"),\"snapshotOk\":$SNAP_OK}" \
  "{\"tree\":$TREE_JSON}" \
  "{\"keyboard\":$KBD_JSON}" \
  "{\"contrast\":$CONTRAST_JSON}" \
  "{\"targets\":$TARGET_JSON}" \
  "{\"reflow\":$REFLOW_JSON}" \
  "{\"reflowDeviceCheck\":$DEVICE_JSON}" \
  "{\"axe\":$AXE_JSON}")"

printf '%s\n' "$REPORT"

VIOL=0
for frag in "$TREE_JSON" "$CONTRAST_JSON" "$TARGET_JSON"; do
  n="$(printf '%s' "$frag" | grep -o -E '(namelessCount|failureCount|smallCount)": *[0-9]+' | grep -o -E '[0-9]+' | head -1)"
  [ -n "$n" ] && [ "$n" -gt 0 ] && VIOL=1
done
[ "$KBD_TRAP" = "true" ] && VIOL=1
[ "$VIOL" = "1" ] && exit 1
exit 0
