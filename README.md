# discourse-sticker

A Discourse plugin for creating, saving, moderating, and using community sticker packs.

The plugin is being developed incrementally against the latest Discourse release. Each milestone adds one small vertical slice with request or acceptance coverage before the next feature is started.

## Current milestone

- Plugin metadata and isolated Rails engine
- `discourse_sticker_enabled` site setting
- `GET /sticker/site.json` bootstrap endpoint
- Group and trust-level permission settings for sticker use and upload
- Guardian policies for use, upload, and upload approval requirements
- Request and Guardian coverage for enabled, disabled, anonymous, member, group, and staff states
- GitHub Actions integration with the official Discourse plugin workflow

## Planned milestones

1. Sticker pack and immutable revision models
2. Sticker upload and creator workflow
3. Store and saved packs
4. Approval and flag reviewables
5. Composer picker and sticker rendering
6. Responsive Foundation theme polish

## Development

Install this repository as `plugins/discourse-sticker` inside a current Discourse development checkout, then run:

```shell
bin/rspec plugins/discourse-sticker/spec
```

The repository workflow runs the official Discourse plugin CI suite on every pushed branch and pull request.
