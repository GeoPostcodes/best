FROM python:3.7.4-alpine

# Add new user to new group, with same gid and uid as host user
RUN addgroup  -S -g 1000 appuser 
RUN adduser -S -u 1000 appuser appuser
    # Install git to get code, install build base to install needed libraries
RUN apk add git --no-cache
    # Packages necessary for building C code from python (numpy, pandas, ...)
RUN apk add build-base --no-cache
    # Packages necessary for pyproj (from the testing repository)
RUN apk add proj proj-util proj-dev --repository=http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache
WORKDIR /home/appuser
RUN git clone https://github.com/oSoc19/best
WORKDIR best 
RUN pip install --no-cache-dir -r requirements.txt
# Maybe it is useful to implement these commands later, to make the final image smaller.
# Note: All the RUN commands in this dockerfile should be merged into one command (RUN command_1 && command_2 ...) , 
# otherwise an extra layer is created that marks the file removal, instead of actually removing these parts of the image.
#    apk del git &&\
#    apk del build-base
# Make an output directory for bind mount (so the files from this container are accessible to the host machine)
RUN mkdir out
RUN chown -R appuser:appuser /home/appuser 
USER appuser
WORKDIR /home/appuser