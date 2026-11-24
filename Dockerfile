FROM debian:bookworm-slim

ARG pandoc_version=3.14
ARG pandoc_deb=pandoc-${pandoc_version}-1-amd64.deb
ADD https://github.com/jgm/pandoc/releases/download/${pandoc_version}/${pandoc_deb} /tmp/

RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    fonts-inconsolata \
    git \
    gnuplot \
    imagemagick \
    inkscape \
    latexmk \
    libreoffice \
    make \
    octave \
    pipx \
    poppler-utils \
    python3-cairosvg \
    python3-pip \
    python3-pygments \
    source-highlight \
    ssh-client \
    texlive-full \
    wget \
    xfig \
    zip \
    /tmp/${pandoc_deb} \
    && apt-get clean \
    && rm -fr /usr/share/doc/texlive-doc /tmp/${pandoc_deb}

# https://stackoverflow.com/questions/53377176/change-imagemagick-policy-on-a-dockerfile
ARG imagemagic_config=/etc/ImageMagick-6/policy.xml
RUN if [ -f $imagemagic_config ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $imagemagic_config ; else echo did not see file $imagemagic_config ; fi

RUN python3 -m pipx ensurepath \
    && pipx install pandoc-fignos \
    && pipx install pandoc-eqnos \
    && pipx install pandoc-tablenos \
    && pipx install pandoc-secnos
