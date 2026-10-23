#!/usr/bin/env python3

import sys, os, subprocess, webbrowser, time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

f = sys.argv[1]
js = r'<script>new EventSource("/e").onmessage=async()=>{let t=await(await fetch("/",{cache:"no-store"})).text();document.body.innerHTML=new DOMParser().parseFromString(t,"text/html").body.innerHTML;window.renderMathInElement&&renderMathInElement(document.body,{delimiters:[{left:"\\(",right:"\\)",display:false},{left:"\\[",right:"\\]",display:true}]})}</script>'

class H(BaseHTTPRequestHandler):
    def do_GET(s):
        s.send_response(200)
        if s.path == "/e":
            # SSE stream: push an event whenever the file mtime changes
            s.send_header("Content-Type", "text/event-stream"); s.end_headers()
            m = os.stat(f).st_mtime_ns
            try:
                while True:
                    time.sleep(0.2)
                    n = os.stat(f).st_mtime_ns
                    if n != m: m = n; s.wfile.write(b"data: 1\n\n"); s.wfile.flush()
            except (BrokenPipeError, ConnectionResetError): return
        b = subprocess.run(["pandoc", f, "-s", "--katex", "--metadata", "pagetitle=" + f, "-H", "/dev/stdin"], input=js.encode(), capture_output=True).stdout
        s.send_header("Content-Type", "text/html; charset=utf-8"); s.end_headers(); s.wfile.write(b)
    def log_message(*a): pass

s = ThreadingHTTPServer(("127.0.0.1", 8000), H)
webbrowser.open("http://localhost:8000")
try: s.serve_forever()
except KeyboardInterrupt: pass
