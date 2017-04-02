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
        exit 2
    fi

    local readonly flavour="$1"; shift
    local readonly outfile="$1"; shift
    case "$flavour" in
        harmful|agonism)
            loading &
            local readonly LOAD_PID="$!";
            trap  "kill $LOAD_PID 2>&1 > /dev/null; exit" SIGTERM SIGKILL SIGINT
            disown
            docker-compose --file docker-compose.dev.yml \
                run --rm asclepius python3 asclepius/enrich.py "$flavour" \
                > "$outfile"
            kill "$LOAD_PID";
            exit 1
        ;;

        *)
            usage
            exit 2
        ;;
    esac
}

main "$@"
