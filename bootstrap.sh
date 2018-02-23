#!/usr/bin/env bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
yum -y install filebeat
