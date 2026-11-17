FROM debian:13-slim

# Install system dependencies required for Flutter Linux desktop apps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    unzip \
    libglib2.0-0 \
    libgtk-3-0 \
    libwebkit2gtk-4.1-0 \
    libmpv2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/mangayomi

# Fetch latest release zip URL from GitHub API and extract it
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/kodjodevf/mangayomi/releases/latest | grep "browser_download_url.*linux.zip" | cut -d '"' -f 4) \
    && curl -L -o mangayomi.zip "$DOWNLOAD_URL" \
    && unzip mangayomi.zip \
    && rm mangayomi.zip \
    && chmod +x mangayomi

# Set the executable entrypoint
ENTRYPOINT ["/opt/mangayomi/mangayomi"]
