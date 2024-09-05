{
  makeSetupHook,
  mill,
  jq,
}:

makeSetupHook {
  name = "mill-setup-hook.sh";
  propagatedBuildInputs = [
    mill
    jq
  ];
} ./mill-setup-hook.sh
