# CI/CD Pipeline Setup

## ✅ What's Included

Your repository now has a complete CI/CD pipeline with:

- ✅ Terraform validation on every PR
- ✅ Security scanning (TFSec, Checkov, TruffleHog)
- ✅ Secret detection
- ✅ Code linting (TFLint)
- ✅ Module testing
- ✅ Documentation checks
- ✅ PR title validation
- ✅ Breaking changes detection

## 🚀 GitHub Actions Workflows

### Main Workflows

1. **Terraform Validation** (`.github/workflows/terraform-validate.yml`)
   - Runs on push to main/develop
   - Runs on all pull requests
   - Tests: format, init, validate
   - Security: TFSec, Checkov, TruffleHog
   - Quality: TFLint, module tests

2. **PR Checks** (`.github/workflows/pr-checks.yml`)
   - Validates PR title format
   - Checks PR size
   - Suggests labels
   - Detects breaking changes

## 🔧 Setup Instructions

### 1. Enable GitHub Actions

GitHub Actions should be enabled by default. Verify:

1. Go to your repository on GitHub
2. Click "Actions" tab
3. If disabled, click "Enable GitHub Actions"

### 2. Configure Required Secrets

Add these secrets in GitHub repository settings:

**Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `TF_API_TOKEN` | Terraform Cloud API token | Only if using Terraform Cloud |
| `AZURE_CREDENTIALS` | Azure service principal | For Azure deployments in CI/CD |

#### Terraform Cloud Token (Optional)

If using Terraform Cloud:

```bash
# Login to Terraform Cloud
terraform login

# Token is saved to ~/.terraform.d/credentials.tfrc.json
# Copy the token and add as GitHub secret
```

#### Azure Credentials (Optional)

For Azure deployments in CI/CD:

```bash
# Create service principal
az ad sp create-for-rbac --name "github-actions" --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --sdk-auth

# Output is JSON - add entire JSON as AZURE_CREDENTIALS secret
```

### 3. Branch Protection Rules

Set up branch protection for `main` branch:

1. Go to **Settings → Branches → Add rule**
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
4. Select required status checks:
   - `Terraform Validation`
   - `TFSec Security Scan`
   - `Secret Scanning`
   - `Checkov Security Scan`
   - `Module Tests`
   - `Terraform Lint`
5. Save changes

### 4. Enable Security Features

#### Code Scanning

1. Go to **Settings → Code security and analysis**
2. Enable:
   - ✅ Dependency graph
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates
   - ✅ Code scanning (GitHub Advanced Security)
   - ✅ Secret scanning

#### Security Tab

After enabling, security scan results appear in:
- **Security → Code scanning alerts** (TFSec, Checkov)
- **Security → Secret scanning alerts** (TruffleHog)

## 📝 Workflow Behavior

### On Pull Request

Every PR triggers:

1. **Format Check**
   ```
   terraform fmt -check -recursive
   ```

2. **Initialization**
   ```
   terraform init -backend=false
   ```

3. **Validation**
   ```
   terraform validate
   ```

4. **Security Scans**
   - TFSec: Infrastructure security
   - Checkov: Policy compliance
   - TruffleHog: Secret detection

5. **Quality Checks**
   - TFLint: Code quality
   - Module validation
   - Documentation presence

6. **PR Checks**
   - Title format validation
   - Size recommendations
   - Breaking changes detection

### On Push to Main/Develop

Same checks as PR, plus:
- Full test suite
- Integration validation
- Summary report generation

## 🔒 Security Scanning Configuration

### TFSec Configuration

File: `.tfsec.yml`

```yaml
minimum_severity: MEDIUM
exclude_paths:
  - .terraform/
  - .git/
soft_fail: false  # Set to true for warnings only
```

### TFLint Configuration

File: `.tflint.hcl`

```hcl
plugin "azurerm" {
  enabled = true
  version = "0.25.1"
}
```

### Checkov Configuration

Built into workflow, scans for:
- CIS benchmarks
- Security best practices
- Compliance standards

