#!/usr/bin/env python3

import sys, os, json, subprocess, webbrowser, time, mimetypes
from urllib.parse import urlparse, parse_qs, unquote
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

f = os.path.realpath(sys.argv[1])
cwd = os.path.realpath(os.getcwd())
MD = (".md", ".markdown")

css = '''<style>
body {
  max-width: 64em;
  padding-left: 2em;
  padding-right: 2em;
}
h1, h2, h3, h4, h5, h6 {
  color: #1f4e8c;
}
h1 {
  padding-bottom: 0.3em;
  border-bottom: 3px solid #4a90d9;
}
h2 {
  padding: 0.2em 0.5em;
  border-left: 6px solid #4a90d9;
  background: #eef4fb;
}
h3 {
  padding-left: 0.5em;
  border-left: 4px solid #9cc3ea;
}

div.sourceCode {
  background: transparent;
}
pre {
  padding: 0.8em 1em;
  border: 1px solid #d0d7de;
  border-radius: 6px;
  background: #f6f8fa;
}
.code-lang {
  margin-top: 1em;
  padding: 0.25em 0.9em;
  border: 1px solid #d0d7de;
  border-bottom: none;
  border-radius: 6px 6px 0 0;
  background: #e3eaf3;
  color: #1f4e8c;
  font: 600 0.8em/1.4 monospace;
}
div.sourceCode > .code-lang {
  margin-top: 0;
}
.code-lang + pre {
  margin-top: 0;
  border-radius: 0 0 6px 6px;
}
:not(pre) > code {
  padding: 0.15em 0.4em;
  border-radius: 4px;
  background: #eef1f5;
}

#crumbs button.toc {
  margin-left: auto;
  color: #8c959f;
}
#crumbs button.toc:hover,
#crumbs button.toc.open {
  color: #1f4e8c;
}
#crumbs .tocbox {
  position: absolute;
  top: 100%;
  right: 0;
  z-index: 10;
  min-width: 16em;
  max-width: 28em;
  max-height: 60vh;
  overflow-y: auto;
  margin-top: 0.3em;
  padding: 0.4em 0.8em;
  border: 1px solid #d0d7de;
  border-radius: 6px;
  background: #fff;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.12);
}
#TOC ul {
  margin: 0.2em 0;
  padding-left: 1.2em;
  list-style: none;
}
#TOC > ul {
  padding-left: 0;
}
#TOC a {
  color: #24292f;
  text-decoration: none;
}
#TOC a:hover {
  color: #1f4e8c;
  text-decoration: underline;
}

#crumbs {
  position: relative;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.2em;
  margin-bottom: 1.5em;
  padding-bottom: 0.6em;
  border-bottom: 1px solid #d0d7de;
  font: 1em/1.4 ui-monospace, "DejaVu Sans Mono", monospace;
}
#crumbs button {
  padding: 0.15em 0.5em;
  border: none;
  border-radius: 4px;
  background: none;
  color: #1f4e8c;
  font: inherit;
  cursor: pointer;
}
#crumbs button:hover,
#crumbs button.open {
  background: #eef4fb;
}
#crumbs button.file {
  font-weight: 700;
}
#crumbs .sep {
  color: #8c959f;
}
#crumbs .menu {
  position: absolute;
  top: 100%;
  z-index: 10;
  min-width: 14em;
  max-height: 60vh;
  overflow-y: auto;
  margin-top: 0.3em;
  padding: 0.3em;
  border: 1px solid #d0d7de;
  border-radius: 6px;
  background: #fff;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.12);
}
#crumbs .menu .menu {
  position: static;
  min-width: 0;
  max-height: none;
  margin: 0 0 0 1em;
  padding: 0;
  border: none;
  box-shadow: none;
}
#crumbs .item {
  display: block;
  padding: 0.2em 0.6em;
  border-radius: 4px;
  color: #24292f;
  text-decoration: none;
  white-space: nowrap;
  cursor: pointer;
}
#crumbs .item:hover {
  background: #eef4fb;
}
#crumbs .item.cur {
  color: #1f4e8c;
  font-weight: 700;
}
#crumbs .item.dir::before {
  content: "\\25B8  ";
  color: #8c959f;
}
#crumbs .item.dir.open::before {
  content: "\\25BE  ";
}
#crumbs .empty {
  padding: 0.2em 0.6em;
  color: #8c959f;
}
</style>'''

