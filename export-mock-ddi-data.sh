#!/bin/bash
usage() {
cat <<EOF
Export a CSV file of Drug-Drug interactions from the Pathways system.

Writes out to <outfile>

Resultant CSV file is of the format:
  drug_a, drug_b, {agonism or harmful}, time, unit

Usage:
    $0 <agonism|harmful> <outfile>
EOF
}


loading() {
    echo 'Exporting'
    while true; do
        printf "\r | "
        sleep 0.125
        printf "\r / "
        sleep 0.125
        printf "\r - "
        sleep 0.125
        printf "\r \\ "
        sleep 0.125
    done
}


main() {
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi

    local readonly flavour="$1"
    local readonly outfile="$2"

    case "$flavour" in
        harmful|agonism)
            loading &
            local readonly LOADING_SPINNER_PID="$!";
            trap  "kill $LOADING_SPINNER_PID 2>&1 > /dev/null; exit" SIGTERM SIGKILL SIGINT
            disown

            sudo docker-compose \
                -p export_ddis run \
                --rm asclepius python3 asclepius/enrich.py "$flavour" \
                > "$outfile"

            sudo docker-compose -p export_ddis down

            kill "$LOADING_SPINNER_PID";
            exit 0
        ;;

        *)
            usage
            exit 1
        ;;
    esac
}

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

main "$@"