## 🎨 PR Requirements

### PR Title Format

Must follow conventional commits:

```
feat: add new feature
fix: resolve bug
docs: update documentation
style: format code
refactor: restructure code
test: add tests
chore: maintenance tasks
ci: CI/CD changes
```

### PR Size Guidelines

Recommendations:
- **Files**: < 50 files
- **Lines**: < 1000 lines

Large PRs get a warning to split them.

## 🏷️ Required Labels

Add one of these labels to PRs:
- `enhancement` - New features
- `bug` - Bug fixes
- `documentation` - Documentation changes
- `infrastructure` - Infrastructure changes
- `security` - Security updates

## 📊 Understanding Results

### Successful Run

```
✅ Terraform Format
✅ Terraform Init
✅ Terraform Validate
✅ TFSec Scan
✅ Secret Scan
✅ Checkov Scan
✅ Module Tests
✅ Lint Check
```

### Failed Checks

Check the logs for details:

1. Click "Details" next to failed check
2. Expand failed step
3. Review error message
4. Fix locally and push update

### Security Findings

Security issues appear in:
1. **PR Comments** - Auto-commented by bots
2. **Security Tab** - Consolidated view
3. **Workflow Logs** - Detailed output

## 🔄 Local Testing Before PR

Run these locally before creating PR:

```bash
# Format code
terraform fmt -recursive

# Validate
terraform init -backend=false
terraform validate

# Security scan
tfsec . --config-file .tfsec.yml

# Linting
tflint --recursive

# Check secrets
trufflehog filesystem . --only-verified
```

### Install Local Tools

```bash
# macOS
brew install terraform tflint tfsec trufflehog

# Linux
# See installation guides in CONTRIBUTING.md
```

## 🎯 Workflow Triggers

### Automatic Triggers

- Push to `main` branch
- Push to `develop` branch
- Any pull request
- Push to feature branches

### Manual Triggers

Can add manual workflow dispatch:

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to validate'
        required: true
        default: 'dev'
```

## 📈 Monitoring Workflow Health

### View Workflow Runs

1. Go to **Actions** tab
2. Select workflow
3. View run history
4. Check success rate

### Notifications

Configure notifications:
1. **Settings → Notifications**
2. Enable:
   - Actions workflow runs
   - Actions workflow run failures

## 🚨 Troubleshooting

### Workflow Fails with "Organization not found"

**Solution**: You're using local backend now, this shouldn't happen. If it does, check `provider.tf`.

### Secret Scanning False Positives

**Solution**: Add to `.tfsec.yml`:

```yaml
ignore:
  - resource: azurerm_resource.name
    rule: rule-id
    expiry: 2026-12-31
    reason: "False positive - not a real secret"
```

### TFLint Errors

**Solution**: Fix code or update `.tflint.hcl`:

```hcl
rule "terraform_naming_convention" {
  enabled = false  # Temporarily disable
}
```

### Workflow Timeout

**Solution**: Increase timeout in workflow file:

```yaml
jobs:
  job-name:
    timeout-minutes: 30  # Default is 360
```

## 🔄 Updating Workflows

### Modify Workflow Files

Edit files in `.github/workflows/`:

```bash
code .github/workflows/terraform-validate.yml
```

### Test Workflow Changes

1. Create PR with workflow changes
2. Workflow runs with new changes
3. Verify it works
4. Merge if successful

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)

## ✅ Verification Checklist

- [ ] GitHub Actions enabled
- [ ] Required secrets added
- [ ] Branch protection configured
- [ ] Security features enabled
- [ ] Local tools installed
- [ ] First PR created and validated
- [ ] Security tab shows results
- [ ] Notifications configured

## 🎉 You're All Set!

Your CI/CD pipeline is ready. Every PR will now be:
- ✅ Automatically validated
- 🔒 Security scanned
- 🧪 Tested
- 📝 Documented
- ✨ Quality checked

---

**Status**: ✅ CI/CD Pipeline Ready
**Last Updated**: June 2026
