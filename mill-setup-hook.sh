millSetupPreConfigureHook() {
    echo "Executing millSetupPreConfigureHook"

    if [ -z "${millDeps-}" ]; then
      echo "mill setup > millDeps not set"
      echo "mill setup > set it in derivation"
      exit 1
    fi
    
    export COURSIER_CACHE=$millDeps/coursier

    if [ ! -z "${millCheckDeps-}" ];then
      mill resolve _ > /dev/null

      if diff $millDeps/checkDeps.txt <(COURSIER_CACHE=$millDeps/coursier bash $millDeps/checkDeps.sh); then
        echo "mill setup > deps check OK"
      else
        echo "mill setup > deps check failed"
        echo "mill setup > Update deps hash in nix"
        exit 1
      fi
    fi

    echo "Finished millSetupPreConfigureHook"
}

if [ -z "${dontMillSetupPreConfigureHook-}" ]; then
  preConfigureHooks+=(millSetupPreConfigureHook)
fi