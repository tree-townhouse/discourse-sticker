# discourse-sticker

A Discourse plugin for creating, saving, moderating, and using community sticker packs.

The plugin is being developed incrementally against the latest Discourse release. Each milestone adds one small vertical slice with request or acceptance coverage before the next feature is started.

## Current milestone

- Plugin metadata and isolated Rails engine
- `discourse_sticker_enabled` site setting
- `GET /sticker/site.json` bootstrap endpoint
- Request coverage for enabled and disabled states
- GitHub Actions integration with the official Discourse plugin workflow

## Planned milestones

1. Permission policy and Guardian methods
2. Sticker pack and immutable revision models
3. Sticker upload and creator workflow
4. Store and saved packs
5. Approval and flag reviewables
6. Composer picker and sticker rendering
7. Responsive Foundation theme polish

## Development

Install this repository as `plugins/discourse-sticker` inside a current Discourse development checkout, then run:

```shell
bin/rspec plugins/discourse-sticker/spec
```

The repository workflow runs the official Discourse plugin CI suite on every pushed branch and pull request.
