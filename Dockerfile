FROM ubuntu:20.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y git curl wget zsh build-essential vim tmux tzdata

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh/tools/install.sh)"

SHELL ["/bin/zsh", "-c"]

RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh && chmod +x Miniconda3-py38_4.9.2-Linux-x86_64.sh
RUN bash ./Miniconda3-py38_4.9.2-Linux-x86_64.sh -b
RUN rm ./Miniconda3-py38_4.9.2-Linux-x86_64.sh
ENV PATH /root/miniconda3/bin:$PATH
RUN conda init zsh

#Create new environment and install some dependencies.
RUN conda create -y -n common python=3.7
RUN echo "conda activate common" >> /root/.zshrc

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package

#RUN wget https://github.com/cdr/code-server/releases/download/v3.9.0/code-server_3.9.0_amd64.deb
COPY code-server_3.9.0_amd64.deb .
RUN dpkg -i code-server_3.9.0_amd64.deb
RUN rm code-server_3.9.0_amd64.deb

RUN mkdir /workspace
WORKDIR /workspace

EXPOSE 8080
