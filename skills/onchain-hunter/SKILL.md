---
name: onchain-narrative-research
description: Investigate crypto leads from screenshots, wallets, token addresses, X posts, Telegram/Discord snippets, founders, companies, projects, or viral narratives. Use when an AI coding agent needs to verify claimed trading profits, reconstruct onchain behavior, trace narrative/source timelines, identify early token/category leaders, build repeatable research reports, or turn discovered patterns into alert or bot-ready signal rules.
---

# Onchain Narrative Research

## Purpose

Turn a noisy crypto lead into a falsifiable research package:

1. verify whether the lead has onchain substance;
2. reconstruct what happened before, during, and after the trade/narrative;
3. identify source accounts, projects, companies, people, and story catalysts;
4. extract repeatable timing, liquidity, narrative, and execution signals;
5. publish a report or update a reusable alpha-source knowledge base.

Prefer evidence over vibes. Treat screenshots and PnL calendars as leads, not proof.

## Workflow

### 1. Frame The Lead

Capture the lead type:

- **晒单/PNL**: screenshot, wallet address, win calendar, public claim.
- **Token/trader**: wallet, token contract, DEX/pump platform, transfer CSV.
- **Narrative source**: X post, founder statement, company announcement, meme, product launch.
- **Entity source**: person, company, lab, project lead, brand, celebrity.
- **Category birth**: first token in a new meme/topic/category, or early leader token.

Write the research question in one sentence, such as:

- "Is this trader's claimed profit visible in onchain cashflow?"
- "Which FDV/liquidity node did this trader actually make money from?"
- "What was the earliest public source of this token's story?"
- "Did a company/founder/person post cause a token cluster to launch?"
- "Which token was the first credible leader of this new category?"

### 2. Preserve Evidence

Save screenshots, URLs, wallet addresses, token contracts, timestamps, and exported CSVs. Use exact UTC timestamps when possible. Keep raw evidence separate from derived conclusions.

If the lead is modern/current, browse to verify live pages, links, and post timestamps. Prefer primary sources: block explorers, official project/company pages, the original X post, official docs, and raw onchain data.

### 3. Build The Data Layer

Choose the minimum data needed:

- Wallet-level ordinary transactions from block explorers.
- Token transfers and internal transactions.
- Transaction receipts/logs from RPC.
- DEX/pump-platform event logs.
- Token metadata: decimals, supply, symbol, name.
- Historical BNB/ETH/SOL price if converting to USD.
- Social/timeline data from original posts and downstream amplification.

Never rely only on explorer "Method" labels. Decode receipt logs where strategy attribution matters.

### 4. Reconstruct Trading Behavior

For each token or position, derive:

- first buy time;
- first buy token;
- buy amount and quote asset;
- buy FDV or approximate market cap at the time;
- pool liquidity after/before trade when available;
- sell events and realized cashflow;
- residual/open position;
- fees;
- ROI, win/loss, max win/loss;
- bucket by timing/FDV/liquidity/category.

Use strict matching for headline conclusions. Keep looser/inferred matches in a separate caveat section.

### 5. Trace Narrative Origin

For tokens/projects tied to a story, reconstruct the narrative timeline:

- earliest known mention;
- first high-signal source account/entity;
- founder/company/person post;
- project website/docs launch;
- token deployment/mint time;
- first liquidity/pool creation;
- first notable buys;
- amplification accounts and time delays;
- market reaction windows.

Read `references/narrative-timeline.md` when the task involves source tracing, X posts, founders, companies, category leaders, or story fermentation.

### 6. Identify Alpha Sources

Classify sources:

- **primary origin**: person/company/project that creates the story;
- **early interpreter**: account that explains why the story matters;
- **fast deployer**: address/project that launches token first;
- **liquidity/router source**: platform where first tradeable market appears;
- **amplifier**: large account/community that expands attention;
- **leader token**: first or strongest token that captures category mindshare.

Read `references/source-library.md` when building or updating a reusable source list.

### 7. Turn Findings Into Bot Rules

Do not jump from one case to automation. Extract candidate rules:

- trigger source;
- required time window;
- liquidity/FDV range;
- category novelty;
- source credibility;
- wallet/address quality;
- risk exclusions;
- entry rule;
- exit rule;
- max loss rule;
- human confirmation checkpoint.

Read `references/bot-signal-design.md` when the user wants automation, bots, scoring, alerts, or repeatable strategy rules.

### 8. Publish The Research

Produce outputs appropriate to the user's goal:

- concise conclusion;
- evidence table;
- timeline;
- bucket summary;
- top winners/losers;
- caveats and false-positive risks;
- GitHub/Pages README;
- X thread/article draft;
- next experiments.

For public claims, separate:

- **verified**: directly supported by onchain data;
- **inferred**: likely but dependent on assumptions;
- **unverified**: needs more data.

## Output Skeleton

Use this structure unless the user asks for another format:

1. **Lead**: what triggered the investigation.
2. **Question**: what we are trying to prove/disprove.
3. **Method**: data sources and decoding approach.
4. **Findings**: hard numbers and timelines.
5. **Pattern**: what seems repeatable.
6. **Caveats**: what could be wrong.
7. **Next Rules**: signals to test or automate.
8. **Artifacts**: links to CSV, workbook, repo, dashboard, report.

## Safety And Risk

This skill supports research, not investment advice. Avoid telling users to buy a token. Prefer "candidate signal", "hypothesis", "requires validation", and "risk filter" language.

Warn when data can be misleading because of open positions, cross-wallet flows, private deals, taxes, honeypots, non-standard token mechanics, fake screenshots, copy-trader slippage, or delayed narrative discovery.

## References

- `references/narrative-timeline.md`: source tracing and story fermentation workflow.
- `references/source-library.md`: how to maintain alpha/source/entity lists.
- `references/bot-signal-design.md`: translating research into alert and bot rules.
