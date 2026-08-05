# Offensive Security Stack — Proven Install Recipes

Working commands validated end-to-end (Ubuntu 24.04, Python 3.12). Use these
instead of guessing. Each recipe ends with a verification command that MUST
pass before moving on.

## 1. System RE tools (apt)

```bash
sudo apt-get update -qq
sudo apt-get install -y -qq radare2 gdb binutils binwalk strace ltrace
r2 -v && gdb --version | head -1 && ltrace --version | head -1
```

## 2. JDK 21 (required by Ghidra; JADX/Apktool work with 17+)

```bash
sudo apt-get install -y -qq openjdk-21-jdk-headless
java -version  # expect "openjdk version 21.x"
```

## 3. Go + bug-bounty tools

```bash
GOVER=$(curl -s https://go.dev/VERSION?m=text | head -1)
wget -q https://go.dev/dl/${GOVER}.linux-amd64.tar.gz -O /tmp/go.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

CRITICAL PITFALL: `go install A@latest B@latest C@latest` FAILS with
"All packages must be provided by the same module". Install ONE tool per
command:

```bash
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/owasp-amass/amass/v4/...@latest   # verified: amass v4.2.0
ls ~/go/bin/   # verify binaries landed
```

NOTE: the `...@latest` wildcard (amass form) works fine — the multi-module
failure above only applies to listing multiple DISTINCT modules in ONE
`go install` invocation. Amass compiles slowly (~5 min) → background process.

These compiles take minutes each — run as background process with
`notify_on_complete=true` and do other work in parallel.

## 4. Python RE frameworks (single pip call)

```bash
pip3 install --break-system-packages angr unicorn capstone frida frida-tools pwntools
python3 -c "import angr, unicorn, capstone, frida, pwn; print('all ok')"
```

NOTE: `ghidra-mlc` does NOT exist on PyPI — do not include it. Frida
dynamic instrumentation works out of the box on Linux x86_64.

## 5. JADX v1.5.6 (APK decompiler)

The release zip extracts to top-level `bin/` and `lib/` — NOT `jadx/bin/`.

```bash
sudo mkdir -p /opt/jadx && cd /opt/jadx
wget -q https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
sudo unzip -oq jadx-1.5.6.zip && rm jadx-1.5.6.zip
sudo chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui
sudo ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
sudo ln -sf /opt/jadx/bin/jadx-gui /usr/local/bin/jadx-gui
jadx --version   # expect "1.5.6"
```

## 6. Apktool v2.9.3

```bash
sudo mkdir -p /opt/apktool
sudo wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar -O /opt/apktool/apktool.jar
sudo tee /usr/local/bin/apktool > /dev/null << 'EOF'
#!/bin/bash
exec java -jar /opt/apktool/apktool.jar "$@"
EOF
sudo chmod +x /usr/local/bin/apktool
apktool --version   # expect "2.9.3"
```

## 7. Ghidra — ALWAYS resolve version via GitHub API first

PITFALL: hardcoded Ghidra release URLs rot fast (Ghidra_11.2.5 asset was
already 404). Get the current release dynamically:

```bash
curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['assets'][0]['browser_download_url'])"
```

Then download (500MB+, background process, `--max-time 1800`) and extract:

```bash
sudo unzip -oq /tmp/ghidra.zip -d /opt/
GVER=$(ls -d /opt/ghidra_*_PUBLIC)
sudo ln -sf $GVER/support/analyzeHeadless /usr/local/bin/ghidra-headless
sudo ln -sf $GVER/ghidraRun /usr/local/bin/ghidra
```

## 8. Browser fingerprint generation

```bash
pip3 install --break-system-packages browserforge[all] fpgen
fpgen fetch          # downloads model from GitHub
fpgen decompress     # optional: 10-50x faster at runtime, ~100MB disk
python3 -c "import browserforge, fpgen; print('ok')"
```

## 9. CAPTCHA solver suite

```bash
git clone https://github.com/sanhaji182/captcha-solvers-toolkit /root/captcha-suite/captcha-solvers-toolkit
# includes: capsolver, cf-turnstile-solver-2026, aliyun-slider, pierrondi-solver, turnstile-solver, 9r-bulk-add
```

## 10. Environment persistence

Sandboxed terminal calls do NOT inherit new PATH entries. Write once:

```bash
cat > ~/.hermes.env << 'EOF'
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:/opt/jadx/bin
export HERMES_SKILLS_DIR=~/.hermes/skills
export GHIDRA_HOME=/opt/ghidra_*_PUBLIC   # fix glob to real path
export JADX_HOME=/opt/jadx
export APKTOOL_HOME=/opt/apktool
EOF
grep -q 'go/bin' ~/.bashrc || echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
```

## Known repo quirks (re-check before concluding dead)

- `github.com/dhikadrian/guardx` — was 404 earlier on 2026-08-05, returned
  live later same day. Repo ships a single `guardx.zip` at root; clone,
  unzip, then work inside the extracted `guardx/` dir. Full recipe in
  `references/guardx-deployment.md`.

## Parallel-install orchestration pattern

Long installs in one shot time out. The pattern that worked:

1. Kick each long install as `terminal(background=true, notify_on_complete=true)`
2. Run short synchronous installs in the foreground between polls
3. `process(action='poll')` each background job when notified
4. Final sweep: one verification command per tool, table-format output
   to Autumn showing ✅/❌ per component
