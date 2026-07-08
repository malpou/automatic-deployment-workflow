# Automatic Deployment Workflow

Example of a fully automated multi-environment deployment pipeline using GitHub Actions, Terraform, and Azure. Written about in detail in the companion blog post: [Automating deployments to production and staging with GitHub Workflows](https://malpou.medium.com/automating-deployments-to-production-and-staging-with-github-workflows-cdc060162daf).

## How it works

Pushes to `development` deploy to **staging**; pushes to `main` deploy to **production**. The [workflow](.github/workflows/deployment.yml) only deploys what actually changed:

1. **Check changes** – a composite action diffs the last commit against `backend/`, `frontend/`, and `infrastructure/` to decide which jobs run.
2. **Set environment** – maps the branch (or PR target) to `staging` or `production`.
3. **Terraform plan** – runs when infrastructure changed; the plan is published to the job summary and posted as a PR comment.
4. **Terraform apply** – applies the uploaded plan on `main`/`development`, using a per-environment state backend.
5. **Deploy backend** – builds the .NET Azure Function and publishes it to the environment's Function App.
6. **Deploy frontend** – builds the Svelte app and deploys it to Azure Static Web Apps.

Backend and frontend deploys also run standalone when only their directory changed, so an app-only commit never waits on Terraform.

## Repository layout

| Directory | Contents |
|---|---|
| `.github/` | Deployment workflow + composite actions (change detection, environment selection) |
| `backend/` | .NET Azure Function app |
| `frontend/` | Svelte + Vite app served from Azure Static Web Apps |
| `infrastructure/` | Terraform for all Azure resources, parameterized by environment |

## Reusing this

Fork it, create `staging`/`production` GitHub environments, and set the Azure credential secrets referenced in [`deployment.yml`](.github/workflows/deployment.yml) (`AZURE_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_CREDENTIALS`, `PAT`, plus the Static Web Apps API keys). The same pattern works for any stack — swap the build steps and keep the change-detection/environment plumbing.
