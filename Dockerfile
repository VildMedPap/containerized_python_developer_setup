# STAGE 1: Base ---------------------------------------------------------------
# This is the base stage where production dependencies will be installed. This
# stage is also used in development as well as the libraries installed will be
# copied to production stage. NB: important to use --user flag on pip install!
# --------------------------------------------------------------------- (BEGIN)
FROM python:3.8 as base
COPY requirements.prod.txt requirements.prod.txt
RUN pip install --user --no-cache-dir -r requirements.prod.txt
# ----------------------------------------------------------------------- (END)



# STAGE 2: Development --------------------------------------------------------
# This stage build upon the base stage and in addition will install development
# dependencies and run jupyter lab. NB: no COPY of source file instead the
# source code will be reachable through a bind mount.
# --------------------------------------------------------------------- (BEGIN)
FROM base as dev
EXPOSE 8888
ENV PATH=/root/.local/bin:$PATH
COPY requirements.dev.txt requirements.dev.txt
RUN pip install --user --no-cache-dir -r requirements.dev.txt
WORKDIR /app
CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root" ]
# ----------------------------------------------------------------------- (END)



# STAGE 3: Production ---------------------------------------------------------
# This stage COPY libraries from the base stage as well as COPYing in the
# source code.
# --------------------------------------------------------------------- (BEGIN)
FROM python:3.8-slim as prod
ENV PATH=/root/.local/bin:$PATH
COPY --from=base /root/.local /root/.local
COPY . .
ENTRYPOINT [ "python3", "app.py" ]
# ----------------------------------------------------------------------- (END)