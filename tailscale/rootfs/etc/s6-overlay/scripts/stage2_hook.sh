#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

declare options
declare proxy funnel proxy_and_funnel_port
declare share_homeassistant share_on_port

# Upgrade configuration from 'proxy', 'funnel' and 'proxy_and_funnel_port' to 'share_homeassistant' and 'share_on_port'
# This step can be removed in a later version
options=$(bashio::addon.options)
proxy=$(bashio::jq "${options}" '.proxy // empty')
funnel=$(bashio::jq "${options}" '.funnel // empty')
proxy_and_funnel_port=$(bashio::jq "${options}" '.proxy_and_funnel_port // empty')
share_homeassistant=$(bashio::jq "${options}" '.share_homeassistant // empty')
share_on_port=$(bashio::jq "${options}" '.share_on_port // empty')
# Ugrade to share_homeassistant
if bashio::var.true "${proxy}"; then
    if bashio::var.has_value "${share_homeassistant}"; then
        bashio::log.warning "The proxy and funnel options are already migrated to share_homeassistant option, do not configure deprecated options, proxy and funnel options are dropped."
    else
        if bashio::var.true "${funnel}"; then
            bashio::addon.option 'share_homeassistant' 'funnel'
        else
            bashio::addon.option 'share_homeassistant' 'serve'
        fi
    fi
fi
# Ugrade to share_on_port
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    if bashio::var.has_value "${share_on_port}"; then
        bashio::log.warning "The proxy_and_funnel_port option is already migrated to share_on_port option, do not configure deprecated options, proxy_and_funnel_port option is dropped."
    else
        if ! bashio::addon.option 'share_on_port' "${proxy_and_funnel_port}"; then
            bashio::log.warning "The proxy_and_funnel_port option value '${proxy_and_funnel_port}' is invalid, proxy_and_funnel_port option is dropped."
        fi
    fi
fi
# Remove previous options
if bashio::var.has_value "${proxy}"; then
    bashio::addon.option 'proxy'
fi
if bashio::var.has_value "${funnel}"; then
    bashio::addon.option 'funnel'
fi
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    bashio::addon.option 'proxy_and_funnel_port'
fi

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/protect-subnets
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# If advertise_routes is configured, do not wait for the local network to be ready to collect subnet information
if bashio::config.exists "advertise_routes";
then
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/local-network
fi

# Disable mss-clamping service when userspace-networking is enabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/mss-clamping
fi

# Disable taildrop service when it has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable share-homeassistant service when share_homeassistant has not been explicitly enabled
if ! bashio::config.has_value 'share_homeassistant' || \
    bashio::config.equals 'share_homeassistant' 'disabled'
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/share-homeassistant
fi
