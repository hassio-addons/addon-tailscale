#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

# Disable taildrop service when it is has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable proxy service when it is has been explicitly disabled
if bashio::config.false 'proxy'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/proxy
fi

# Disable funnel service when it is has been explicitly disabled
if bashio::config.false 'proxy' || bashio::config.false 'funnel'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/funnel
fi
