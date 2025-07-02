# Base oficial com CUDA para poderes invocar a força do GPU
FROM nvidia/cuda:12.1.1-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Lisbon

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-venv git curl wget locales ca-certificates build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configurar UTF-8 no templo com o teu fado: pt_PT.UTF-8
RUN locale-gen pt_PT.UTF-8
ENV LANG pt_PT.UTF-8
ENV LANGUAGE pt_PT:pt
ENV LC_ALL pt_PT.UTF-8

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel

RUN mkdir -p /workspace/pip_cache /workspace/hf_cache /workspace/mythomax_finetuned_final /workspace/dataset

WORKDIR /workspace

RUN pip install --cache-dir /workspace/pip_cache torch==2.5.1+cu121 torchvision==0.20.1+cu121 torchaudio==2.5.1+cu121 --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install --cache-dir /workspace/pip_cache bitsandbytes==0.39.0 && \
    pip install --cache-dir /workspace/pip_cache accelerate==0.21.0 && \
    pip install --cache-dir /workspace/pip_cache datasets==2.12.0 && \
    pip install --cache-dir /workspace/pip_cache transformers==4.30.2 && \
    pip install --cache-dir /workspace/pip_cache scipy protobuf==4.23.3 sentencepiece==0.1.99

ENV HF_HOME=/workspace/hf_cache
ENV TRANSFORMERS_CACHE=/workspace/hf_cache
ENV HF_DATASETS_CACHE=/workspace/hf_cache

VOLUME ["/workspace"]

CMD ["/bin/bash"]