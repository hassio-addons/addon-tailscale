upstream homeassistant {
    server 127.0.0.1:{{ .port }};
}

geo $tailscale_network {
    default false;
    proxy 127.0.0.1;
    100.64.0.0/10 true;
}

server {
    listen 127.0.0.1:8000 default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    set_real_ip_from  127.0.0.1;
    real_ip_header    X-Forwarded-For;

    location / {
        {{ if .funnel_protection }}
        if ( $tailscale_network = 'false') {
            return 510 "You'll need to be on the Tailnet for access.";
        }
        {{ end }}

        proxy_pass http://homeassistant;
    }

    location /api/webhook {
        proxy_pass http://homeassistant;
    }
}
