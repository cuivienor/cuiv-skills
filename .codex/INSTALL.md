# Installing Cuiv-skills for Codex

Quick setup to enable cuiv-skills in Codex.

## Installation

1. **Clone the repository**:
   ```bash
   mkdir -p ~/.codex
   git clone https://github.com/cuivienor/cuiv-skills.git ~/.codex/cuiv-skills
   ```

2. **Create personal skills directory** (optional, for overrides):
   ```bash
   mkdir -p ~/.codex/skills
   ```

3. **Update ~/.codex/AGENTS.md** to include this section:
   ```markdown
   ## Cuiv-skills System

   <EXTREMELY_IMPORTANT>
   You have cuiv-skills. Cuiv-skills teach you new skills and capabilities. RIGHT NOW run: `~/.codex/cuiv-skills/.codex/cuiv-skills-codex bootstrap` and follow the instructions it returns.
   </EXTREMELY_IMPORTANT>
   ```

## Verification

Test the installation:
```bash
~/.codex/cuiv-skills/.codex/cuiv-skills-codex bootstrap
```

You should see skill listings and bootstrap instructions.

## Updating

```bash
cd ~/.codex/cuiv-skills && git pull
```
