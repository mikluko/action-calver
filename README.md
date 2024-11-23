# CalVer GitHub Action

## Overview

The **CalVer** GitHub Action provides opinionated Calendar Versioning (CalVer) for your projects. It
generates version numbers based on the current date and an optional prefix and suffix.

## Usage

To use this action in your workflow, add the following step:

```yaml
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Generate Calendar Version
        id: calver
        uses: mikluko/action-calver@v24.11.6
        with:
          token: ${{ github.token }}

      - name: Create GitHub Release
        env:
          GH_TOKEN: ${{ github.token }}
        run: gh release create "${{ steps.calver.outputs.next_version }}" --title "${{ steps.calver.outputs.next_version }}" --generate-notes
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
