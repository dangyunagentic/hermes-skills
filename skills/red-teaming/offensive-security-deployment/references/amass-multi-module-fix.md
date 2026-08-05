# Go Multi-Module Install Fix (amass / nuclei / subfinder)

## The Problem

Running `go install` with multiple packages from DIFFERENT modules in one command fails:

```bash
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest \
           github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest \
           github.com/owasp-amass/amass/v4/...@latest
# ERROR: All packages must be provided by the same module
```

Go requires all packages in a single `go install` invocation to belong to the same module. Each bug bounty tool is its own module → must install separately.

Also note: amass uses the `...@latest` pattern (install all packages under the module root), while projectdiscovery tools need the explicit `/cmd/<tool>@latest` path.

## The Fix: GO_TOOLS Array (one-by-one)

```bash
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

GO_TOOLS=(
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/katana/cmd/katana@latest"
    "github.com/owasp-amass/amass/v4/...@latest"
)
for tool in "${GO_TOOLS[@]}"; do
    name=$(basename "$(echo "$tool" | sed 's|@.*||;s|/cmd.*||;s|/v[0-9].*||')")
    echo "   -> $name"
    go install -v "$tool" 2>&1 | tail -1 || echo "   $name failed"
done
```

Binaries land in `~/go/bin`. Add to PATH persistently:

```bash
grep -q 'go/bin' ~/.bashrc || \
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
```

## Practical Notes

- amass compile takes ~5-10 min (large dependency tree) — run in background process (`background=true, notify_on_complete=true`) and do other work in parallel.
- Each `go install` is independent and idempotent; safe to re-run on failure.
- If a tool fails (e.g. GitHub rate-limit during dep fetch), retry just that one — don't restart the whole list.
- Verified working set (Aug 2026): nuclei v3.11.0, subfinder v2.6.4, httpx v1.9.0, katana v1.6.1, amass v4.2.0 — all on Go 1.26.5.
- Full recon flow chaining these tools:

```bash
amass enum -d target.com -o amass.txt
subfinder -d target.com -o subfinder.txt
cat amass.txt subfinder.txt | sort -u | httpx -o live.txt
katana -list live.txt -o urls.txt
nuclei -l live.txt -automatic-scan
```
