{ ... }:

{
  virtualisation.qemu.guest.enable = true;

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
}
