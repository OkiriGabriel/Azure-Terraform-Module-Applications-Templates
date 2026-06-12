## Description
<!-- Provide a brief description of your changes -->

## Type of Change
<!-- Mark the relevant option with an "x" -->

- [ ]  New feature (non-breaking change which adds functionality)
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🔧 Configuration change
- [ ] ♻️ Code refactoring
- [ ] 🏗️ Infrastructure change
- [ ] 🔒 Security update

## Related Issues
<!-- Link related issues using keywords like "Fixes #123" or "Closes #456" -->

Fixes #
Related to #

## Changes Made
<!-- Describe the changes you made in detail -->

### Modified Modules
<!-- List the modules you modified -->
- [ ] modules/aks
- [ ] modules/security
- [ ] modules/vnet-peering
- [ ] modules/virtual-wan
- [ ] modules/routing
- [ ] modules/azure-migrate
- [ ] modules/database-migration
- [ ] modules/site-recovery
- [ ] Other: ___________

### Configuration Changes
<!-- Describe any configuration changes -->


## Testing Performed
<!-- Describe the tests you ran to verify your changes -->

### Local Testing
- [ ] Terraform fmt check passed
- [ ] Terraform init successful
- [ ] Terraform validate passed
- [ ] TFSec scan passed
- [ ] TFLint check passed
- [ ] Checkov scan passed

### Integration Testing
<!-- If you deployed to Azure, describe what you tested -->
- [ ] Deployed to Azure dev environment
- [ ] Verified resources created successfully
- [ ] Tested functionality
- [ ] Cleaned up test resources

### Test Results
```
<!-- Paste relevant test output here -->
```

## Documentation
<!-- Check all that apply -->

- [ ] Updated module README files
- [ ] Updated main README.md
- [ ] Updated MODULES_README.md
- [ ] Added inline code comments
- [ ] Updated CHANGELOG.md (if applicable)
- [ ] No documentation changes needed

## Screenshots
<!-- If applicable, add screenshots to help explain your changes -->


## Checklist
<!-- Verify all items before submitting -->

### Code Quality
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

### Terraform Best Practices
- [ ] Used `for_each` instead of `count` where appropriate
- [ ] Marked sensitive outputs as `sensitive = true`
- [ ] Added appropriate variable validation
- [ ] Followed naming conventions
- [ ] Added proper resource dependencies

### Security
- [ ] No secrets or credentials in code
- [ ] Sensitive data uses variables or Key Vault
- [ ] TFSec scan passed
- [ ] Checkov scan passed
- [ ] No sensitive files committed

### Git
- [ ] My commits follow conventional commit format
- [ ] I have rebased my branch on the latest main
- [ ] There are no merge conflicts
- [ ] Branch name follows naming convention

## Breaking Changes
<!-- If this PR contains breaking changes, describe them here -->

### Migration Steps
<!-- Provide step-by-step instructions for migrating existing deployments -->

1. 
2. 
3. 

## Additional Context
<!-- Add any other context about the PR here -->


## Reviewer Notes
<!-- Any specific areas you'd like reviewers to focus on? -->


---

**By submitting this pull request, I confirm that:**
- [ ] I have read the [Contributing Guidelines](../CONTRIBUTING.md)
- [ ] I have tested these changes thoroughly
- [ ] I understand these changes will be reviewed before merging
- [ ] I am authorized to submit this contribution
