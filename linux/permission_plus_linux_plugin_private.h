#include <flutter_linux/flutter_linux.h>

#include "include/permission_plus_linux/permission_plus_linux_plugin.h"
#include "permission_plus_api.g.h"

// This file exposes some plugin internals for unit testing. See
// https://github.com/flutter/flutter/issues/88724 for current limitations
// in the unit-testable API.

// Returns the permission status for a given permission type.
// On standard Linux desktops, all permissions are granted.
permission_plus_linuxPermissionStatusMessage get_permission_status(
    permission_plus_linuxPermissionTypeMessage permission);
