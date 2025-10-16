# Figma Design System Reference

This file contains references to Figma design system files and components used in this project.

## Main Design System
- **File Key**: `W7x7IvJBDsSw43zcIKMJeR`
- **File Name**: ✦ Mobile Design System
- **URL**: https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=634-27&p=f&t=3gJqoSz2w5aNwUCA-11

## Key Components and Nodes

### Color System
- **Node ID**: `634-27`
- **Description**: Color definitions for primary, secondary, tertiary, and other semantic colors
- **Usage**: Reference for creating color assets and design system implementation

### Component References
- **PostPreview**: https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=5-62&p=f&t=yPG9JEmux6qoTlmT-11
- **PostMetadata**: https://www.figma.com/file/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=2-232

## MCP Server Configuration

### Personal Access Token Setup
1. **Generate Token in Figma:**
   - Go to Figma → Account Settings → Personal Access Tokens
   - Click "Generate new token"
   - Give it a descriptive name (e.g., "Cursor MCP Integration")
   - Copy the generated token (starts with `figd_`)

2. **Current Token:**
   - **Token**: `[REDACTED - Store securely in environment variables]`
   - **Usage**: Authenticate API requests to Figma
   - **Note**: Keep this token secure and regenerate if compromised

### MCP Server Setup

#### Step 1: Enable Figma Desktop MCP Server
1. Open Figma Desktop app
2. Go to **Figma → Preferences** (or **Figma → Settings** on Windows)
3. Navigate to **General** tab
4. Enable **"Enable local MCP Server"**
5. Note the server URL: `http://127.0.0.1:3845/mcp`

#### Step 2: Configure Cursor MCP Settings
1. Open Cursor
2. Go to **Cursor → Settings** (⌘,)
3. Look for **"MCP"** tab in the settings sidebar
   - **Note**: If you don't see MCP tab, try **"Tools & Integrations"** tab
   - **Alternative**: Look for **"Extensions"** or **"Integrations"** section
4. Add new MCP server configuration:
   ```json
   {
     "mcpServers": {
       "Figma Desktop": {
         "url": "http://127.0.0.1:3845/mcp"
       }
     }
   }
   ```

#### Step 3: Restart Cursor
- Close and reopen Cursor to activate MCP server connection
- The Figma MCP tools should now be available

### Troubleshooting MCP Setup

#### If MCP tab is not visible in Cursor:
1. **Check Cursor version**: Ensure you're using a recent version that supports MCP
2. **Alternative locations**: Look in "Tools & Integrations", "Extensions", or "Integrations"
3. **Manual configuration**: Create `.cursor/settings.json` in project root:
   ```json
   {
     "mcpServers": {
       "Figma Desktop": {
         "url": "http://127.0.0.1:3845/mcp"
       }
     }
   }
   ```

#### If MCP server connection fails:
1. **Verify Figma Desktop is running** and MCP server is enabled
2. **Check server URL**: Ensure it's `http://127.0.0.1:3845/mcp`
3. **Test connection**: Run `curl http://127.0.0.1:3845/mcp` in terminal
4. **Restart both Figma and Cursor** if needed

## MCP Server Usage

When working with Figma MCP server, these tools are available:

### Available MCP Tools
- `mcp_Figma_get_metadata` - Get node metadata and structure
- `mcp_Figma_get_code` - Generate UI code from Figma nodes
- `mcp_Figma_get_screenshot` - Generate screenshots of Figma nodes
- `mcp_Figma_get_variable_defs` - Get design system variables
- `mcp_Figma_get_code_connect_map` - Map Figma components to code
- `mcp_Figma_add_code_connect_map` - Add new component mappings
- `mcp_Figma_create_design_system_rules` - Generate design system rules

### Common Usage Examples

#### Get Color Variables
```bash
# Get color definitions from design system
mcp_Figma_get_variable_defs --node-id 634-27
```

#### Generate Component Code
```bash
# Generate SwiftUI code for a component
mcp_Figma_get_code --node-id 634-27 --client-frameworks swiftui --client-languages swift
```

#### Get Node Metadata
```bash
# Get structure and properties of a node
mcp_Figma_get_metadata --node-id 634-27
```

### Working with This Project

#### Color System Implementation
1. Use `mcp_Figma_get_variable_defs` to get exact color values
2. Create color assets in `Assets.xcassets` with light/dark variants
   - **Important**: Use prefixed names (e.g., `ColourPrimary`, `ColourSecondary`, `ColourTertiary`) to avoid conflicts with SwiftUI's built-in color symbols
3. Update `Color+Extensions.swift` with semantic color definitions
4. Use `Color.primary`, `Color.secondary`, `Color.tertiary` in components

#### Color Asset Naming Convention
- **Avoid**: `Primary`, `Secondary`, `Tertiary` (conflicts with SwiftUI)
- **Use**: `ColourPrimary`, `ColourSecondary`, `ColourTertiary` (matches Figma naming)
- **Reference**: `Color("ColourPrimary")` in `Color+Extensions.swift`
- **Note**: Matches Figma variable names: `colour.primary`, `colour.secondary`, `colour.tertiary`

#### Component Development
1. Use `mcp_Figma_get_code` to generate initial component code
2. Use `mcp_Figma_get_screenshot` to verify visual accuracy
3. Map components using `mcp_Figma_add_code_connect_map` for future reference

## Design System Implementation Notes

### Colors
- Primary: Main text, headings, primary UI elements
- Secondary: Secondary text and UI elements
- Tertiary: Metadata, subtle text, tertiary elements

### Typography
- Title 3, Bold: For post titles
- Body: For post descriptions
- Caption: For metadata and timestamps

### Components
- All components should reference the Figma specs for exact measurements, colors, and styling
- Use semantic color names that match the design system
- Maintain consistency with the established design patterns

## Future Updates

When the design system is updated in Figma:
1. Update this reference file with new node IDs
2. Update component implementations to match new specifications
3. Update color assets if color values change
4. Test components in both light and dark modes

## Access Instructions

To access Figma data in future sessions:
1. Reference this file for the correct file keys and node IDs
2. Use the MCP server commands listed above
3. Update component implementations based on the latest Figma specifications
