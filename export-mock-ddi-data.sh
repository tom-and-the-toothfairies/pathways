#!/bin/bash
usage() {
cat <<EOF
Export a CSV file of Drug-Drug interactions from the Pathways system.

Writes mock enriched DDI data out to <outfile>

Resultant CSV file is of the format:
  Drug 1, Drug 2, DDI Type, Time, Unit

Usage:
    $0 <agonism|harmful> <outfile>
EOF
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
            sudo docker-compose -p export run asclepius python3 asclepius/enrich.py "$flavour" > "$outfile"
            sudo docker-compose -p export down
            exit 0
        ;;

        *)
            usage
            exit 1
        ;;
    esac
}

main "$@"