js = r'''<script>
const label = () => {
  const skip = ["sourceCode", "numberSource", "numberLines", "number-lines"];
  document.querySelectorAll("pre").forEach(pre => {
    const lang = [...pre.classList].find(c => !skip.includes(c));
    if (!lang) return;
    const tag = document.createElement("div");
    tag.className = "code-lang";
    tag.textContent = lang;
    pre.before(tag);
  });
};

const el = (tag, cls, text) => {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};

const fill = async (menu, dir) => {
  const res = await fetch("/ls?d=" + encodeURIComponent(dir));
  const items = await res.json();
  if (!items.length) menu.append(el("div", "empty", "(empty)"));
  for (const it of items) {
    if (it.dir) {
      const row = el("div", "item dir", it.name);
      const sub = el("div", "menu");
      sub.hidden = true;
      row.onclick = async e => {
        e.stopPropagation();
        sub.hidden = !sub.hidden;
        row.classList.toggle("open", !sub.hidden);
        if (!sub.hidden && !sub.childElementCount) await fill(sub, it.path);
      };
      menu.append(row, sub);
    } else {
      const a = el("a", "item", it.name);
      a.href = "/?f=" + encodeURIComponent(it.path);
      if (it.path === CRUMBS.cur) a.classList.add("cur");
      menu.append(a);
    }
  }
};

const crumbs = el("nav");
crumbs.id = "crumbs";

const tocBtn = el("button", "toc", "\u2630");
tocBtn.title = "TOC";
const tocBox = el("div", "tocbox");
tocBox.hidden = true;
tocBox.onclick = e => { if (!e.target.closest("a")) e.stopPropagation(); };

const closeMenu = () => {
  crumbs.querySelectorAll(".menu").forEach(m => m.remove());
  crumbs.querySelectorAll("button.open").forEach(b => b.classList.remove("open"));
  tocBox.hidden = true;
};

tocBtn.onclick = e => {
  e.stopPropagation();
  const was = !tocBox.hidden;
  closeMenu();
  tocBox.hidden = was;
  tocBtn.classList.toggle("open", !was);
};

const mount = () => {
  tocBox.replaceChildren();
  document.body.prepend(crumbs);
  const t = document.getElementById("TOC");
  if (t) tocBox.append(t);
  tocBtn.hidden = !t;
  label();
};

const addCrumb = (name, dir, cls) => {
  const b = el("button", cls, name);
  b.onclick = async e => {
    e.stopPropagation();
    const was = b.classList.contains("open");
    closeMenu();
    if (was) return;
    b.classList.add("open");
    const menu = el("div", "menu");
    menu.style.left = b.offsetLeft + "px";
    crumbs.append(menu);
    await fill(menu, dir);
  };
  crumbs.append(b);
};

CRUMBS.dirs.forEach(d => {
  addCrumb(d.name, d.path);
  crumbs.append(el("span", "sep", ">"));
});
addCrumb(CRUMBS.file, CRUMBS.parent, "file");
crumbs.append(tocBtn, tocBox);

document.addEventListener("click", closeMenu);

document.addEventListener("click", e => {
  if (e.target.matches("input[type=checkbox]")) e.preventDefault();
});

document.addEventListener("DOMContentLoaded", mount);

new EventSource("/e?f=" + encodeURIComponent(CRUMBS.cur)).onmessage = async () => {
  let t = await (await fetch(location.href, {cache: "no-store"})).text();
  document.body.innerHTML = new DOMParser().parseFromString(t, "text/html").body.innerHTML;
  mount();
  document.querySelectorAll(".math").forEach(m => {
    const tex = m.textContent.replace(/^\\\(|\\\)$|^\\\[|\\\]$/g, "");
    window.katex && katex.render(tex, m, {displayMode: m.classList.contains("display"), throwOnError: false});
  });
}
</script>'''


