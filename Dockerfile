# syntax = docker/dockerfile:1.2
FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/usr/local/nvidia/lib64:/usr/local/nvidia/bin
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
RUN --mount=type=cache,target=/var/cache/apt apt-get update -qq && apt-get install -qqy --no-install-recommends \
	make \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	wget \
	curl \
	llvm \
	libncurses5-dev \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libffi-dev \
	liblzma-dev \
	python-openssl \
	git \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
RUN curl https://pyenv.run | bash && \
	git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest && \
	pyenv install-latest "3.9" && \
	pyenv global $(pyenv install-latest --print "3.9") && \
	pip install "wheel<1"
#COPY .cog/tmp/build2993968838/cog-0.0.1.dev-py3-none-any.whl /tmp/cog-0.0.1.dev-py3-none-any.whl
# RUN --mount=type=cache,target=/root/.cache/pip pip install /tmp/cog-0.0.1.dev-py3-none-any.whl
RUN --mount=type=cache,target=/var/cache/apt apt-get update -qq && apt-get install -qqy libgl1-mesa-glx libglib2.0-0 && rm -rf /var/lib/apt/lists/*
RUN --mount=type=cache,target=/root/.cache/pip pip install   numpy==1.19.4 torch==1.11.0 transformers==4.17.0 polars==0.13.11 datasets==1.18.4 tokenizers==0.11.6 wandb==0.10.28 einops==0.3.0 ftfy==6.0.1 lm_dataformat==0.0.19 pybind11==2.6.2
WORKDIR /src
# CMD ["python", "-m", "cog.server.http"]
COPY . /src
