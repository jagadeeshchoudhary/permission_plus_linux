#include "include/permission_plus_linux/permission_plus_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "permission_plus_linux_plugin_private.h"

#define PERMISSION_PLUS_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), permission_plus_linux_plugin_get_type(), \
                              PermissionPlusLinuxPlugin))

struct _PermissionPlusLinuxPlugin {
  GObject parent_instance;
  FlPluginRegistrar* registrar;
};

G_DEFINE_TYPE(PermissionPlusLinuxPlugin, permission_plus_linux_plugin, g_object_get_type())

// ── Permission Status Helper ──────────────────────────────────────────────

permission_plus_linuxPermissionStatusMessage get_permission_status(
    permission_plus_linuxPermissionTypeMessage permission) {
  // On Linux desktop, native apps generally have unrestricted access to most
  // system resources (files, network, etc.) running as the current user.
  // We return 'GRANTED' for all permission types.
  //
  // NOTE: If this plugin were to support Sandboxed apps (Flatpak / Snap),
  // we would need to interface with xdg-desktop-portal (D-Bus) to request
  // permissions (e.g., Camera, Microphone, Location).
  // For standard Linux binaries, no such permission model exists.
  return PERMISSION_PLUS_LINUX_PERMISSION_STATUS_MESSAGE_GRANTED;
}

// ── Pigeon Host API Implementation ────────────────────────────────────────

static void check_permission_cb(
    permission_plus_linuxPermissionTypeMessage permission,
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  permission_plus_linux_permission_plus_host_api_respond_check_permission(
      response_handle, get_permission_status(permission));
}

static void request_permission_cb(
    permission_plus_linuxPermissionTypeMessage permission,
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  permission_plus_linux_permission_plus_host_api_respond_request_permission(
      response_handle, get_permission_status(permission));
}

static void request_permissions_cb(
    FlValue* permissions,
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  g_autoptr(FlValue) return_value = fl_value_new_list();

  if (fl_value_get_type(permissions) == FL_VALUE_TYPE_LIST) {
    size_t length = fl_value_get_length(permissions);
    for (size_t i = 0; i < length; i++) {
      FlValue* perm_val = fl_value_get_list_value(permissions, i);
      if (fl_value_get_type(perm_val) == FL_VALUE_TYPE_INT) {
        auto perm = static_cast<permission_plus_linuxPermissionTypeMessage>(
            fl_value_get_int(perm_val));

        // Create the map entry object
        g_autoptr(permission_plus_linuxPermissionStatusMapEntry) entry =
            permission_plus_linux_permission_status_map_entry_new(
                perm, get_permission_status(perm));

        // Convert the entry back to FlValue using Pigeon's internal encoding
        // Since we don't have access to the encode function directly, we use
        // Custom value wrapping.
        FlValue* custom_value = fl_value_new_custom(
            permission_plus_linux_permission_status_map_entry_type_id,
            entry, (GDestroyNotify)g_object_unref);

        fl_value_append_take(return_value, custom_value);
      }
    }
  }

  permission_plus_linux_permission_plus_host_api_respond_request_permissions(
      response_handle, return_value);
}

static void open_settings_cb(
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  // On Linux, there's no single "App Settings" page.
  // A best-effort approach would be to open GNOME Settings,
  // but it's not standardized across DEs. Returning false.
  permission_plus_linux_permission_plus_host_api_respond_open_settings(
      response_handle, FALSE);
}

static void should_show_rationale_cb(
    permission_plus_linuxPermissionTypeMessage permission,
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  permission_plus_linux_permission_plus_host_api_respond_should_show_rationale(
      response_handle, FALSE);
}

static void get_location_accuracy_cb(
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  permission_plus_linux_permission_plus_host_api_respond_get_location_accuracy(
      response_handle, PERMISSION_PLUS_LINUX_LOCATION_ACCURACY_MESSAGE_PRECISE);
}

static void request_temporary_precise_location_cb(
    const gchar* purpose_key,
    permission_plus_linuxPermissionPlusHostApiResponseHandle* response_handle,
    gpointer user_data) {
  permission_plus_linux_permission_plus_host_api_respond_request_temporary_precise_location(
      response_handle, PERMISSION_PLUS_LINUX_PERMISSION_STATUS_MESSAGE_GRANTED);
}

// ── Plugin Lifecycle ──────────────────────────────────────────────────────

static void permission_plus_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(permission_plus_linux_plugin_parent_class)->dispose(object);
}

static void permission_plus_linux_plugin_class_init(PermissionPlusLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = permission_plus_linux_plugin_dispose;
}

static void permission_plus_linux_plugin_init(PermissionPlusLinuxPlugin* self) {}

void permission_plus_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  PermissionPlusLinuxPlugin* plugin = PERMISSION_PLUS_LINUX_PLUGIN(
      g_object_new(permission_plus_linux_plugin_get_type(), nullptr));
  plugin->registrar = registrar;

  static permission_plus_linuxPermissionPlusHostApiVTable vtable = {
      .check_permission = check_permission_cb,
      .request_permission = request_permission_cb,
      .request_permissions = request_permissions_cb,
      .open_settings = open_settings_cb,
      .should_show_rationale = should_show_rationale_cb,
      .get_location_accuracy = get_location_accuracy_cb,
      .request_temporary_precise_location = request_temporary_precise_location_cb,
  };

  permission_plus_linux_permission_plus_host_api_set_method_handlers(
      fl_plugin_registrar_get_messenger(registrar),
      nullptr, // suffix
      &vtable,
      plugin, // user_data
      nullptr // user_data_free_func
  );

  g_object_unref(plugin);
}
