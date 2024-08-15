FROM nginx

# Install Dependencies
RUN apt-get update -y && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Copy demo page
RUN git clone https://github.com/meetecho/janus-gateway.git --depth 1 ~/janus-gateway && \
      rm -rf /usr/share/nginx/html && \
      mv ~/janus-gateway/html /usr/share/nginx/html && \
      sed -i -e 's/gatewayCallbacks\.server/`ws:\/\/${window.location.hostname}:8188`/g' /usr/share/nginx/html/demos/janus.js && \
      rm -rf ~/janus-gateway

CMD ["nginx", "-g", "daemon off;"]
