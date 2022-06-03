eval $(std.sh)

use args
use log

log_format() {
  @args lvl msg...
  echo ":: [test-main] [$lvl] ${msg[@]}"
}

main() {
  @args

  cd "$(dirname "${argv[0]}")"
  for t in test-*.sh; do
    log note "Running $t..."
    ./$t
    log note "Finished $t."
  done
  exit 0
}

main "$@"
