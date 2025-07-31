#! /usr/bin/env nix-shell
#! nix-shell -i bash -p fzf bash nix-output-monitor deploy-rs

call_rebuild(){
  hostname=$1
  shift
  sudo -v
  sudo nixos-rebuild $@ --flake /etc/nixos#$hostname --log-format internal-json -v |& nom --json
}
call_deploy(){
  name=$1
  shift
  sudo -v
  sudo deploy /etc/nixos/#$name -s $@ -- --show-trace --no-warn-dirty  --log-format internal-json -v |& nom --json

}
SERVERS="\
pedro
monolith\
"
SERVER=$(echo -e "$SERVERS" | fzf)
if [[ ! "$SERVER" ]]; then
  exit 0
fi
ACTIONS="\
switch
build
test
"
ACTION=$(echo -e "$ACTIONS" | fzf)
if [[ ! "$ACTION" ]]; then
  exit 0
fi

read -p "Add extra Args? " -n 1 -r
echo
echo "input args: "
ARGS=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
read -r ARGS
fi
echo "$SERVER -> $ACTION WITH $ARGS"
read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo
  echo "aborting"
  exit 0
fi
case "$SERVER" in
  "pedro")
    call_rebuild "pedro" $ACTION  $ARGS
  ;;
  "monolith")
    case "$ACTION" in
      "switch")
      call_deploy "monolith" $ARGS
      ;;
      "build")
      call_rebuild $ACTION $ARGS
      ;;
      "test")
      echo "invalid"
      ;;

    esac 
  ;;
esac
