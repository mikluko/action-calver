Here is the updated `README.md` file:

```markdown
# CalVer GitHub Action

## Overview

The **CalVer** GitHub Action provides opinionated Calendar Versioning (CalVer) for your projects. It
generates version numbers based on the current date and an optional prefix and suffix.

## Inputs

- **`layout`**: The version layout. Default: `'vYY.0M.MICRO'`.

## Outputs

- **`prev_version`**: The previous version.
- **`next_version`**: The next version.

## Usage

To use this action in your workflow, add the following step:

```yaml
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          fetch-tags: true

      - name: Generate CalVer Version
        id: calver
        uses: mikluko/action-calver@v24.11.1
        with:
          layout: 'vYY.0M.MICRO'
          token: ${{ github.token }}

      - name: Create GitHub Release
        env:
          GH_TOKEN: ${{ github.token }}
        run: gh release create "${{ steps.calver.outputs.next_version }}" --title "${{ steps.calver.outputs.next_version }}" --generate-notes
```

## Example

Given the following inputs:

- `layout`: `'vYY.0M.MICRO'`

If the current date is October 2023, the generated version might be `` for the initial version, `` for the second, and so on.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
```