def crumbs(path):
    home = os.path.expanduser("~")
    if path.startswith(cwd + os.sep):
        base, name = cwd, os.path.basename(cwd) or "/"
        parts = path[len(cwd) + 1:].split(os.sep)
    elif path.startswith(home + os.sep):
        base, name = home, "~"
        parts = path[len(home) + 1:].split(os.sep)
    else:
        base, name = "/", "/"
        parts = path.lstrip("/").split("/")

    dirs = [{"name": name, "path": base}]
    acc = base
    for p in parts[:-1]:
        acc = os.path.join(acc, p)
        dirs.append({"name": p, "path": acc})

    return {
        "dirs": dirs,
        "file": parts[-1],
        "parent": os.path.dirname(path),
        "cur": path,
    }


def head(path):
    data = json.dumps(crumbs(path)).replace("<", "\\u003c")
    return css + "<script>const CRUMBS = " + data + ";</script>" + js


def listdir(d):
    out = []
    try:
        names = sorted(os.listdir(d), key=str.lower)
    except OSError:
        return out
    for n in names:
        p = os.path.join(d, n)
        if n.startswith("."):
            continue
        if os.path.isdir(p):
            out.append({"name": n, "path": p, "dir": True})
    for n in names:
        p = os.path.join(d, n)
        if not n.startswith(".") and n.lower().endswith(MD) and os.path.isfile(p):
            out.append({"name": n, "path": p, "dir": False})
    return out


class H(BaseHTTPRequestHandler):
    def do_GET(s):
        u = urlparse(s.path)
        q = parse_qs(u.query)

        if u.path == "/ls":
            d = os.path.realpath(q.get("d", ["/"])[0])
            b = json.dumps(listdir(d)).encode()
            s.send_response(200)
            s.send_header("Content-Type", "application/json")
            s.end_headers()
            s.wfile.write(b)
            return

        if u.path not in ("/", "/e"):
            r = parse_qs(urlparse(s.headers.get("Referer", "")).query)
            # resolve relative to the directory of the markdown file being viewed
            p = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(r["f"][0]) if "f" in r else f), unquote(u.path).lstrip("/")))
            if not os.path.isfile(p):
                s.send_error(404)
                return
            s.send_response(200)
            s.send_header("Content-Type", mimetypes.guess_type(p)[0] or "application/octet-stream")
            s.end_headers()
            s.wfile.write(open(p, "rb").read())
            return

        path = os.path.realpath(q["f"][0]) if "f" in q else f
        if not path.lower().endswith(MD) or not os.path.isfile(path):
            s.send_error(404)
            return

        s.send_response(200)

        if u.path == "/e":
            s.send_header("Content-Type", "text/event-stream")
            s.end_headers()
            m = os.stat(path).st_mtime_ns
            try:
                while True:
                    time.sleep(0.2)
                    try:
                        n = os.stat(path).st_mtime_ns
                    except OSError:
                        continue
                    if n != m:
                        m = n
                        s.wfile.write(b"data: 1\n\n")
                        s.wfile.flush()
            except (BrokenPipeError, ConnectionResetError):
                return

        b = subprocess.run(
            ["pandoc", path, "-s", "--toc", "--toc-depth=3", "--katex", "--metadata", "pagetitle=" + os.path.basename(path), "-H", "/dev/stdin"],
            input=head(path).encode(),
            capture_output=True,
        ).stdout

        s.send_header("Content-Type", "text/html; charset=utf-8")
        s.end_headers()
        s.wfile.write(b)

    def log_message(*a):
        pass


s = ThreadingHTTPServer(("127.0.0.1", 8000), H)
webbrowser.open("http://localhost:8000")

try:
    s.serve_forever()
except KeyboardInterrupt:
    pass
