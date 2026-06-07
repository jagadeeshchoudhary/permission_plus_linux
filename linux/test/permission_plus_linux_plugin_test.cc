#include <flutter_linux/flutter_linux.h>
#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "permission_plus_linux_plugin_private.h"

// Tests for the permission_plus_linux plugin's C implementation.

namespace permission_plus_linux {
namespace test {

TEST(PermissionPlusLinuxPlugin, CheckPermissionReturnsGranted) {
  // On standard Linux desktop, all permissions should return GRANTED.
  permission_plus_linuxPermissionStatusMessage status =
      get_permission_status(PERMISSION_PLUS_LINUX_PERMISSION_TYPE_MESSAGE_CAMERA);
  EXPECT_EQ(status, PERMISSION_PLUS_LINUX_PERMISSION_STATUS_MESSAGE_GRANTED);
}

TEST(PermissionPlusLinuxPlugin, AllPermissionTypesReturnGranted) {
  // Verify multiple permission types all return granted.
  permission_plus_linuxPermissionTypeMessage types[] = {
      PERMISSION_PLUS_LINUX_PERMISSION_TYPE_MESSAGE_CAMERA,
      PERMISSION_PLUS_LINUX_PERMISSION_TYPE_MESSAGE_MICROPHONE,
      PERMISSION_PLUS_LINUX_PERMISSION_TYPE_MESSAGE_LOCATION,
  };

  for (auto type : types) {
    EXPECT_EQ(get_permission_status(type),
              PERMISSION_PLUS_LINUX_PERMISSION_STATUS_MESSAGE_GRANTED);
  }
}

}  // namespace test
}  // namespace permission_plus_linux
