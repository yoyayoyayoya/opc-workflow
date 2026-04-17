#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/yoyayoyayoya/opc-workflow/main"

# ── Colors ──────────────────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "${BOLD}🔐 OPC Workflow Installer${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Step 1: Project path ─────────────────────────────────────────────────────
read -p "Project directory path (default: current directory): " PROJECT_PATH
PROJECT_PATH="${PROJECT_PATH:-$(pwd)}"

if [ ! -d "$PROJECT_PATH" ]; then
  echo -e "${YELLOW}Directory does not exist: $PROJECT_PATH${NC}"
  read -p "Create it? (y/n): " _confirm
  [[ "$_confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
  mkdir -p "$PROJECT_PATH"
fi

echo -e "${DIM}→ Installing into: $PROJECT_PATH${NC}"
echo ""

# ── Step 2: AI tool ──────────────────────────────────────────────────────────
echo -e "${BOLD}Select your AI tool:${NC}"
echo "  1) Claude Code"
echo "  2) Antigravity (Google Deepmind)"
echo "  3) Cursor"
echo "  4) Kiro"
echo "  5) Other (copy all files)"
echo ""
read -p "Enter number (1-5): " TOOL_CHOICE

case "$TOOL_CHOICE" in
  1) TOOL_NAME="Claude Code";                INSTALL_TYPE="agents" ;;
  2) TOOL_NAME="Antigravity";                INSTALL_TYPE="agents" ;;
  3) TOOL_NAME="Cursor";                     INSTALL_TYPE="agents" ;;
  4) TOOL_NAME="Kiro";                       INSTALL_TYPE="kiro"   ;;
  5) TOOL_NAME="Other";                      INSTALL_TYPE="other"  ;;
  *) echo "Invalid choice."; exit 1 ;;
esac

echo -e "${DIM}→ Tool: $TOOL_NAME${NC}"
echo ""

# ── Helpers ──────────────────────────────────────────────────────────────────
WORKFLOW_FILES=("plan_sprint.md" "sprint.md" "audit.md")
TEMPLATE_FILES=("sprint_tracker.md" "design_decisions.md")

download() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if curl -sSfL "$src" -o "$dest"; then
    echo -e "  ${GREEN}✔${NC}  $dest"
  else
    echo -e "  ${YELLOW}✘  Failed: $src${NC}" >&2
    exit 1
  fi
}

# ── Step 3: Install workflows ────────────────────────────────────────────────
echo -e "${BOLD}Downloading workflows...${NC}"

case "$INSTALL_TYPE" in
  agents)
    # Claude Code / Antigravity / Cursor → .agents/workflows/
    WORKFLOW_DEST="$PROJECT_PATH/.agents/workflows"
    ;;
  kiro)
    # Kiro → .kiro/steering/
    WORKFLOW_DEST="$PROJECT_PATH/.kiro/steering"
    ;;
  other)
    # Other → workflows/ (visible in the project)
    WORKFLOW_DEST="$PROJECT_PATH/workflows"
    ;;
esac

mkdir -p "$WORKFLOW_DEST"
for f in "${WORKFLOW_FILES[@]}"; do
  download "$RAW_BASE/workflows/$f" "$WORKFLOW_DEST/$f"
done

# ── Step 4: Install doc templates (skip if docs/ already has content) ────────
DOCS_DIR="$PROJECT_PATH/docs"
if [ -f "$DOCS_DIR/sprint_tracker.md" ]; then
  echo ""
  echo -e "${DIM}ℹ  docs/sprint_tracker.md already exists — skipping doc templates.${NC}"
else
  echo ""
  echo -e "${BOLD}Setting up doc templates...${NC}"
  for f in "${TEMPLATE_FILES[@]}"; do
    download "$RAW_BASE/docs/templates/$f" "$DOCS_DIR/$f"
  done
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}✅ Done!${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"

case "$INSTALL_TYPE" in
  agents)
    if [ "$TOOL_CHOICE" = "3" ]; then
      echo "  Cursor: use @file to reference the workflow:"
      echo -e "  ${DIM}@.agents/workflows/plan_sprint.md  start planning the next Sprint${NC}"
    else
      echo "  Open a new session and type:"
      echo -e "  ${DIM}/plan_sprint${NC}"
    fi
    ;;
  kiro)
    echo "  Kiro auto-loads .kiro/steering/ on startup."
    echo -e "  Type ${DIM}/plan_sprint${NC} to start."
    ;;
  other)
    echo "  Workflows installed to: $WORKFLOW_DEST"
    echo "  Reference them in your AI tool to trigger:"
    echo -e "  ${DIM}/plan_sprint  /sprint  /audit${NC}"
    ;;
esac

echo ""
echo -e "  Fill in ${DIM}$DOCS_DIR/sprint_tracker.md${NC} and ${DIM}design_decisions.md${NC} before your first Sprint."
echo ""
