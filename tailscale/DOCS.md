# Home Assistant Community Add-on: Tailscale

Tailscale is a zero config VPN, which installs on any device in minutes on
any device, including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

## Prerequisites

In order to use this add-on, you'll need a Tailscale account.

It is free to use for personal & hobby projects, up to 20 clients/devices on a
single user account. Sign up using your Google, Microsoft or GitHub account at
the following URL:

<https://login.tailscale.com/start>

You can also create an account during the add-on installation processes,
however, it is nice to know where you need to go later on.

## Installation

1. Search for the "Tailscale" add-on in the Supervisor add-on store and
   install it.
1. Start the "Tailscale" add-on.
1. Check the logs of the "Tailscale" add-on to see if everything went well.
1. Open the Web UI of the "Tailscale" add-on to complete authentication and
   couple your Home Assistant instance with your Tailscale account.
1. Done!

## Configuration

This add-on has no additional configuration options for the add-on itself.

However, when logging in to Tailscale, you can configure your Tailscale
network right from their interface.

<https://login.tailscale.com/>

The add-on exposes "Exit Node" capabilities that you can enable from your
Tailscale account. Additionally, if the Supervisor managed your network (
which is the default), the add-on will also advertise routes to your
subnet to Tailscale.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Community Add-ons Discord chat server][discord] for add-on
  support and feature requests.
- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Authors & contributors

The original setup of this repository is by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2021 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[contributors]: https://github.com/hassio-addons/addon-tailscale/graphs/contributors
[discord-ha]: https://discord.gg/c5DvZ4e
[discord]: https://discord.me/hassioaddons
[forum]: https://community.home-assistant.io/?u=frenck
[frenck]: https://github.com/frenck
[issue]: https://github.com/hassio-addons/addon-tailscale/issues
[reddit]: https://reddit.com/r/homeassistant
[releases]: https://github.com/hassio-addons/addon-tailscale/releases
[semver]: http://semver.org/spec/v2.0.0.htm
