# Buildable Moodle service for Kubernetes on Wodby

Run Moodle with your own plugins and themes on Kubernetes with Wodby.

This repository defines the Wodby service manifest for Moodle built from your
Git repository. Your repository pins Moodle's version and holds your plugins;
Wodby CI puts them together and builds them on
[`wodby/moodle-php`](https://github.com/wodby/moodle-php), which brings PHP and
Wodby's setup for Moodle.

- [Browse Wodby services](https://wodby.com/services)
- [Wodby service documentation](https://wodby.com/docs/2.0/services/)
- [Service manifest reference](https://wodby.com/docs/2.0/services/template/)

## Service overview

| Property | Manifest configuration |
| --- | --- |
| Service name | `moodle-buildable` |
| Based on | [`moodle`](https://github.com/wodby/service-moodle): links, settings, volumes, cron, actions and resources |
| Versions | PHP `8.4` |
| Type | Application service |
| Image | Built from your repository on top of [`wodby/moodle-php`](https://github.com/wodby/moodle-php) |
| Application build | Moodle release from `.moodle-version` and your plugins under `public/`; start from the [Moodle boilerplate](https://github.com/wodby/moodle-boilerplate) |
| Web server | [Nginx for buildable Moodle](https://github.com/wodby/service-moodle-buildable-nginx), built from the same code |
| Operations | Installs or upgrades Moodle and your plugins after every deployment; purges caches |

To have Wodby keep Moodle up to date instead, use the [Moodle service](https://github.com/wodby/service-moodle): it
needs no repository or build.

## Use this service

Reference `moodle-buildable` from a Wodby stack, together with `moodle-buildable-nginx`. A service is a reusable
component and does not deploy by itself. The stack defines its links, settings, versions, resources, and relationship
to the rest of the application.

## Maintain a custom version

1. Fork this repository.
2. Edit the service manifest and referenced files.
3. Import the repository as a [Git-backed service](https://wodby.com/docs/2.0/services/create/#create-a-git-backed-service).
4. Reference the service from a stack manifest.

Validate the manifest with:

```bash
wodby service validate-manifest service.yml --org <org-id>
```

See the [service manifest reference](https://wodby.com/docs/2.0/services/template/) and the [managed services index](https://github.com/wodby/services).
