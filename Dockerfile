FROM ubuntu:20.04

RUN sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt update && \
    apt install git curl wget zsh build-essential vim tmux 

RUN sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ohmyzsh/ohmyzsh/tools/install.sh)"

SHELL ["/bin/zsh", "-c"]

RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_4.8.2-Linux-x86_64.sh && chmod +x Miniconda3-py38_4.8.2-Linux-x86_64.sh 
RUN bash ./Miniconda3-py38_4.8.2-Linux-x86_64.sh -b 
RUN rm ./Miniconda3-py38_4.8.2-Linux-x86_64.sh
RUN echo > ~/.bashrc
RUN conda init zsh

#Create new environment and install some dependencies.
RUN conda create -y -n common python=3.7
RUN echo "conda activate common" >> /root/.zshrc

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package

RUN mkdir /workspace

WORKDIR /workspace

