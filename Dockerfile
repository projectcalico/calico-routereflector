# Copyright (c) 2015-2017 Tigera, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM alpine
LABEL maintainer "Neil Jerram <neil@tigera.io>"

CMD ["/sbin/my_init"]

ENV HOME /root

RUN echo "ipv6" >> /etc/modules
RUN echo "http://dl-1.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-2.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    echo "http://dl-5.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://dl-1.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    echo "http://dl-5.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Get prerequisite packages:
# - bash, as it is needed (at least according to the #! line) by a
#   lot of the following scripts and init infrastructure.
# - shadow, for 'groupadd'.
# - python3, for our 'my_init' wrapper.
RUN apk add --no-cache bash shadow python3

# Comment these lines out if using the developer-focused alternative instead.
ADD /image /build
RUN /build/install.sh && \
    /build/system_services.sh && \
    /build/cleanup.sh

ADD /dist/confd /confd

# Copy in our custom configuration files etc. We do this last to speed up
# builds for developer, as it's thing they're most likely to change.
COPY node_filesystem /
