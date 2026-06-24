.PHONY: fmt validate

MODULES := acm cognito ecr eks elasticache github_actions_oidc_role rds secrets vpc waf
TOFU ?= tofu

fmt:
	$(TOFU) fmt -recursive

validate:
	$(TOFU) fmt -recursive -check
	@for module in $(MODULES); do \
	  echo "Validating $$module"; \
		  $(TOFU) -chdir=$$module init -backend=false -input=false -reconfigure -upgrade; \
	  $(TOFU) -chdir=$$module validate; \
	done
