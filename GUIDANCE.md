# Buildable Moodle on Wodby

This service is the [moodle](https://github.com/wodby/service-moodle) service built from the app's repository: its
guidance applies to settings, data, cron, installation and upgrades. This page covers what differs.

## Image

The image is built from the app's Git repository on top of [wodby/moodle-php](https://github.com/wodby/moodle-php):
PHP-FPM with the same Wodby setup as the prebuilt Moodle image (`config.php`, `moodle-update`, `moodle-cron`, PHP
settings), but no Moodle. The service's versions are PHP versions. Start the repository from the
[Moodle boilerplate](https://github.com/wodby/moodle-boilerplate). It holds:

- `.moodle-version`: the Moodle release to run, such as `5.3.1`, required. Moodle 5.1 and later 5.x releases are
  supported.
- `public/`: the app's plugins and themes at their place in Moodle's `public/` tree, such as `public/local/myplugin`.

The repository's pipeline runs `wodby ci run -- moodle-install-release` before `wodby ci build`. In the build directory
it downloads the release from Moodle's GitHub tag, installs its Composer packages, adds the repository's `public/`
files and Wodby's `config.php`, and replaces everything else. It fails when a file in `public/` is already part of
Moodle, so Moodle's own code is never replaced. The PHP image and the
[Nginx service](https://github.com/wodby/service-moodle-buildable-nginx) are then built from the same directory, so
Nginx serves the plugins' files. The image build fails when Moodle is missing, for example when the pipeline doesn't
run `moodle-install-release`.

Moodle's version changes only when the repository changes it: new image revisions bring PHP and Wodby's scripts, not a
new Moodle. Upgrading Moodle means changing `.moodle-version` and deploying; the deployment upgrades the database.

## Plugins

After every deployment the **Install or upgrade Moodle** action runs `moodle-update`, as the moodle service does.
Moodle's upgrade installs plugins that are new in the repository and upgrades those whose `version.php` version went
up. Uninstall a plugin in Moodle's administration before removing it from the repository.

Installing plugins from Moodle's web interface stays turned off: the code is part of the image.

## Cron

The `moodle-buildable-cron` worker runs the app's own image, so cron tasks of the repository's plugins run too.
