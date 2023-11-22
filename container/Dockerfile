FROM alpine:latest

RUN apk add --no-cache jq sed gawk coreutils bash

USER nobody:nobody
WORKDIR /home/nobody

COPY --chmod=0755 apisec_cli get_job.sh run_job.sh /home/nobody/

ENV PANOPTICA_CLI_ACCESS_KEY=blank
ENV PANOPTICA_CLI_SECRET_KEY=blank

CMD [ "bash" ]
