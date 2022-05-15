FROM nginx

# Copy demo page
COPY --from=saverops/janus-gateway:0.10.7 /root/janus-gateway/html /usr/share/nginx/html
RUN sed -i -e 's/gatewayCallbacks\.server/`ws:\/\/${window.location.hostname}:8188`/g' /usr/share/nginx/html/janus.js

CMD ["nginx", "-g", "daemon off;"]
