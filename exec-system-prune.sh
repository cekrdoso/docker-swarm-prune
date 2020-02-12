#!/bin/sh -e

SYSTEM_PRUNE_SCHEDULE=${SYSTEM_PRUNE_SCHEDULE-}
SYSTEM_PRUNE_INTERVAL=${SYSTEM_PRUNE_INTERVAL:-86400}
PRUNE_VOLUMES=${PRUNE_VOLUMES:-false}

PRUNE_CMD="docker system prune -af"
[ "${PRUNE_VOLUMES}x" = "truex" ] && PRUNE_CMD="${PRUNE_CMD} --volumes"

echo SYSTEM_PRUNE_SCHEDULE: ${SYSTEM_PRUNE_SCHEDULE}
echo SYSTEM_PRUNE_INTERVAL: ${SYSTEM_PRUNE_INTERVAL}
echo PRUNE_VOLUMES: ${PRUNE_VOLUMES}
echo PRUNE_CMD: ${PRUNE_CMD}

echo "$(date) START"

system_prune() {
	echo "$(date) Running system prune..."
	${PRUNE_CMD}
}

if [ "${SYSTEM_PRUNE_SCHEDULE}x" = "x" ]; then
		while true; do
			sleep ${SYSTEM_PRUNE_INTERVAL}
			system_prune
		done
else
	while true; do
		sleep 60
		EXEC_PRUNE=0
		for SCHED in ${SYSTEM_PRUNE_SCHEDULE}; do
			DATE_FORMAT=${SCHED%%@*}
			SCHED_TIME=${SCHED##*@}
			FORMATED_NOW=$(date +"${DATE_FORMAT}")
			[ "${FORMATED_NOW}x" = "${SCHED_TIME}x" ] && EXEC_PRUNE=1 && break
		done
		[ ${EXEC_PRUNE} -eq 0 ] && continue || system_prune
	done
fi
