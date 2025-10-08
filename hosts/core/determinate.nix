_: {
  isDeterminateNix =
    let
      receiptPath = "/nix/receipt.json";
      receiptExists = builtins.pathExists receiptPath;
      receiptContent = if receiptExists then builtins.readFile receiptPath else "{}";
      receiptJSON = builtins.fromJSON receiptContent;

      plannerSettingsDeterminateNixEnabled =
        receiptExists
        && receiptJSON ? planner
        && receiptJSON.planner ? settings
        && receiptJSON.planner.settings ? determinate_nix
        && receiptJSON.planner.settings.determinate_nix;
    in
    plannerSettingsDeterminateNixEnabled;

  # Generate activation script for Determinate Nix detection info
  mkDeterminateInfoScript =
    {
      isDeterminate ? null,
    }:
    let
      actualIsDeterminate =
        if isDeterminate != null then
          isDeterminate
        else
          let
            receiptPath = "/nix/receipt.json";
            receiptExists = builtins.pathExists receiptPath;
            receiptContent = if receiptExists then builtins.readFile receiptPath else "{}";
            receiptJSON = builtins.fromJSON receiptContent;

            plannerSettingsDeterminateNixEnabled =
              receiptExists
              && receiptJSON ? planner
              && receiptJSON.planner ? settings
              && receiptJSON.planner.settings ? determinate_nix
              && receiptJSON.planner.settings.determinate_nix;
          in
          plannerSettingsDeterminateNixEnabled;
    in
    {
      supportsDryActivation = true;
      text =
        if actualIsDeterminate then
          ''
            echo "✓ Determinate Nix detected - nix-darwin Nix management disabled"
            echo "  Nix installation managed by Determinate Systems"
            echo "  Some nix-darwin features (like nix.* options) are unavailable"
            echo "  For Nix configuration, use: /etc/nix/nix.conf or ~/.config/nix/nix.conf"
          ''
        else
          ''
            echo "✓ Standard Nix installation detected - nix-darwin managing Nix"
            echo "  Full nix-darwin functionality available"
            echo "  Nix configuration managed through nix-darwin options"
          '';
    };
}
