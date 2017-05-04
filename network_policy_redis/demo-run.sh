tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/split1_lhs.sh" \; \
    split-window -h -d "sleep 4; $(dirname $BASH_SOURCE)/split1_rhs.sh" \; \
    attach \;

