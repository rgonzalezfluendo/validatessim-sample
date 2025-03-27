FROM archlinux:latest

# Update system and install GStreamer
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
       gstreamer \
       gst-plugins-base \
       gst-plugins-good \
       gst-plugins-bad \
       gst-plugins-ugly \
       gst-libav \
       gst-python \
       gst-devtools \
    && pacman -Scc --noconfirm


RUN gst-inspect-1.0 --version
RUN gst-inspect-1.0 --version
