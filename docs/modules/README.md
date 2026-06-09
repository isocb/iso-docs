# Module Documentation

This directory is the canonical documentation home for IsoStack modules.

## Convention

Each module gets one folder:

```text
docs/modules/<module-slug>/
```

Examples:

- `docs/modules/lmspro/`
- `docs/modules/fund/`
- `docs/modules/pulse/`
- `docs/modules/bedrock/`

## Rule

The canonical module documentation lives here in `isodocs`. The application repository (`isostack-bedrock`) may contain source-adjacent notes or pointer README files, but should not hold duplicate long-form module documentation.

## Recommended Module Folder Shape

```text
docs/modules/<module>/
├── README.md
├── 01-functional-specification.md
├── architecture.md
├── setup.md
├── features.md
├── planning/
├── decisions/
└── reference/
```

Not every module needs every file, but each module should have a `README.md` that indexes the important documents and states the implementation status.