# Figma API Dumps Archive

This directory contains raw Figma API response JSON files that were previously stored in the project root.

## Contents

- `avatar-node.json` - Figma Avatar component node data
- `engagement-bar-node.json` - Figma EngagementBar component node data
- `postpreview-node.json` - Figma PostPreview component node data
- `list-item-node.json` - Figma list item component node data
- `post-metadata-states.json` - Figma PostMetadata states
- `divider-node.json` - Figma Divider component node data

## Why Archived?

These files were **not used anywhere in the codebase** and represented raw Figma API responses rather than usable mock data. They totaled ~400KB and cluttered the project root.

## Historical Context

These files were likely generated during initial Figma component exploration or MCP server testing. They contain complete Figma node data including:
- Component structure and hierarchy
- Style properties (fills, strokes, effects)
- Layout properties (constraints, spacing)
- Text content and styling
- Variant configurations

## Usage

If you need to reference Figma component structure:
1. **Prefer using the Figma MCP server** to fetch live component data
2. **Use Figma links** in component file headers for direct access
3. These JSON dumps are preserved for historical reference only

## Related

- [Figma MCP Server Setup](../../../.claude/claude.md#figma-mcp-server-troubleshooting)
- [Component Library](../../../.claude/claude.md#component-library)

---

*Archived: 2025-10-16*