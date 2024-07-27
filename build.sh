#!/bin/sh

: ${SOFLE_ROOT:=~jeff/devel/sofle-hybrid-ergomech}
: ${WEST_ROOT:=~jeff/devel/zmk-default/app}
: ${HELPERS_ROOT:=~jeff/devel/urob/zmk-helpers}
# : ${VENV_ROOT:=~jeff/venv/zmk}

printf "SOFLE_ROOT: %s\\n" "$SOFLE_ROOT"
printf "WEST_ROOT:  %s\\n" "$WEST_ROOT"


# https://github.com/zmkfirmware/zmk/tree/main/app/boards/shields/nice_view_adapter
MORE_SHIELDS="nice_view_adapter nice_view"
# MORE_SHIELDS="nice_view"
# MORE_SHIELDS=""

# SNIPPETS="-S zmk-usb-logging"

SNIPPETS="-S studio-rpc-usb-uart -S zmk-usb-logging"

cd "$WEST_ROOT"
board="nice_nano_v2"
targets="sofle_ergomech_left sofle_ergomech_right settings_reset"
more=""
for target in $targets ; do
    echo "====="
    echo $target
    echo "====="
    case "$target" in
	*_left)
	    shields="$target $MORE_SHIELDS"
	    ;;
	*_right)
	    shields="$target $MORE_SHIELDS"
	    more="-DCONFIG_ZMK_STUDIO=n"
	    ;;
	*)
	    shields="$target"
	    more="-DCONFIG_ZMK_STUDIO=n"
	    ;;
    esac
    old=$-
    set -x
    west build -b $board -d build/$target -p $SNIPPETS -- \
	 -DSHIELD="${shields% }" \
	 -DZMK_CONFIG=$SOFLE_ROOT/config \
	 -DZMK_EXTRA_MODULES="$SOFLE_ROOT;$HELPERS_ROOT" \
	 $more
    set +x
    echo $old | fgrep -q x && set -x
    echo "====="
done

echo "====="
echo " tar"
echo "====="
now=$(date +%Y-%m-%d_%H%M)

tmp=$(mktemp -d)
echo $tmp
cleanup() {
    rm -rf "$tmp"
}
trap cleanup EXIT
trap 'trap - EXIT; cleanup; exit 1' HUP INT QUIT TERM

fw="$tmp/firmware_$now"

mkdir $fw
for target in $targets ; do
    cp -vp "build/$target/zephyr/zmk.uf2" "$fw/$target.$now.uf2"
done

git -C $SOFLE_ROOT diff > "$fw/git.diff"
git -C $SOFLE_ROOT status > "$fw/git.status"
git -C $SOFLE_ROOT log -1 > "$fw/git.log"

tf="$SOFLE_ROOT/archive/firmware.$now.tar"
tar -cf "$tf" -C $tmp firmware_$now
rm -rf $tmp
echo $(realpath $tf)
tar -xvf $tf -C "$SOFLE_ROOT"

