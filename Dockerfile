FROM continuumio/miniconda:4.7.12
MAINTAINER Angel Angelov <aangeloo@gmail.com>

LABEL descrition="Docker image containing all requirements for the nextflow-bcl pipeline"

COPY environment.yml .
COPY testdata/ testdata/
RUN conda env update -n root -f environment.yml && conda clean -a
RUN apt-get update && apt-get install -y procps