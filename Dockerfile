ARG NODE_VERSION=18
FROM n8nio/base:${NODE_VERSION}

ARG N8N_VERSION
RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

ENV N8N_VERSION=1.39.1
ENV NODE_ENV=production
ENV N8N_RELEASE_TYPE=stable
RUN set -eux; \
	npm install -g --omit=dev n8n@${N8N_VERSION} --ignore-scripts && \
	npm rebuild --prefix=/usr/local/lib/node_modules/n8n sqlite3 && \
	rm -rf /usr/local/lib/node_modules/n8n/node_modules/@n8n/chat && \
	rm -rf /usr/local/lib/node_modules/n8n/node_modules/n8n-design-system && \
	rm -rf /usr/local/lib/node_modules/n8n/node_modules/n8n-editor-ui/node_modules && \
	find /usr/local/lib/node_modules/n8n -type f -name "*.ts" -o -name "*.js.map" -o -name "*.vue" | xargs rm -f && \
	rm -rf /root/.npm

# Install Ghostscript, Tesseract-OCR, and x11-utils
USER root
RUN apt-get update && apt-get install -y \
    ghostscript \
    tesseract-ocr \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /

RUN \
	mkdir .n8n && \
	chown node:node .n8n
ENV SHELL /bin/sh
USER node
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
