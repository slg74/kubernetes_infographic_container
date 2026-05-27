FROM nginx:alpine

# Copy all infographic HTML files
COPY k8s-interfaces-cni-cri-csi.html /usr/share/nginx/html/
COPY k8s-orchestration.html          /usr/share/nginx/html/
COPY k8s-networking.html             /usr/share/nginx/html/
COPY index.html                      /usr/share/nginx/html/

EXPOSE 80
