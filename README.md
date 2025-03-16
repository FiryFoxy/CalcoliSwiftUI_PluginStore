# Calcoli Plugin Repository

This repository hosts plugins for the Calcoli application. It serves as a central registry for discovering, distributing, and managing plugins.

## Repository Structure

```
├── plugins.json         # Central registry of all available plugins
├── plugins/            # Directory containing all plugin packages
│   ├── plugin-name/    # Individual plugin directory
│   │   ├── src/       # Plugin source code
│   │   ├── assets/    # Plugin resources
│   │   └── README.md  # Plugin documentation
└── docs/              # Plugin development documentation
```

## Plugin Registry

The `plugins.json` file is the central registry that contains metadata for all available plugins. Each plugin entry includes:

- `id`: Unique identifier for the plugin
- `name`: Display name of the plugin
- `description`: Brief description of the plugin's functionality
- `version`: Plugin version following semantic versioning
- `author`: Plugin author's name
- `category`: Plugin category (e.g., Mathematics, Science)
- `repository`: URL to the plugin's source code repository
- `downloadUrl`: Direct download URL for the plugin package
- `requirements`: Plugin requirements and compatibility information

## Contributing

### Creating a New Plugin

1. Fork this repository
2. Create a new directory in `plugins/` with your plugin name
3. Add your plugin source code and assets
4. Create a pull request with:
   - Your plugin package
   - Updated `plugins.json` with your plugin's metadata
   - Documentation in your plugin's README.md

### Plugin Guidelines

- Follow semantic versioning for your plugin releases
- Include clear documentation
- Ensure compatibility with the minimum required app version
- Test your plugin thoroughly before submission

### Review Process

1. Submit a pull request with your plugin
2. Automated tests will verify your plugin structure and metadata
3. Maintainers will review your submission
4. Upon approval, your plugin will be added to the registry

## License

This repository is licensed under the MIT License. Individual plugins may have their own licenses - please check each plugin's documentation for details.