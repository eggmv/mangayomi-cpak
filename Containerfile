FROM debian:13-slim

# Install system dependencies required by the Flutter Linux desktop bundle
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    unzip \
    jq \
    libglib2.0-0 \
    libgtk-3-0 \
    libwebkit2gtk-4.1-0 \
    libmpv2 \
    libegl1 \
    libgl1 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb1 \
    libxcb-cursor0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/mangayomi

# Download the Linux ZIP asset explicitly and fail immediately if it is unavailable.
RUN DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/kodjodevf/mangayomi/releases/latest \
        | jq -r '.assets[].browser_download_url | select(test("-linux\\.zip$"))' | head -n 1) \
    && test -n "$DOWNLOAD_URL" \
    && curl -fL -o mangayomi.zip "$DOWNLOAD_URL" \
    && unzip -q mangayomi.zip \
    && rm mangayomi.zip \
    && APP_BINARY=$(find /opt/mangayomi -type f -name mangayomi -perm /111 | head -n 1) \
    && test -n "$APP_BINARY" \
    && chmod +x "$APP_BINARY" \
    && ln -sfn "$APP_BINARY" /opt/mangayomi/mangayomi

# Copy the desktop entry used by Containerpak and desktop launchers.
COPY Mangayomi.desktop /usr/share/applications/Mangayomi.desktop

ENV LD_LIBRARY_PATH=/opt/mangayomi/lib:/opt/mangayomi/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib

ENTRYPOINT ["/opt/mangayomi/mangayomi"]
