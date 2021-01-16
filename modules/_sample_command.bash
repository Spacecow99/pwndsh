
#
# Command help function that prints when help <command> is invoked.
#     __<command>_usage() -> 0
#
function __example_usage() {
    cat << EOF
usage: example [FIRSTNAME] [LASTNAME]
    Prints a greeting for an individual by first & last name.
    This command acts as the basis for an example command structure.

    FIRSTNAME   First name of person to greet.
    LASTNAME    Last name of person to greet.

EOF
    return 0
}

#
# The function that contains the core command logic.
#    <command>()
#
function example() {

    if [ -z "${1-}" -o -z "${2-}" ]; then
        __agent_usage
        return 0
    fi

    local first_name="${1-}"
    local last_name="${2-}"
    printf "Greetings, ${first_name} ${last_name}\n"
}

#
# Register the command using the pwnd_register_cmd function.
#     pwnd_register_cmd <command> "<short help string>"
#
pwnd_register_cmd example "Prints a greeting for an individual."
