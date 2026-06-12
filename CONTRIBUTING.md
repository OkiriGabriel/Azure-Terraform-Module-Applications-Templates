# Contributing to Azure Full Infrastructure

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Coding Standards](#coding-standards)
5. [Testing](#testing)
6. [Pull Request Process](#pull-request-process)
7. [Security](#security)
8. [Documentation](#documentation)

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility and learn from mistakes
- Prioritize the community's best interests

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing private information
- Any unprofessional conduct

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- **Terraform** >= 1.10.0 installed
- **Azure CLI** installed and configured
- **Git** installed
- **GitHub account** with SSH key configured
- **Text editor** or IDE (VS Code recommended)
- **Azure subscription** for testing (optional)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone git@github.com:YOUR_USERNAME/Azure-full-infrastructure.git
   cd Azure-full-infrastructure
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream git@github.com:ORIGINAL_OWNER/Azure-full-infrastructure.git
   ```

### Set Up Local Environment

1. Install pre-commit hooks:
   ```bash
   # Install pre-commit
   pip install pre-commit
   
   # Install hooks
   pre-commit install
   ```

2. Install development tools:
   ```bash
   # TFLint
   curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
   
   # TFSec
   brew install tfsec  # macOS
   # or
   curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
   ```

3. Verify installation:
   ```bash
   terraform version
   tflint --version
   tfsec --version
   ```

## Development Workflow

### Create a Feature Branch

Always create a new branch for your work:

```bash
# Update main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### Branch Naming Convention

Use descriptive branch names:

- `feature/add-cosmos-db-module` - New features
- `fix/aks-networking-issue` - Bug fixes
- `docs/update-readme` - Documentation updates
- `refactor/security-module` - Code refactoring
- `test/add-module-tests` - Test additions

### Making Changes

1. **Make your changes** in logical, atomic commits
2. **Test locally** before committing
3. **Run formatting**:
   ```bash
   terraform fmt -recursive
   ```
4. **Run validation**:
   ```bash
   terraform init -backend=false
   terraform validate
   ```
5. **Run security scan**:
   ```bash
   tfsec .
   ```

### Commit Messages

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples:**
```
feat(aks): add support for multiple node pools

- Added additional_node_pools variable
- Updated module documentation
- Added examples for workload-specific pools

Closes #123
```

```
fix(security): correct firewall rule priority conflict

The network rules were using overlapping priorities causing
deployment failures. Updated priority range to avoid conflicts.

Fixes #456
```

## Coding Standards

### Terraform Style Guide

1. **File Organization**
   - `main.tf` - Main resource definitions
   - `variables.tf` - Input variables
   - `outputs.tf` - Output values
   - `locals.tf` - Local values (if complex)
   - `versions.tf` or `provider.tf` - Provider configuration

2. **Naming Conventions**
   - Use lowercase with underscores: `resource_group_name`
   - Resources: `azurerm_resource_type.descriptive_name`
   - Variables: Clear, descriptive names
   - Outputs: Match the resource attribute name when possible

3. **Resource Blocks**
   ```hcl
   resource "azurerm_resource_type" "name" {
     name                = var.name
     location            = var.location
     resource_group_name = var.resource_group_name
     
     # Group related settings
     network_profile {
       setting1 = value1
       setting2 = value2
     }
     
     # Dynamic blocks for lists
     dynamic "rule" {
       for_each = var.rules
       content {
         name  = rule.value.name
         value = rule.value.value
       }
     }
     
     tags = var.tags
   }
   ```

4. **Variables**
   ```hcl
   variable "name" {
     description = "Clear description of the variable purpose"
     type        = string
     default     = null  # Only if optional
     
     validation {
       condition     = can(regex("^[a-z0-9-]+$", var.name))
       error_message = "Name must contain only lowercase letters, numbers, and hyphens."
     }
   }
   ```

5. **Outputs**
   ```hcl
   output "resource_id" {
     description = "The ID of the created resource"
     value       = azurerm_resource.name.id
     sensitive   = false  # Set to true for sensitive data
   }
   ```

### Best Practices

1. **DRY Principle**: Don't repeat yourself - use modules
2. **Use for_each**: Prefer `for_each` over `count` for resource creation
3. **Sensitive Data**: Mark sensitive outputs appropriately
4. **Conditionals**: Use `count = var.enabled ? 1 : 0` for optional resources
5. **Documentation**: Document complex logic with comments
6. **Dependencies**: Use explicit `depends_on` only when necessary
7. **State**: Never commit state files or `.terraform` directories

### Security Best Practices

1. **No Hardcoded Secrets**
   - Never commit credentials, API keys, or passwords
   - Use variables with no defaults for secrets
   - Use Azure Key Vault for secret management

2. **Least Privilege**
   - Grant minimum required permissions
   - Use managed identities when possible
   - Implement RBAC properly

3. **Network Security**
   - Use private endpoints
   - Implement NSG rules
   - Enable firewalls where appropriate

4. **Encryption**
   - Enable encryption at rest
   - Use TLS/SSL for data in transit
   - Rotate keys regularly

## Testing

### Local Testing

1. **Format Check**
   ```bash
   terraform fmt -check -recursive
   ```

2. **Validation**
   ```bash
   terraform init -backend=false
   terraform validate
   ```

3. **Linting**
   ```bash
   tflint --recursive
   ```

4. **Security Scanning**
   ```bash
   # TFSec
   tfsec . --config-file .tfsec.yml
   
   # Checkov
   checkov -d . --framework terraform
   ```

5. **Module Testing** (if you created/modified a module)
   ```bash
   cd modules/your-module
   terraform init -backend=false
   terraform validate
   terraform fmt -check
   ```

### Integration Testing

If you have access to an Azure subscription:

1. Create a test workspace
2. Deploy your changes
3. Verify functionality
4. Destroy resources
5. Document test results in PR

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass locally
- [ ] Security scans pass
- [ ] Documentation is updated
- [ ] Commit messages follow convention
- [ ] Changes are rebased on latest main
- [ ] No merge conflicts

### Submitting a PR

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to GitHub repository
   - Click "New Pull Request"
   - Select your branch
   - Fill out PR template

3. **PR Title Format**
   ```
   <type>: <description>
   
   Example:
   feat: add Cosmos DB module for NoSQL databases
   fix: resolve AKS networking issue in spoke VNet
   ```

4. **PR Description**
   Use the PR template to provide:
   - Summary of changes
   - Motivation and context
   - Type of change
   - Testing performed
   - Screenshots (if UI changes)
   - Related issues

### PR Requirements

Your PR must:
- Pass all CI/CD checks
- Have no merge conflicts
- Be reviewed by at least one maintainer
- Have all conversations resolved
- Include updated documentation
- Follow size guidelines (< 50 files, < 1000 lines)

### Review Process

1. **Automated Checks** run on PR creation
2. **Maintainer Review** within 2-3 business days
3. **Address Feedback** and push updates
4. **Approval** from maintainers
5. **Merge** by maintainer (squash and merge)

## Security

### Reporting Security Issues

**DO NOT** create public issues for security vulnerabilities.

Instead:
1. Email security@yourcompany.com
2. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (optional)

### Security Scanning

All contributions are automatically scanned for:
- **Secrets**: TruffleHog scans for exposed credentials
- **Security Issues**: TFSec checks for security misconfigurations
- **Compliance**: Checkov validates best practices
- **Sensitive Files**: Automated check for .pem, .key, etc.

### .gitignore

Ensure these are in `.gitignore`:
```
# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
!example.tfvars

# Secrets
*.pem
*.key
*.p12
*.pfx
.env
.env.*
*credential*
*secret*

# IDE
.vscode/
.idea/
*.swp
```

## Documentation

### Required Documentation

1. **Module README** (`modules/*/README.md`)
   - Purpose and overview
   - Requirements
   - Usage examples
   - Variables table
   - Outputs table
   - Resources created

2. **Root README** (main `README.md`)
   - Project overview
   - Quick start guide
   - Prerequisites
   - Usage instructions

3. **Inline Comments**
   - Complex logic explanation
   - Non-obvious decisions
   - Workarounds and their reasons

### Documentation Style

- Use clear, concise language
- Include code examples
- Provide context and rationale
- Keep it up to date with code changes

### Updating Documentation

When making changes, update:
- [ ] Module README files
- [ ] Main README if needed
- [ ] MODULES_README.md for new modules
- [ ] Inline code comments
- [ ] CHANGELOG.md (for releases)

## Code Review Guidelines

### For Contributors

- Respond to feedback promptly
- Be open to suggestions
- Ask questions if unclear
- Keep discussions professional
- Don't take feedback personally

### For Reviewers

- Be respectful and constructive
- Focus on code, not the person
- Explain the "why" behind suggestions
- Approve when requirements are met
- Provide examples when helpful

## Questions or Problems?

- **General Questions**: Open a GitHub Discussion
- **Bug Reports**: Create an issue with bug template
- **Feature Requests**: Create an issue with feature template
- **Security Issues**: Email security team

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- CHANGELOG.md for significant contributions
- Project documentation

Thank you for contributing! 🎉
