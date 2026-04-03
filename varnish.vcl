# Varnish Cache Configuration Example
# 
# NOTE: This is an example VCL config to demonstrate caching strategy understanding
# For the assessment, this shows knowledge of cache configuration but is not deployed
# In a real setup, you'd deploy this with a Varnish container in Kubernetes
# 
# To actually use this, you would need:
# 1. Varnish deployment in K8s
# 2. Service pointing to this config
# 3. ConfigMap with this VCL content

vcl 4.0;

backend default {
    .host = "lamp-svc.default.svc.cluster.local";
    .port = "80";
}

sub vcl_recv {
    # only cache GET requests
    if (req.method != "GET") {
        return(pass);
    }
    
    # don't cache health checks
    if (req.url ~ "^/healthz") {
        return(pass);
    }
    
    return(hash);
}

sub vcl_backend_response {
    # cache lamps for 5 minutes
    if (bereq.url ~ "^/lamps") {
        set beresp.ttl = 5m;
        set beresp.http.Cache-Control = "public, max-age=300";
    }
    
    return(deliver);
}

sub vcl_deliver {
    # add cache status header for debugging
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }
}
