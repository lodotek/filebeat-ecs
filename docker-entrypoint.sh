#!/bin/bash

set -e

# Add filebeat as command if needed
if [ "${1:0:1}" = '-' ]; then
        set -- filebeat "$@"
fi

# ECS will report the docker interface without help, so we override that with host's private ip
#if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then
#fi

if [ "$ELASTICSEARCH_HOSTS" == "" ]; then
        ELASTICSEARCH_HOSTS="localhost:9200"
fi

# Create the config file
cat > /etc/filebeat/filebeat.yml <<-EOF
filebeat:
  # List of prospectors to fetch data.
  prospectors:
    # Each - is a prospector. Below are the prospector specific configurations
    -
      # Paths that should be crawled and fetched. Glob based paths.
      # For each file found under this path, a harvester is started.
      paths:
        - "/var/log/*.log"
        - "/var/log/*/*.log"


      # Type of the files. Based on this the way the file is read is decided.
      # The different types cannot be mixed in one prospector
      #
      # Possible options are:
      # * log: Reads every line of the log file (default)
      # * stdin: Reads the standard in
      input_type: log

# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.
output:
  ### Elasticsearch as output
  elasticsearch:
    # Array of hosts to connect to.
     hosts: ["$ELASTICSEARCH_HOSTS"]
EOF



# Drop root privileges if we are running filebeat
if [ "$1" = 'filebeat' ]; then
    # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
    #    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data

    set -- "$@"
    exec gosu daemon filebeat -e -v "$@"
else
	# As argument is not related to elasticsearch,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi

