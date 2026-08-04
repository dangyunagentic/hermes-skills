# Reverse-Skill Skill Installation - 2026-08-04

## Summary
Installed reverse-skill router from https://github.com/zhaoxuya520/reverse-skill v1.0.0 into Hermes profile skills directory. This provides comprehensive routing for all reverse engineering, pentest, malware analysis, CTF, and security automation tasks.

## Skills Installed
- **45+ skill modules** covering: APK/Android reverse, binary analysis (IDA/radare2/Ghidra), JS frontend signature reversal, .NET/C# deobfuscation, malware YARA analysis, firmware IoT pentest, API security testing, LLM/AI security, EDR bypass, pwn/exploit dev, attack chain orchestration
- **Operations contracts**: scope management, evidence chain, role assignment, timeline tracking
- **Field journal system**: automatic experience logging and retrieval before each task
- **Tool index generation**: auto-detects installed tools (33 detected on Linux), tracks paths, enables bootstrap scripts

## Memory Updates Required
After EVERY reverse engineer or solve problem:

### Immediate Actions
1. Write anonymized log to `skills/field-journal/<YYYY-MM-DD>-<task-type>.md`
2. Update `_index.md` with new entry in appropriate category
3. Persist methods/tools searched online to `skills/references/`
4. If new scenario found → propose update to `routing.md`
5. Flag any tool missing from `tool-index.md` for bootstrap later

### Auto-Improvement Loop
```bash
# After completing task:
1. cd /root/reverse-skill-clone
2. echo "NEW EXPERIENCE: <task-type> | <outcome>" >> skills/field-journal/_index.md
3. Add to proper section (APK/binary/Web/API/etc)
4. Commit if ready for sharing
```

## Key Routing Priority (for quick reference)
| Priority | Trigger | Target Skill |
|----------|---------|--------------|
| R1 | APK/smali/apktool | apk-reverse/ |
| R2 | iOS/IPA/Mobile | mobile-reverse/ |
| R3 | JS signature/frontend encryption | js-reverse/ |
| R4 | DSL VM/custom opcode | dsl-vm-reverse/ |
| R5 | .NET/dnSpy/de4dot | dotnet-reverse/ |
| R6 | IDA Pro deep analysis | ida-reverse/ |
| R7 | radare2 CLI work | radare2/ |
| R8 | Firmware/IoT/embedded | firmware-pentest/ |
| R9 | Malware/YARA/sandbox | malware-analysis/ |
| R10 | Full attack chain/red team | attack-chain/ |
| R11 | Nmap/Nuclei/pentest tools | pentest-tools/ |
| R12 | API/GraphQL/JWT attacks | api-security/ |

## Integration Notes
- Routes automatically when Dangyun encounters security/reverse engineering keywords
- Precedent-auth.md must be read first before ANY operation (authorization pre-declaration)
- Tool-index.md is shared registry—don't guess paths, always check this file
- Bootstrap script available for missing tools (jadx, frida, r2, binwalk, pwntools, etc.)

## Next Steps
He can now use any of these keywords and Dangyun will automatically route to correct methodology:
- APK reverse, Android decompile, Frida Hook
- Binary analysis, IDA, radare2 disassembly  
- JS reverse, frontend signature, encrypted params
- Malware analysis, YARA rules
- Pentest, CTF, exploit dev, Pwn
- Firmware, IoT, binwalk
- EDR bypass, AV evasion
- API security, JWT attacks, GraphQL

Every completed task should write back to field-journal for continuous improvement.
