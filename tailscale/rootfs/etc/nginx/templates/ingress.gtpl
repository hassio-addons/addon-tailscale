server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location / {
        allow   172.30.32.2;
        deny    all;

        proxy_pass http://backend;

        sub_filter_once off;
        sub_filter 'document.location.href = url' 'var result = window.open(url, "_blank"); if (result!== null) {result.focus()} else {document.write(\'<div style="background-color:white"><font color=black>Unable to open Tailscale in new window.  Please copy this URL, open it in a separate browser, and re-load the addon Web UI here when complete.   <a href="\' + url + \'">\'+url+\'</a></font></div>\')}';

    }
}
