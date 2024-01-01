{ callPackage }: {
  millSetupHook = callPackage ./mill-setup-hook.nix { };
  millFetchDeps = callPackage ./mill-fetch-deps.nix { };
}
