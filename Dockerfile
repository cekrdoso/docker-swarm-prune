FROM docker:latest

COPY exec-system-prune.sh /exec-system-prune.sh

RUN apk --no-cache add tzdata \
  && chmod +x /exec-system-prune.sh

CMD ["/exec-system-prune.sh"]
