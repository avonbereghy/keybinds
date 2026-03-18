# 🧭 DEV NAVIGATION MASTER CHEAT SHEET

## Core Philosophy

-   Desktops = contexts
-   Windows = projects
-   Tabs = files

------------------------------------------------------------------------

## 🖥️ Desktop Navigation

-   Ctrl + ← / → → Switch desktops
-   Ctrl + 1 / 2 / 3 → Jump to desktop
-   Ctrl + ↑ → Mission Control

------------------------------------------------------------------------

## 🪟 Window Navigation

-   Cmd + \` → Cycle windows (same monitor)
-   Cmd + Tab → Switch apps
-   Cmd + Tab → ↓ → App windows (inconsistent)
-   Raycast: Cmd + Space → w → search → Enter (BEST)

------------------------------------------------------------------------

## ⚡ VS Code Navigation

-   Cmd + P → Open file
-   Cmd + Shift + P → Command palette
-   Ctrl + Tab → Recent files
-   Cmd +  → Split editor
-   Cmd + 1 / 2 / 3 → Focus editor group
-   Ctrl + - → Go back

------------------------------------------------------------------------

## 🔔 Notifications (IMPORTANT)

-   Ctrl + K → Ctrl + Shift + N → Focus notification
-   Tab → navigate buttons
-   Enter → confirm
-   Esc → dismiss

Recommended binding: notifications.focusToasts → Cmd + Shift + N

------------------------------------------------------------------------

## 🧑‍💻 Terminal

-   Cmd + T → New tab
-   Cmd + ← / → → Switch tabs
-   Cmd + D → Split pane
-   Cmd + Option + Arrow → Move panes

------------------------------------------------------------------------

## ⚡ Raycast

-   Cmd + Space → Open
-   w → Switch windows
-   Type project name → jump instantly
-   clipboard → history

------------------------------------------------------------------------

## 🔥 Golden Workflow

-   Ctrl + ← / → → switch context
-   Cmd + Space → jump to project
-   Cmd + \` → quick switch
-   Cmd + P → open file

------------------------------------------------------------------------

## 🚀 Optional Tools

-   AltTab → best window cycling
-   Rectangle → window tiling

------------------------------------------------------------------------

## 🖥️ tmux (Terminal Multiplexer)

All commands use a **prefix**: press Ctrl + B, release, then the key.

### Sessions

-   `tmux new -s name` → Start named session
-   `tmux ls` → List sessions
-   `tmux attach -t name` → Reattach to session
-   `tmux kill-session -t name` → Kill session
-   Ctrl + B → d → Detach (session keeps running)

### Panes (splits)

-   Option + → → Move right or create split (custom binding)
-   Option + ← → Move left or create split (custom binding)
-   Ctrl + B → % → Split left/right
-   Ctrl + B → " → Split top/bottom
-   Ctrl + B → Arrow keys → Move between panes
-   Ctrl + B → z → Zoom pane full screen (toggle)
-   Ctrl + B → x → Kill pane
-   Ctrl + B → Ctrl + Arrow → Resize pane
-   Ctrl + B → Alt + 1 → Equal horizontal layout
-   Ctrl + B → Alt + 2 → Equal vertical layout
-   Ctrl + B → Alt + 3 → Tiled grid (auto-arrange evenly)

### Windows (tabs)

-   Ctrl + B → c → New window
-   Ctrl + B → n → Next window
-   Ctrl + B → p → Previous window
-   Ctrl + B → 0-9 → Jump to window number
-   Ctrl + B → , → Rename window
-   Ctrl + B → w → List all windows

### Config (~/.tmux.conf)

-   `set -g mouse on` → Enable mouse (click panes, drag resize)
-   `tmux source-file ~/.tmux.conf` → Reload config

### Notes

-   Sessions survive detach but NOT reboot
-   Use native Terminal.app — VS Code intercepts Ctrl + B
-   % and " require Shift (Shift + 5 and Shift + ')

------------------------------------------------------------------------

## TLDR

Use: Ctrl + ← / → Cmd + Space Cmd + \` Cmd + P


# ClaudeStage / claude-cortex — Full Conversation Summary (2026-03-17)

## What This Project Is

ClaudeStage is a project exploring memory management techniques for LLMs. The core artifact is `claude-cortex/RESEARCH.md` — a comprehensive 510-line research catalog comparing how every major tool handles persistent memory, retrieval, and cross-session context.

## What Was Built (RESEARCH.md)

### The Six (now Eight) Inspirations
Deep technical teardowns of how each tool achieves "perfect memory":
- **MyMind** — CLIP-family embeddings, k-NN "Same Vibe" visual similarity, OCR, auto-tagging. No API, closed ecosystem.
- **Obsidian** — PixiJS (WebGL) force-directed graph, Smart Connections plugin (bge-micro-v2 384-dim local embeddings via ONNX/WASM), MetadataCache in IndexedDB, .ajson vector storage.
- **Granola** — Bot-free audio capture (likely AudioHardwareCreateProcessTap on macOS 14.4+), Deepgram+AssemblyAI STT, NO vector RAG — uses large-context-window stuffing (40 summaries or 25 transcripts). $67M raised, $250M valuation.
- **Notion** — 480 logical shards / 96 physical RDS hosts, transactional version-sync (not CRDT/OT), Debezium CDC → Kafka → Spark → Hudi data lake, Notion 3.0 Agents (20+ min autonomous execution). Anthropic prompt caching integration.
- **ChatGPT** — `bio` tool for writes, ALL memories brute-force injected into system prompt every conversation (~1,400 word cap). No RAG, no filtering. `PersonalContextAgentTool` for chat history. Prompt injection vulnerability (Tenable TRA-2025-11).
- **Claude (claude.ai)** — Two-layer: (1) 24-hour batch synthesis always injected, (2) `conversation_search` embedding-based top-5 RAG invoked on-demand. Hard project isolation. `memory_20250818` API tool is client-side (you implement storage).
- **NotebookLM** (added) — Source-grounded closed RAG, inline citations, zero hallucination by design.
- **GitHub Copilot** (added) — Citation-validated agentic memory. Memories stored with file:line references, verified in real-time before applying. Code is source of truth. 28-day expiry, repo-scoped, on by default Mar 2026.

### Technical Stack Comparison Table
Full dimension-by-dimension comparison: Ingestion, AI Models, Embedding Strategy, Vector Storage, Similarity Search, Graph/Relations, Storage Engine, Sync/Collab, Offline Support, Auth/Security, MCP Support, Desktop Framework, Editor.

### Key Algorithms Per Tool
- MyMind: CLIP multimodal embeddings, YOLO-style object detection, color histograms, k-NN
- Obsidian: Fruchterman-Reingold force-directed layout, Velocity Verlet integration, Louvain modularity (3D plugin)
- Granola: Dual STT routing, three-input note synthesis, internal eval tooling for model swaps
- Notion: Block data model (UUID v4), workspace-ID shard key, real-time sync via MessageStore/WebSocket, Debezium CDC pipeline

### Cross-Session Memory Architecture (The Core Problem)

**The problem**: A single memory store holding heterogeneous domains (workouts, app dev, finances) needs to load ONLY relevant context. ChatGPT brute-forces everything. Claude uses hard silos. Neither works for cross-domain.

**ChatGPT vs Claude comparison table** — write triggers, storage, read mechanisms, domain filtering, weaknesses.

**Stanford Generative Agents scoring formula** (verified from ACM paper):
```
score = α_recency × recency(0.995^hours) + α_importance × importance(LLM-rated 1-10) + α_relevance × relevance(cosine similarity)
```

**Retrieval strategies ranked** (6 levels from metadata pre-filter + semantic search down to brute-force injection).

**Key systems comparison**: Mem0, Letta/MemGPT, LangMem, MemOS, A-Mem, Stanford Generative Agents — domain separation, retrieval, scoring, best-for.

**Preventing cross-domain contamination** (5 techniques that work, 3 that don't):
- Works: write-time tagging, namespace pre-filter, similarity threshold ≥ 0.7, LLM-as-gate (Mem0), memory type separation
- Doesn't work: pure vector similarity without pre-filtering, hard silos, topic classifiers as primary routing

**Practical architecture** (write path → read path → consolidation) with unified SQLite + sqlite-vec.

**Benchmarks**: LoCoMo (ACL 2024) — 32 sessions, ~600 turns, ~16K tokens avg. Human ceiling 87.9 F1. Mem0: 26% improvement over OpenAI's memory (66.9% vs 52.9%), 90% token reduction (~1.8K vs ~26K), 91% p95 latency drop.

### Section A: Existing Memory Systems (GitHub/Production)
Full table with stars, storage, local-first, semantic search, graph, best-for:
- claude-mem (37.7k★), Mem0 (50.2k★), Letta/MemGPT (21.6k★), Graphiti/Zep (23.9k★), Cognee (14.3k★), Supermemory (17.0k★), OpenMemory (3.6k★), Basic Memory (2.7k★), LangMem (1.3k★), A-MEM (917★), Remembra (7★), ContextFS (3★), agent-recall (7★)

### MCP Memory Servers Table
Anthropic Official, claude-memory-mcp, Basic Memory MCP, mcp-neo4j-agent-memory, Cognee MCP, Supermemory MCP (3 tools, ~50ms profile retrieval), Remembra MCP (11 tools incl. temporal/relationship queries), ContextFS MCP.

### Unified Brain Attempts (Why No One Has Nailed It)
Full landscape table: Rewind.ai (→ Meta acquisition, shutdown), Microsoft Recall (security disaster), Mem.ai ($29M raised, faded), Apple Intelligence (slow), Supermemory, Remembra, ContextFS, Khoj, Pieces, Fabric.

**GitHub Copilot Memory deep dive**: Citation-validated memory structure with JSON example. Write/read/isolation/innovation/stale prevention details.

### Sections B-I
- B: Storage Strategies (flat files → hybrid). Surprising finding: Letta benchmark showed filesystem grep at 74.0% > Mem0 graph at 68.5%.
- C: Retrieval Strategies (BM25, dense, hybrid, re-ranking, graph traversal, visual similarity)
- D: Memory Types / Cognitive Model (episodic, semantic, procedural, working, visual, reflective)
- E: Memory Lifecycle (creation, consolidation, decay/forgetting, importance scoring)
- F: Context Window Management (summarization, observation masking — JetBrains: 52% cost reduction +2.6% solve rate, sliding window, hierarchical, selective injection)
- G: Knowledge Tools landscape (MyMind, Obsidian, Granola, Notion, Smart Connections, Tana, Logseq, Capacities, Pieces, NotebookLM, Perplexity Spaces, Dia, Gemini, M365 Copilot)
- H: AI IDE Memory Approaches (Claude Code, Cursor — Memories removed in v2.1.x, Windsurf — SpAIware vuln, GitHub Copilot, Amazon Q Developer — Project Intelligence, Gemini Code Assist — PR→rules, Kiro, Warp)
- I: Privacy & Local-First (on-device embeddings — EmbeddingGemma 308M <15ms on EdgeTPU, local vector stores, encrypted vectors, scoped indexes)

### Section J: Memory Security Vulnerabilities (NEW)
Table covering ChatGPT (prompt injection → fake memories), Gemini (memory persistence attacks), Windsurf (SpAIware data exfiltration), Microsoft Recall (unencrypted DB), GitHub Copilot (shared repo memories).

**Architectural lesson**: Auto-generated memories that load without user confirmation = highest risk. File-based inspectable memory (Claude, Amazon Q, Cursor rules) = safer.

### Key Architectural Insight (Synthesis)
Eight inspirations mapped to production architecture layers (working memory, short-term, long-term factual/visual/skills, chat interface, collaboration, personalization, domain isolation, source grounding, security).

**Three emerging patterns (2025-2026)**:
1. File-based > opaque stores (Cursor removed Memories, Amazon Q uses markdown)
2. Citation-validated memory (Copilot, NotebookLM)
3. Memory is a security surface (ChatGPT, Gemini, Windsurf all had prompt injection attacks)

**The gap no one fills**: Local-first + citation-validated + namespace-scoped + source-grounded + file-based inspectable + model-agnostic + MCP-compatible.

## Opus Verification Pass (What Was Checked)

### Corrections Applied
1. claude-mem stars: 31.8k → 37.7k (GitHub API verified)
2. EmbeddingGemma: added "on EdgeTPU" qualifier
3. Notion prompt caching: clarified as Anthropic's general "up to" figures
4. Mem0 26%: specified "over OpenAI's built-in memory feature" with exact scores (66.9% vs 52.9%)
5. Granola AudioHardwareCreateProcessTap: qualified as "likely" / unconfirmed
6. Supermemory/Remembra benchmarks: added "(self-reported)" qualifiers

### Verified Accurate (unchanged)
- Stanford Generative Agents 0.995^hours (ACM paper)
- LoCoMo: ACL 2024, 32 sessions, ~600 turns, 87.9 F1 ceiling
- Letta filesystem grep 74.0% > Mem0 graph 68.5% (Letta blog)
- JetBrains ~15% longer runs from summarization (NeurIPS 2025 workshop)
- Observation masking 52% cost / +2.6% solve rate (same paper)
- All star counts for Mem0, Letta, Graphiti, Cognee, LangMem
- All Obsidian, Granola, Notion technical details

## Research Questions Answered

1. **How do ChatGPT and Claude actually handle memory?** — ChatGPT: brute-force inject all ~1,400 words, no RAG. Claude: 24hr synthesis + on-demand embedding search.
2. **Why has no one built a unified "Brain"?** — Data silos (no universal API), no OS-level hooks, privacy vs utility paradox, 95% noise ratio, cold start kills retention, every tool wants to BE the brain.
3. **What's the right architecture for multi-domain memory?** — Unified store + namespace pre-filter → semantic search (cosine ≥ 0.7) → score(recency × importance × relevance) → top-k → optional LLM re-rank.
4. **What might actually solve it now?** — MCP (universal protocol), local embeddings (bge-micro-v2), sqlite-vec (30MB vector search). The gap is a system combining citation-validation + namespace-scoping + source-grounding + file-based inspectability.

## File Location
`claude-cortex/RESEARCH.md` — 510 lines, ~45KB
