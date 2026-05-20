{ lib, stdenvNoCC, v2ray-geoip, v2ray-domain-list-community }:

stdenvNoCC.mkDerivation {
  name = "mihomo-geodata";

  buildCommand = ''
    mkdir -p $out
    cp ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/GeoSite.dat
    cp ${v2ray-geoip}/share/v2ray/geoip.dat $out/GeoIP.dat
  '';

  meta = {
    description = "Geo data files (GeoSite.dat, GeoIP.dat) for mihomo";
    platforms = lib.platforms.all;
  };
}
