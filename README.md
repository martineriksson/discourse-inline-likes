# discourse-inline-likes

A Discourse plugin that restores the original inline "who liked" display behavior.

## Background

In November 2025, [PR #34265](https://github.com/discourse/discourse/pull/34265) changed Discourse's like display from an inline list of user avatars to a dropdown menu. This plugin restores the original behavior.

Some discussion about why this plugin might be useful:

https://meta.discourse.org/t/ability-to-display-all-the-likes-reactions-on-a-post/389820

## Features

- Click the like count to show/hide an inline list of users who liked the post
- Displays user avatars using Discourse's native `SmallUserList` component
- Toggle behavior: click once to show, click again to hide
- Like button functionality unchanged
- Can be enabled/disabled via site setting

## Installation

Follow the standard [Discourse plugin installation guide](https://meta.discourse.org/t/install-plugins-in-discourse/19157):

```bash
cd /var/discourse
./launcher enter app
cd /var/www/discourse/plugins
git clone https://github.com/martineriksson/discourse-inline-likes.git
exit
./launcher rebuild app
```

## Configuration

After installation, enable the plugin in Admin → Settings → Plugins:

- **discourse_inline_likes_enabled**: Toggle the plugin on/off (default: enabled)

## License

MIT
