#!/bin/sh
DIR=~/Documents/ObsidianNotes/
GIT_DIR=$DIR.git

if [ -d "$GIT_DIR" ]; then

    anyUpdatedFiles=$(git --git-dir "$GIT_DIR" --work-tree=$DIR status -s)

    if [ ! -z "$anyUpdatedFiles" ]; then
        add=$(git --git-dir "$GIT_DIR" --work-tree=$DIR add -A)
        commit=$(git --git-dir "$GIT_DIR" --work-tree=$DIR commit -m "weekly commit")
        pull=$(git --git-dir "$GIT_DIR" --work-tree=$DIR pull --rebase --no-log origin master)
        conflicts_num=$(echo $pull | grep -o "CONFLICT" | wc -l)

        if [ $conflicts_num != 0 ]; then
            for i in {1..$conflicts_num}
                do
                    # in case of merge conflict just add corrupted file as it is
                    add=$(git --git-dir "$GIT_DIR" --work-tree=$DIR add -A)
                    # and continue rebasing
                    continue_rebase=$(git --git-dir "$GIT_DIR" --work-tree=$DIR rebase --continue)
                done
        fi
        push=$(git --git-dir "$GIT_DIR" --work-tree=$DIR push origin master)
    fi
fi

exit 0