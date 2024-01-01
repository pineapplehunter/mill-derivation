millSetupPreConfigureHook() {
    echo "Executing millSetupPreConfigureHook"
    export COURSIER_CACHE=$millDeps/coursier
    mill resolve _ > /dev/null
    diff $millDeps/checkDeps.txt <(COURSIER_CACHE=$millDeps/coursier bash $millDeps/checkDeps.sh)
    echo "Finished millSetupPreConfigureHook"
}

if [ -z "${dontMillSetupPreConfigureHook-}" ]; then
  preConfigureHooks+=(millSetupPreConfigureHook)
fi