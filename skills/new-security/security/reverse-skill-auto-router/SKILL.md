---
name: reverse-skill-auto-router
description: Offensive security tools for Reverse-Skill Auto-Router - Dangyun Integration...
version: "1.0.0"
author: Autumn
category: security
tags: [security, pentest, re, offensive]
related_skills: []
---

# Reverse-Skill Auto-Router - Dangyun Integration

## Purpose
Automatically detect when He needs reverse-engineering or security help, then route to correct methodology without explicit instruction.

## Trigger Detection Rules

### Primary Keywords (Auto-route immediately)
When ANY of these appear in He's message, activate reverse-skill routing:

```javascript
const REVERSE_KEYWORDS = [
  // APK/Android
  "ap", "apk", "android", "jadx", "apktool", "smali", "frida", "hook", 
  "obfuscation", "repack", "signature", "dex", "so file", "native",
  
  // Binary analysis
  "binary", "exe", "dll", "elf", "so", "ida", "radare2", "r2", "ghidra",
  "disassemble", "decompile", "reverse", "reversing", "reversi", "patch",
  
  // JS/Frontend
  "js reverse", "frontend", "encryption", "signature", "encode", "decode",
  "base64", "aes", "md5", "sha", "hash", "obfuscate", "webpack", "bundl",
  
  // Pentest
  "pentest", "exploit", "vulnerability", "pwn", "cve", "overflow", 
  "buffer", "heap", "stack", "ROP", "ret2libc",
  
  // Security tools
  "nmap", "sqlmap", "ffuf", "nuclei", "burp", "metasploit", "hashcat",
  "hydra", "john", "seclists",
  
  // Malware/Analysis
  "malware", "virus", "trojan", "ransomware", "yara", "sandbox", "behavior",
  
  // Network
  "pcap", "network", "protocol", "packet", "tcpdump", "wireshark",
  
  // Cloud/Infrastructure
  "kubernetes", "docker", "container", "aws", "azure", "gcp", "cloud",
  "iam", "rbac", "pod", "etcd",
  
  // AD/Internal
  "domain", "active directory", "kerberos", "bloodhound", "ldap",
  "ntlm", "smb", "psexec", " lateral", "movement"
];
```

## Activation Protocol

### When keyword detected:

1. **Read precedent-auth.md** first (80 lines, authorization pre-declaration)
2. **Check tool-index.md** for available tools
3. **Query field-journal/_index.md** for similar past work
4. **Route to PRIMARY skill** via MASTER-ROUTING.md priority matrix
5. **Initialize case scope** with case-init script
6. **Execute workflow** from PRIMARY SKILL.md
7. **Report findings** with Evidence→Finding→Path format
8. **Write completion log** to field-journal and update improvement-tracker

## Response Template

```
[D] Detected reverse-security task → activating reverse-skill router

[R] Routing Analysis:
    Task type: <inferred type from keywords>
    PRIMARY skill: <identified module per R-priority>
    Available tools: <count from tool-index>
    
[A] Action Plan:
    1. Read precedent-auth.md ✅
    2. Check existing experience in field-journal
    3. Verify tool availability
    4. Initialize case scope
    5. Execute PRIMARY workflow
    
[P] Request confirmation if scope unclear, otherwise proceed.
```

## Priority Override Rules

If He explicitly names a skill, respect that even if keywords suggest different route:
- "Use ida-reverse specifically" → go to IDA even if APK detected
- "Only do pentest tools" → skip reverse engineering modules

## Edge Cases

### Multiple competing keywords
- Use highest PRIORITY skill (R1 through R9 as per MASTER-ROUTING.md)
- Example: "APK + Frida + IDA" → APK-R1 wins over IDA-R6

### Unclear intent
- Ask ONE clarifying question only
- Example: "Detected Android-related terms. Target is APK binary or device debugging?"

### Tool missing
- Immediately offer bootstrap command
- Example: "jadx not detected. Run: bash skills/scripts/bootstrap-reverse.sh jadx --start-services?"

## Continuous Improvement Loop

After EACH activated task:

```bash
# Automatically run this:
bash ~/.hermes/profiles/default/skills/improvement-tracker.sh \
  <task-type-detected> \
  <outcome> \
  "<key learnings>"

# And add to memory:
echo "## <DATE> - <TASK>" >> ~/.hermes/profiles/default/memories/reverse-skill-improvements.md
```

This creates perpetual enhancement of routing accuracy and speed.

---

*Integrated into Dangyun operational protocol - always active for relevant tasks*
