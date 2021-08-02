FROM python:3.9.6-slim-buster as builder
RUN apt update && apt install -y git
RUN git clone --depth 1 --branch amazon-neptune-tools-1.2 https://github.com/awslabs/amazon-neptune-tools /amazon-neptune-tools

FROM python:3.9.6-slim-buster

# Install the neptune_python_utils dependencies.
RUN pip install gremlinpython requests backoff

# Pin specific versions of Jupyter and Tornado dependency.
RUN pip install 'notebook==5.7.10' && \
    pip install 'tornado==4.5.3' && \
    pip install 'rdflib==5.0.0'

# Install the graph-notebook package.
RUN pip install 'graph-notebook==3.0.2'

# Install and enable the visualization widget.
RUN jupyter nbextension install --py --sys-prefix graph_notebook.widgets
RUN jupyter nbextension enable  --py --sys-prefix graph_notebook.widgets

# Copy static html resources.
RUN python -m graph_notebook.static_resources.install

RUN python -m graph_notebook.nbextensions.install

# Create default notebooks location and copy premade starter notebooks.
RUN mkdir /notebooks

RUN python -m graph_notebook.notebooks.install --destination /notebooks

# Add non-privileged user.
RUN groupadd jupyter && \
    useradd -g jupyter -m -s /bin/bash jupyter

# Make the default notebook location writable by the default user.
RUN chown -R jupyter:jupyter /notebooks

# Change directory to the default notebook location.
WORKDIR /notebooks

# Run the service as jupyter user.
USER jupyter

# Copy the Amazon neptune-python-tools.
COPY --from=builder /amazon-neptune-tools/neptune-python-utils /home/jupyter

# Copy the neptune helper.
COPY neptune_helper.py /home/jupyter

# Allow the the neptune-python-tools module to be loaded in Python.
ENV PYTHONPATH="/home/jupyter"

# Run jupyter notebook on start.
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888"]

# Point "jupyter notebook" to the default notebooks location if no arguments
# are supplied.
CMD ["/notebooks"]
