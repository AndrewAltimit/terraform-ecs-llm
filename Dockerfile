FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
LABEL maintainer="Andrew Showers"

# Use login shell to read variables from `~/.profile` (to pass dynamic created variables between RUN commands)
SHELL ["sh", "-lc"]

# Set debian to noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system updates
RUN apt update && apt install -y git libsndfile1-dev tesseract-ocr espeak-ng python3 python3-pip ffmpeg git-lfs && \
	python3 -m pip install --no-cache-dir --upgrade pip && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Setup Web App
COPY text-generation-webui /text-generation-webui
RUN python3 -m pip install --no-cache-dir -r /text-generation-webui/requirements.txt
EXPOSE 7860

# Setup Entrypoint
COPY start-ai.py /start-ai.py
RUN python3 -m pip install --no-cache-dir cloudpathlib
ENTRYPOINT ["python", "start-ai.py"]

