{ mkDerivation, qtbase
, lib, extra-cmake-modules, gettext, python
, drumstick, fluidsynth
, kcoreaddons, kcrash, kdoctools
, qtquickcontrols2, qtsvg, qttools, qtdeclarative
}:

mkDerivation {
  pname = "minuet";
  meta = with lib; {
    license = with licenses; [ lgpl21 gpl3 ];
    maintainers = with maintainers; [ peterhoeg HaoZeke ];
    broken = lib.versionOlder qtbase.version "5.14";
  };

  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python qtdeclarative ];

  propagatedBuildInputs = [
    drumstick fluidsynth
    kcoreaddons kcrash
    qtquickcontrols2 qtsvg qttools
  ];

  enableParallelBuilding = true;
}
