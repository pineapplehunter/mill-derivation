{ makeSetupHook, mill, jq }: makeSetupHook
{
  name = "mill-setup-hook.sh";
  deps = [ mill jq ];
} ./mill-setup-hook.sh
