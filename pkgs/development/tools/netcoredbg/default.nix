{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, pkgs }:

stdenv.mkDerivation {
  pname = "netcoredbg";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "netcoredbg";
    rev = "4fcfbba3a196d3dd4500eab1154c8fd6295d2162"; # tagged 'latest'
    sha256 = "0szvzra5d79ssnbgq25q1d0fjghks5d6namrgrv6zbgqxn37vbxj";
  };

  nativeBuildInputs = [ pkgconfig cmake pkgs.git ];

  meta = with stdenv.lib; {
    description = "A managed code debugger with MI interface for CoreCLR";
    longDescription = ''The debugger provides GDB/MI or VSCode Debug Adapter protocol and allows to debug .NET apps under .NET Core runtime.'';
    homepage = https://github.com/Samsung/netcoredbg/;
    license = licenses.mit;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
