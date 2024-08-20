FROM ruby:3.1

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem update --system 3.3.20 && \
    bundle install
RUN apt-get update && apt-get install -y graphviz
RUN apt-get install libmecab2 libmecab-dev mecab mecab-ipadic mecab-ipadic-utf8 mecab-utils
RUN apt-get install -y unidic-mecab
RUN apt-get install -y build-essential

# NEologd をインストール
# RUN git clone git@github.com:neologd/mecab-neologd.git /usr/local/mecab-neologd && \
#     cd /usr/local/mecab-neologd && \
#     ./bin/install-mecab-neologd

# 作業ディレクトリを設定
RUN sed -i 's/^dicdir/;dicdir/' /etc/mecabrc
RUN echo "\ndicdir = /var/lib/mecab/dic/unidic" >> /etc/mecabrc
# MeCab の設定を NEologd 辞書を使用するように更新
# RUN sed -i 's/^dicdir/;dicdir/' /etc/mecabrc && \
#     echo "\ndicdir = /usr/local/mecab-neologd/mecab-ipadic-neologd" >> /etc/mecabrc
    
COPY . /app